// AuthService.swift
// ReSpeak
//
// Wraps Supabase Auth operations used by the app. Publishes the current
// authentication state so SwiftUI views can reactively route to login or
// the main tab shell.
//
// No UIKit or SwiftUI layout imports — this file contains only Foundation
// + Combine + the Supabase SDK.

import Foundation
import Combine
import Supabase

// MARK: - AuthService

/// Observable object that owns the current Supabase auth session and exposes
/// sign-in / sign-out operations. Inject via `ServiceContainer`.
@MainActor
final class AuthService: ObservableObject {

    // MARK: Published State

    /// The currently authenticated user, or `nil` if signed out.
    @Published private(set) var currentUser: User?

    /// `true` while an auth operation (sign-in / sign-out) is in progress.
    @Published private(set) var isLoading: Bool = false

    /// The most recent auth error, cleared on each new operation.
    @Published private(set) var authError: String?

    // MARK: Computed

    /// Convenience flag consumed by `AppView` to drive routing.
    var isAuthenticated: Bool { currentUser != nil }

    // MARK: Dependencies

    private let supabase: SupabaseService

    // MARK: Init

    init(supabase: SupabaseService = .shared) {
        self.supabase = supabase
        // Restore session synchronously from the SDK's persisted keychain token.
        Task { await restoreSession() }
    }

    // MARK: - Session Restoration

    /// Attempts to restore a persisted Supabase session on app launch.
    private func restoreSession() async {
        do {
            let session = try await supabase.auth.session
            currentUser = session.user
        } catch {
            // No persisted session — user needs to sign in.
            currentUser = nil
        }
    }

    // MARK: - Sign In

    /// Signs in with email and password via Supabase Auth.
    /// Sets `currentUser` on success; sets `authError` on failure.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    func signIn(email: String, password: String) async {
        isLoading = true
        authError = nil
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            currentUser = session.user
        } catch {
            authError = error.localizedDescription
            currentUser = nil
        }
    }

    // MARK: - Sign Out

    /// Signs the current user out and clears the local session.
    func signOut() async {
        isLoading = true
        authError = nil
        defer { isLoading = false }

        do {
            try await supabase.auth.signOut()
            currentUser = nil
        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Current User ID

    /// Returns the UUID of the currently authenticated user, or throws
    /// `ReSpeakError.notAuthenticated` if no session exists.
    func requireUserId() throws -> UUID {
        guard let user = currentUser else {
            throw ReSpeakError.notAuthenticated
        }
        return user.id
    }
}
