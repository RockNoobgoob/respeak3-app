# ReSpeak Supabase Integration — Agent Memory

## Project Identity
- Repo: /Users/noahhova/Documents/respeak3-app
- Source root: ReSpeak/ (inside repo root)
- Xcode project: ReSpeak.xcodeproj at repo root
- Platform: iOS 17+, SwiftUI only, no UIKit

## Supabase SDK
- Package: https://github.com/supabase/supabase-swift (add via Xcode SPM, not Package.swift)
- Products to add: Supabase, PostgREST, Realtime, Storage (Auth is bundled inside Supabase product)
- Credentials go in Info.plist keys SUPABASE_URL and SUPABASE_ANON_KEY, populated from an .xcconfig

## Architecture Decisions
- AuthService is @MainActor ObservableObject, owned as @StateObject in ReSpeakApp, injected as @EnvironmentObject
- ServiceContainer.shared.auth returns the single AuthService instance
- AppView routes on auth.isAuthenticated (Supabase session), NOT @AppStorage("hasCompletedOnboarding")
- LoginView receives auth via @EnvironmentObject, calls auth.signIn() on tap
- RepositoryContainer.shared holds ExerciseRepository, SessionRepository, RecordingRepository, UserRepository
- PracticeViewModel is @MainActor, @StateObject in PracticeView, uses RepositoryContainer

## Database Schema (Supabase)
Tables (see ReSpeak/supabase/schema.sql for full DDL):
- user_profiles: id, user_id (FK auth.users), display_name, role, avatar_url, created_at, updated_at
- exercise_definitions: id, title, subtitle, duration_label, icon_name, category, is_active, display_order, created_at
- exercise_items: id, exercise_definition_id (FK), prompt, order_index, payload (jsonb), created_at
- exercise_sessions: id, user_id (FK auth.users), exercise_definition_id (FK), started_at, completed_at
- exercise_attempts: id, session_id (FK), exercise_item_id (FK), recording_url, rating (1-5), meta (jsonb), created_at

## Swift Models (ReSpeak/Models/ReSpeakModels.swift)
ExerciseDefinition, ExerciseItem, ExerciseSession, ExerciseAttempt, UserProfile, UserRole, ReSpeakError

## CodingKeys pattern
All models use explicit CodingKeys mapping camelCase Swift <-> snake_case DB columns.
ExerciseDefinition.items maps to "exercise_items" (nested join result).

## Storage
- Bucket: recordings (private)
- Path: {user_id}/{session_id}/{attempt_id}.m4a
- RLS: users can INSERT/SELECT/DELETE only paths where foldername[1] = auth.uid()

## Design Token Files (never use raw values in views)
- BrandColors, BrandTypography, BrandGradients, Spacing, Radii, Shadows — all in ReSpeak/Theme/
- Key: Radii.xl = 24 (used on hero card), Radii.card = 16, Radii.button = 12, Radii.input = 8, Radii.sheet = 24

## File Locations
- Services: ReSpeak/Services/ (SupabaseService.swift, AuthService.swift, ServiceContainer.swift)
- Repositories: ReSpeak/Repositories/ (ExerciseRepository, SessionRepository, RecordingRepository, UserRepository, RepositoryContainer)
- Models: ReSpeak/Models/ReSpeakModels.swift
- SQL: ReSpeak/supabase/schema.sql
- ViewModel: ReSpeak/Features/Practice/PracticeViewModel.swift

## Known Gaps / Next Steps
- Xcode project.pbxproj must be updated to include all new .swift files (do this via Xcode UI)
- SPM Supabase package must be added manually in Xcode (File > Add Package Dependencies)
- Info.plist needs SUPABASE_URL and SUPABASE_ANON_KEY keys
- Exercise session/recording screen not yet built (PracticeViewModel.activeSession is set, no nav destination yet)
- Sign-up flow not implemented (UserRepository.createProfile exists, no UI)
- Forgot password flow is a no-op button in LoginView
