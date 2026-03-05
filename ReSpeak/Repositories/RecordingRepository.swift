// RecordingRepository.swift
// ReSpeak
//
// Handles audio recording uploads to Supabase Storage and updates the
// associated attempt row with the resulting URL.
// No UIKit or SwiftUI imports — UI-free data layer only.

import Foundation
import Supabase

// MARK: - RecordingRepository

/// Repository responsible for uploading audio recordings to the
/// `recordings` Storage bucket and linking them to attempt rows.
final class RecordingRepository: Sendable {

    // MARK: - Constants

    /// Name of the Supabase Storage bucket that holds all recordings.
    private let bucket = "recordings"

    // MARK: Dependencies

    private let supabase: SupabaseService

    // MARK: Init

    init(supabase: SupabaseService = .shared) {
        self.supabase = supabase
    }

    // MARK: - Upload Recording

    /// Uploads an audio recording to Supabase Storage and returns its
    /// public-accessible URL.
    ///
    /// Storage path pattern:
    /// ```
    /// recordings/{user_id}/{session_id}/{attempt_id}.m4a
    /// ```
    ///
    /// - Parameters:
    ///   - data: Raw audio bytes (M4A / AAC format from AVAudioRecorder).
    ///   - userId: UUID of the authenticated user (path scoping for RLS).
    ///   - sessionId: UUID of the parent `exercise_sessions` row.
    ///   - attemptId: UUID of the `exercise_attempts` row this recording belongs to.
    /// - Returns: The public URL of the uploaded file.
    /// - Throws: `ReSpeakError.recordingUploadFailed` wrapping the underlying error.
    func uploadRecording(
        data: Data,
        userId: UUID,
        sessionId: UUID,
        attemptId: UUID
    ) async throws -> URL {
        let path = "\(userId.uuidString)/\(sessionId.uuidString)/\(attemptId.uuidString).m4a"

        do {
            try await supabase.storage
                .from(bucket)
                .upload(
                    path,
                    data: data,
                    options: FileOptions(contentType: "audio/m4a", upsert: false)
                )

            // Build the public URL directly — the bucket must have the
            // correct Storage policy granting authenticated read access.
            let publicURL = try supabase.storage
                .from(bucket)
                .getPublicURL(path: path)

            return publicURL
        } catch {
            throw ReSpeakError.recordingUploadFailed(underlying: error)
        }
    }

    // MARK: - Update Attempt Recording URL

    /// Persists the recording URL on the `exercise_attempts` row after a
    /// successful upload.
    ///
    /// - Parameters:
    ///   - attemptId: The UUID of the attempt to update.
    ///   - url: The public URL returned by `uploadRecording(...)`.
    /// - Throws: `ReSpeakError.recordingURLUpdateFailed` wrapping the underlying error.
    func updateAttemptRecordingURL(attemptId: UUID, url: URL) async throws {
        do {
            struct Update: Encodable {
                let recording_url: String
            }

            let payload = Update(recording_url: url.absoluteString)

            try await supabase
                .from("exercise_attempts")
                .update(payload)
                .eq("id", value: attemptId.uuidString)
                .execute()
        } catch {
            throw ReSpeakError.recordingURLUpdateFailed(underlying: error)
        }
    }
}
