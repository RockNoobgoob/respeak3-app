-- =============================================================================
-- ReSpeak — Supabase Database Schema
-- =============================================================================
-- Run this entire script in the Supabase SQL Editor (single pass).
-- All tables use:
--   • UUID primary keys via gen_random_uuid()
--   • created_at TIMESTAMPTZ DEFAULT now()
--   • Row-Level Security enabled with policies for authenticated users
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 0. Extensions
-- ---------------------------------------------------------------------------

-- pgcrypto is usually pre-enabled in Supabase; kept here for completeness.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ---------------------------------------------------------------------------
-- 1. user_profiles
-- ---------------------------------------------------------------------------
-- One row per auth.users entry. Created immediately after sign-up.
-- The `user_id` column references auth.users(id) so Supabase Auth is the
-- source of truth for identity; this table holds app-level metadata only.

CREATE TABLE IF NOT EXISTS public.user_profiles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL DEFAULT '',
    role        TEXT NOT NULL DEFAULT 'patient'
                    CHECK (role IN ('patient', 'clinician', 'admin')),
    avatar_url  TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_profiles_user_id_unique UNIQUE (user_id)
);

CREATE INDEX IF NOT EXISTS user_profiles_user_id_idx
    ON public.user_profiles (user_id);

-- RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Authenticated users may read their own profile.
CREATE POLICY "user_profiles_select_own"
    ON public.user_profiles
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- Authenticated users may insert their own profile (once, on sign-up).
CREATE POLICY "user_profiles_insert_own"
    ON public.user_profiles
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Authenticated users may update their own profile.
CREATE POLICY "user_profiles_update_own"
    ON public.user_profiles
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- 2. exercise_definitions
-- ---------------------------------------------------------------------------
-- Master catalogue of speech therapy exercises. Populated by clinicians /
-- admins; patients have read-only access.

CREATE TABLE IF NOT EXISTS public.exercise_definitions (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title          TEXT NOT NULL,
    subtitle       TEXT NOT NULL DEFAULT '',
    duration_label TEXT NOT NULL DEFAULT '',   -- e.g. "5 min"
    icon_name      TEXT NOT NULL DEFAULT 'waveform', -- SF Symbol name
    category       TEXT NOT NULL DEFAULT 'general',
    is_active      BOOLEAN NOT NULL DEFAULT true,
    display_order  INT NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS exercise_definitions_is_active_idx
    ON public.exercise_definitions (is_active);
CREATE INDEX IF NOT EXISTS exercise_definitions_display_order_idx
    ON public.exercise_definitions (display_order);

-- RLS
ALTER TABLE public.exercise_definitions ENABLE ROW LEVEL SECURITY;

-- All authenticated users may read active exercises.
CREATE POLICY "exercise_definitions_select_authenticated"
    ON public.exercise_definitions
    FOR SELECT
    TO authenticated
    USING (true);

-- Only admins / clinicians may insert or update exercises.
-- Enforce this at the application layer for now; tighten with a role check
-- once Supabase custom claims or a roles table is in place.
CREATE POLICY "exercise_definitions_insert_admin"
    ON public.exercise_definitions
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "exercise_definitions_update_admin"
    ON public.exercise_definitions
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- ---------------------------------------------------------------------------
-- 3. exercise_items
-- ---------------------------------------------------------------------------
-- Individual prompts / steps within an exercise definition.
-- The `payload` JSONB column holds item-specific config
-- (e.g. target phoneme, BPM, reference audio URL).

CREATE TABLE IF NOT EXISTS public.exercise_items (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exercise_definition_id  UUID NOT NULL
                                REFERENCES public.exercise_definitions(id)
                                ON DELETE CASCADE,
    prompt                  TEXT NOT NULL,
    order_index             INT NOT NULL DEFAULT 0,
    payload                 JSONB,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS exercise_items_definition_id_idx
    ON public.exercise_items (exercise_definition_id);

-- RLS
ALTER TABLE public.exercise_items ENABLE ROW LEVEL SECURITY;

-- All authenticated users may read exercise items.
CREATE POLICY "exercise_items_select_authenticated"
    ON public.exercise_items
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "exercise_items_insert_admin"
    ON public.exercise_items
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "exercise_items_update_admin"
    ON public.exercise_items
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- ---------------------------------------------------------------------------
-- 4. exercise_sessions
-- ---------------------------------------------------------------------------
-- One row per practice session. Created when a user taps an exercise;
-- `completed_at` is stamped when they finish.

CREATE TABLE IF NOT EXISTS public.exercise_sessions (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    exercise_definition_id  UUID NOT NULL
                                REFERENCES public.exercise_definitions(id)
                                ON DELETE RESTRICT,
    started_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS exercise_sessions_user_id_idx
    ON public.exercise_sessions (user_id);
CREATE INDEX IF NOT EXISTS exercise_sessions_definition_id_idx
    ON public.exercise_sessions (exercise_definition_id);

-- RLS
ALTER TABLE public.exercise_sessions ENABLE ROW LEVEL SECURITY;

-- Users may read their own sessions.
CREATE POLICY "exercise_sessions_select_own"
    ON public.exercise_sessions
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- Users may create sessions for themselves.
CREATE POLICY "exercise_sessions_insert_own"
    ON public.exercise_sessions
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Users may update their own sessions (e.g. stamp completed_at).
CREATE POLICY "exercise_sessions_update_own"
    ON public.exercise_sessions
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- 5. exercise_attempts
-- ---------------------------------------------------------------------------
-- One row per recorded attempt at an exercise item within a session.
-- `recording_url` is populated after the audio file is uploaded to Storage.
-- `rating` is a 1–5 self-assessment set by the patient after playback.
-- `meta` holds optional telemetry (pitch, duration, silence ratio, etc.).

CREATE TABLE IF NOT EXISTS public.exercise_attempts (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id        UUID NOT NULL
                          REFERENCES public.exercise_sessions(id)
                          ON DELETE CASCADE,
    exercise_item_id  UUID NOT NULL
                          REFERENCES public.exercise_items(id)
                          ON DELETE RESTRICT,
    recording_url     TEXT,
    rating            SMALLINT CHECK (rating BETWEEN 1 AND 5),
    meta              JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS exercise_attempts_session_id_idx
    ON public.exercise_attempts (session_id);
CREATE INDEX IF NOT EXISTS exercise_attempts_item_id_idx
    ON public.exercise_attempts (exercise_item_id);

-- RLS
-- Attempts are owned by the user who owns the parent session.
-- We join through exercise_sessions to resolve ownership.
ALTER TABLE public.exercise_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "exercise_attempts_select_own"
    ON public.exercise_attempts
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.exercise_sessions s
            WHERE s.id = session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "exercise_attempts_insert_own"
    ON public.exercise_attempts
    FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.exercise_sessions s
            WHERE s.id = session_id
              AND s.user_id = auth.uid()
        )
    );

CREATE POLICY "exercise_attempts_update_own"
    ON public.exercise_attempts
    FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.exercise_sessions s
            WHERE s.id = session_id
              AND s.user_id = auth.uid()
        )
    );

