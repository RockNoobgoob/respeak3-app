// ReSpeakModels.swift
// ReSpeak
//
// Domain model structs shared across features. Every struct conforms to
// Codable so it maps directly to Supabase JSON responses. Column names
// follow snake_case to match the PostgreSQL schema; Swift property names
// use camelCase via CodingKeys.
//
// No UIKit or SwiftUI imports — this file must remain UI-free.

import Foundation

// MARK: - Error Domain

/// Domain-specific errors raised by ReSpeak services and repositories.
public enum ReSpeakError: LocalizedError {

    case notAuthenticated
    case exerciseFetchFailed(underlying: Error)
    case sessionCreateFailed(underlying: Error)
    case profileFetchFailed(underlying: Error)
    case profileUpdateFailed(underlying: Error)
    case recordingUploadFailed(underlying: Error)
    case recordingURLUpdateFailed(underlying: Error)
    case attemptLogFailed(underlying: Error)
    case unknown(underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be signed in to continue."
        case .exerciseFetchFailed(let e):
            return "Could not load exercises: \(e.localizedDescription)"
        case .sessionCreateFailed(let e):
            return "Could not start session: \(e.localizedDescription)"
        case .profileFetchFailed(let e):
            return "Could not load your profile: \(e.localizedDescription)"
        case .profileUpdateFailed(let e):
            return "Could not save your profile: \(e.localizedDescription)"
        case .recordingUploadFailed(let e):
            return "Could not upload recording: \(e.localizedDescription)"
        case .recordingURLUpdateFailed(let e):
            return "Could not save recording reference: \(e.localizedDescription)"
        case .attemptLogFailed(let e):
            return "Could not log attempt: \(e.localizedDescription)"
        case .unknown(let e):
            return e.localizedDescription
        }
    }
}

// MARK: - ExerciseDefinition

/// A speech therapy exercise definition as stored in `exercise_definitions`.
public struct ExerciseDefinition: Codable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let subtitle: String
    /// Estimated duration label shown in the UI, e.g. "5 min".
    public let durationLabel: String
    /// SF Symbol name for the exercise icon.
    public let iconName: String
    public let category: String
    public let isActive: Bool
    public let displayOrder: Int
    public let createdAt: Date

    /// Child items describing the individual prompts within this exercise.
    /// Populated via a joined query; may be empty if the exercise has no items yet.
    public var items: [ExerciseItem]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case durationLabel  = "duration_label"
        case iconName       = "icon_name"
        case category
        case isActive       = "is_active"
        case displayOrder   = "display_order"
        case createdAt      = "created_at"
        case items          = "exercise_items"
    }
}

// MARK: - ExerciseItem

/// A single prompt or step within an `ExerciseDefinition`.
/// Stored in `exercise_items`.
public struct ExerciseItem: Codable, Identifiable, Sendable {
    public let id: UUID
    public let exerciseDefinitionId: UUID
    public let prompt: String
    public let orderIndex: Int
    /// Arbitrary JSON payload for item-specific config (optional).
    public let payload: [String: String]?
    public let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case exerciseDefinitionId = "exercise_definition_id"
        case prompt
        case orderIndex           = "order_index"
        case payload
        case createdAt            = "created_at"
    }
}

// MARK: - ExerciseSession

/// A single practice session record in `exercise_sessions`.
public struct ExerciseSession: Codable, Identifiable, Sendable {
    public let id: UUID
    public let userId: UUID
    public let exerciseDefinitionId: UUID
    public let startedAt: Date
    public var completedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case userId                 = "user_id"
        case exerciseDefinitionId   = "exercise_definition_id"
        case startedAt              = "started_at"
        case completedAt            = "completed_at"
    }
}

// MARK: - ExerciseAttempt

/// One recorded attempt at an exercise item within a session.
/// Stored in `exercise_attempts`.
public struct ExerciseAttempt: Codable, Identifiable, Sendable {
    public let id: UUID
    public let sessionId: UUID
    public let exerciseItemId: UUID
    public var recordingUrl: String?
    /// User self-rating (1–5), set after playback.
    public var rating: Int?
    /// Arbitrary JSON metadata (pitch, duration, etc.).
    public var meta: [String: String]?
    public let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case sessionId      = "session_id"
        case exerciseItemId = "exercise_item_id"
        case recordingUrl   = "recording_url"
        case rating
        case meta
        case createdAt      = "created_at"
    }
}

// MARK: - UserProfile

/// A user's profile row in `user_profiles`.
public struct UserProfile: Codable, Identifiable, Sendable {
    public let id: UUID
    public let userId: UUID
    public var displayName: String
    public var role: UserRole
    public var avatarUrl: String?
    public let createdAt: Date
    public var updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case userId      = "user_id"
        case displayName = "display_name"
        case role
        case avatarUrl   = "avatar_url"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
    }
}

// MARK: - UserRole

/// The role a user holds within the ReSpeak platform.
public enum UserRole: String, Codable, Sendable {
    case patient
    case clinician
    case admin
}
