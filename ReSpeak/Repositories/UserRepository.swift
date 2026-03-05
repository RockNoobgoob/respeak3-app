// UserRepository.swift
// ReSpeak
//
// Fetches and updates user profile rows from `user_profiles`.
// No UIKit or SwiftUI imports — UI-free data layer only.

import Foundation
import Supabase

// MARK: - UserRepository

/// Repository responsible for reading and writing user profile data.
final class UserRepository: Sendable {

    // MARK: Dependencies

    private let supabase: SupabaseService

    // MARK: Init

    init(supabase: SupabaseService = .shared) {
        self.supabase = supabase
    }

    // MARK: - Fetch Profile

    /// Fetches the `user_profiles` row for the given user UUID.
    ///
    /// - Parameter userId: The UUID of the authenticated user.
    /// - Returns: A `UserProfile` if a row exists.
    /// - Throws: `ReSpeakError.profileFetchFailed` wrapping the underlying error.
    func fetchProfile(userId: UUID) async throws -> UserProfile {
        do {
            let profile: UserProfile = try await supabase
                .from("user_profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .single()
                .execute()
                .value

            return profile
        } catch {
            throw ReSpeakError.profileFetchFailed(underlying: error)
        }
    }

    // MARK: - Update Profile

    /// Updates mutable fields on the `user_profiles` row.
    ///
    /// - Parameter profile: A `UserProfile` with updated fields.
    ///   Only `display_name`, `avatar_url`, and `role` are written;
    ///   server-generated fields are ignored.
    /// - Throws: `ReSpeakError.profileUpdateFailed` wrapping the underlying error.
    func updateProfile(_ profile: UserProfile) async throws {
        do {
            struct Update: Encodable {
                let display_name: String
                let role: String
                let avatar_url: String?
                let updated_at: String
            }

            let iso = ISO8601DateFormatter()
            let payload = Update(
                display_name: profile.displayName,
                role: profile.role.rawValue,
                avatar_url: profile.avatarUrl,
                updated_at: iso.string(from: Date())
            )

            try await supabase
                .from("user_profiles")
                .update(payload)
                .eq("user_id", value: profile.userId.uuidString)
                .execute()
        } catch {
            throw ReSpeakError.profileUpdateFailed(underlying: error)
        }
    }

    // MARK: - Create Profile

    /// Inserts a new `user_profiles` row. Call this immediately after a
    /// successful Supabase Auth sign-up to initialise the profile.
    ///
    /// - Parameters:
    ///   - userId: The UUID from `auth.users` (must match the auth session).
    ///   - displayName: The user's chosen display name.
    ///   - role: The user's role within the platform.
    /// - Returns: The newly created `UserProfile`.
    /// - Throws: `ReSpeakError.profileUpdateFailed` wrapping the underlying error.
    func createProfile(
        userId: UUID,
        displayName: String,
        role: UserRole = .patient
    ) async throws -> UserProfile {
        do {
            struct Insert: Encodable {
                let user_id: String
                let display_name: String
                let role: String
            }

            let payload = Insert(
                user_id: userId.uuidString,
                display_name: displayName,
                role: role.rawValue
            )

            let profile: UserProfile = try await supabase
                .from("user_profiles")
                .insert(payload)
                .select()
                .single()
                .execute()
                .value

            return profile
        } catch {
            throw ReSpeakError.profileUpdateFailed(underlying: error)
        }
    }
}