-- ---------------------------------------------------------------------------
-- 6. Storage Bucket — recordings
-- ---------------------------------------------------------------------------
-- Run these statements to create the private Storage bucket and its access
-- policies. The SQL Storage API maps to the Supabase Storage tables in the
-- `storage` schema.

-- Create the bucket (private — no public read without a policy).
INSERT INTO storage.buckets (id, name, public)
VALUES ('recordings', 'recordings', false)
ON CONFLICT (id) DO NOTHING;

-- Storage policy: authenticated users may upload to their own user_id prefix.
-- Path pattern: recordings/{user_id}/{session_id}/{attempt_id}.m4a
CREATE POLICY "recordings_insert_own"
    ON storage.objects
    FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'recordings'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Storage policy: authenticated users may read their own recordings.
CREATE POLICY "recordings_select_own"
    ON storage.objects
    FOR SELECT
    TO authenticated
    USING (
        bucket_id = 'recordings'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Storage policy: authenticated users may delete their own recordings.
CREATE POLICY "recordings_delete_own"
    ON storage.objects
    FOR DELETE
    TO authenticated
    USING (
        bucket_id = 'recordings'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- ---------------------------------------------------------------------------
-- 7. Seed Data — exercise_definitions + exercise_items
-- ---------------------------------------------------------------------------
-- Minimal seed to populate the exercise list in PracticeView.
-- Adjust or extend as the clinical content grows.

INSERT INTO public.exercise_definitions
    (title, subtitle, duration_label, icon_name, category, display_order)
VALUES
    ('Vowel Stretches',  'Warm up your vocal range',          '5 min',  'waveform',  'warmup',   1),
    ('Breath Control',   'Diaphragmatic breathing rhythm',    '8 min',  'wind',      'breathing',2),
    ('Rhythm Pacing',    'Metered speech cadence',            '6 min',  'metronome', 'fluency',  3)
ON CONFLICT DO NOTHING;

-- Seed items for Vowel Stretches (first definition — uses a subquery for the FK).
INSERT INTO public.exercise_items
    (exercise_definition_id, prompt, order_index)
SELECT
    id,
    unnest(ARRAY[
        'Sustain "aah" for 5 seconds',
        'Sustain "ee" for 5 seconds',
        'Sustain "oh" for 5 seconds',
        'Sustain "oo" for 5 seconds'
    ]),
    generate_series(1, 4)
FROM public.exercise_definitions
WHERE title = 'Vowel Stretches'
ON CONFLICT DO NOTHING;

-- Seed items for Breath Control.
INSERT INTO public.exercise_items
    (exercise_definition_id, prompt, order_index)
SELECT
    id,
    unnest(ARRAY[
        'Inhale slowly for 4 counts',
        'Hold for 4 counts',
        'Exhale slowly for 8 counts',
        'Repeat 3 times'
    ]),
    generate_series(1, 4)
FROM public.exercise_definitions
WHERE title = 'Breath Control'
ON CONFLICT DO NOTHING;

-- Seed items for Rhythm Pacing.
INSERT INTO public.exercise_items
    (exercise_definition_id, prompt, order_index)
SELECT
    id,
    unnest(ARRAY[
        'Say "ba-ba-ba" at 60 BPM',
        'Say "pa-pa-pa" at 80 BPM',
        'Say "ta-ta-ta" at 100 BPM'
    ]),
    generate_series(1, 3)
FROM public.exercise_definitions
WHERE title = 'Rhythm Pacing'
ON CONFLICT DO NOTHING;
