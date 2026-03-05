// ServiceContainer.swift
// ReSpeak
//
// Central service locator. Owns one instance of every application-wide
// service. Access singletons via `ServiceContainer.shared.*`.

import Foundation

// MARK: - ServiceContainer

/// Central service locator for application-wide services.
final class ServiceContainer {

    // MARK: Singleton

    static let shared = ServiceContainer()

    // MARK: Services

    /// Supabase client wrapper — use for direct SDK access when no
    /// higher-level repository covers the operation.
    let supabase: SupabaseService = .shared

    /// Authentication service — drives routing and exposes the current user.
    let auth: AuthService = AuthService()

    // MARK: Init

    private init() {}
}
