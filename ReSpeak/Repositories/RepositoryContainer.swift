// RepositoryContainer.swift
// ReSpeak
//
// Central locator for all data repository instances.
// Access repositories via `RepositoryContainer.shared.*`.

import Foundation

// MARK: - RepositoryContainer

/// Central locator for data repository instances.
final class RepositoryContainer {

    // MARK: Singleton

    static let shared = RepositoryContainer()

    // MARK: Repositories

    /// Fetches exercise definitions and items from Supabase.
    let exercises: ExerciseRepository = ExerciseRepository()

    /// Creates sessions and logs attempt records in Supabase.
    let sessions: SessionRepository = SessionRepository()

    /// Uploads recordings to Supabase Storage and links them to attempts.
    let recordings: RecordingRepository = RecordingRepository()

    /// Reads and writes user profile rows in Supabase.
    let users: UserRepository = UserRepository()

    // MARK: Init

    private init() {}
}
