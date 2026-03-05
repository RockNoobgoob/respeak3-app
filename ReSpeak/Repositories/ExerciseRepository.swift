// ExerciseRepository.swift
// ReSpeak
//
// Fetches exercise definitions and their child items from Supabase.
// No UIKit or SwiftUI imports — UI-free data layer only.

import Foundation
import Supabase

// MARK: - ExerciseRepository

/// Repository responsible for reading exercise definitions from Supabase.
final class ExerciseRepository: Sendable {

    // MARK: Dependencies

    private let supabase: SupabaseService

    // MARK: Init

    init(supabase: SupabaseService = .shared) {
        self.supabase = supabase
    }

    // MARK: - Fetch Exercises

    /// Fetches all active exercise definitions ordered by `display_order`,
    /// including their nested `exercise_items`.
    ///
    /// - Returns: An ordered array of `ExerciseDefinition` values.
    /// - Throws: `ReSpeakError.exerciseFetchFailed` wrapping the underlying error.
    func fetchExercises() async throws -> [ExerciseDefinition] {
        do {
            let exercises: [ExerciseDefinition] = try await supabase
                .from("exercise_definitions")
                .select(
                    """
                    id,
                    title,
                    subtitle,
                    duration_label,
                    icon_name,
                    category,
                    is_active,
                    display_order,
                    created_at,
                    exercise_items (
                        id,
                        exercise_definition_id,
                        prompt,
                        order_index,
                        payload,
                        created_at
                    )
                    """
                )
                .eq("is_active", value: true)
                .order("display_order", ascending: true)
                .execute()
                .value

            return exercises
        } catch {
            throw ReSpeakError.exerciseFetchFailed(underlying: error)
        }
    }

    // MARK: - Fetch Single Exercise

    /// Fetches a single exercise definition by its UUID, including child items.
    ///
    /// - Parameter id: The UUID of the exercise definition.
    /// - Returns: An `ExerciseDefinition` if found.
    /// - Throws: `ReSpeakError.exerciseFetchFailed` wrapping the underlying error.
    func fetchExercise(id: UUID) async throws -> ExerciseDefinition {
        do {
            let exercise: ExerciseDefinition = try await supabase
                .from("exercise_definitions")
                .select(
                    """
                    id,
                    title,
                    subtitle,
                    duration_label,
                    icon_name,
                    category,
                    is_active,
                    display_order,
                    created_at,
                    exercise_items (
                        id,
                        exercise_definition_id,
                        prompt,
                        order_index,
                        payload,
                        created_at
                    )
                    """
                )
                .eq("id", value: id.uuidString)
                .single()
                .execute()
                .value

            return exercise
        } catch {
            throw ReSpeakError.exerciseFetchFailed(underlying: error)
        }
    }
}
