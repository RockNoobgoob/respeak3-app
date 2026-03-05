// SupabaseService.swift
// ReSpeak
//
// Central Supabase client wrapper. Initialised once at app startup via
// ServiceContainer. All repositories and view models access Supabase
// exclusively through this object.
//
// CONFIGURATION — before building:
//   1. Open ReSpeak/Config/ReSpeak.xcconfig (create if absent).
//   2. Add two entries:
//        SUPABASE_URL = https://your-project-ref.supabase.co
//        SUPABASE_ANON_KEY = your-anon-key-here
//   3. In the Xcode target's Build Settings → All, set
//        "Swift Active Compilation Conditions" to include DEBUG for debug,
//        and reference these via Info.plist if you prefer a plist-based approach.
//
//   Alternatively, create a file ReSpeak/Config/Secrets.swift (git-ignored)
//   containing:
//        enum SupabaseConfig {
//            static let url    = "https://your-project-ref.supabase.co"
//            static let anonKey = "your-anon-key-here"
//        }
//   and replace the Bundle lookups below with SupabaseConfig.url / .anonKey.
//
// NEVER commit real credentials to version control.

import Foundation
import Supabase

// MARK: - SupabaseService

/// Singleton wrapper around `SupabaseClient`.
/// All network traffic to Supabase flows through this instance.
final class SupabaseService: @unchecked Sendable {

    // MARK: Singleton

    static let shared = SupabaseService()

    // MARK: Public Client

    /// The configured Supabase client. Use this to access `.auth`, `.from()`,
    /// `.storage`, and `.realtime`.
    let client: SupabaseClient

    // MARK: Init

    private init() {
        // Read credentials from Info.plist keys SUPABASE_URL and SUPABASE_ANON_KEY.
        // These keys must be added to your Info.plist and populated via an
        // .xcconfig file or a build phase script — never hardcode them here.
        let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
                        ?? "https://YOUR_PROJECT_REF.supabase.co"
        let anonKey   = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String
                        ?? "YOUR_SUPABASE_ANON_KEY"

        guard let url = URL(string: urlString) else {
            fatalError(
                """
                [SupabaseService] Invalid SUPABASE_URL '\(urlString)'.
                Add SUPABASE_URL to your Info.plist (populated from an .xcconfig).
                """
            )
        }

        client = SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }

    // MARK: Convenience Accessors

    /// Supabase Auth client shorthand.
    var auth: AuthClient { client.auth }

    /// Returns a PostgREST query builder for the given table name.
    func from(_ table: String) -> PostgrestQueryBuilder {
        client.from(table)
    }

    /// Supabase Storage client shorthand.
    var storage: SupabaseStorageClient { client.storage }
}
