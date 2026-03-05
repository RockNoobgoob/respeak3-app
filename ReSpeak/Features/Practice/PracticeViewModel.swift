// PracticeViewModel.swift
// ReSpeak
//
// ViewModel for PracticeView. Fetches live exercises from Supabase and
// exposes loading / error / loaded states. Session creation is triggered
// when the user selects an exercise.

import Foundation

// MARK: - PracticeViewModel

/// Observable view model for the Practice tab.
/// All mutations happen on the `@MainActor` to keep UI state thread-safe.
@MainActor
final class PracticeViewModel: ObservableObject {

    // MARK: - View State

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)

        static func == (lhs: LoadState, rhs: LoadState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
                return true
            case (.error(let a), .error(let b)):
                return a == b
            default:
                return false
            }
        }
    }

    // MARK: Published

    @Published private(set) var exercises: [ExerciseDefinition] = []
    @Published private(set) var loadState: LoadState = .idle
    /// Set when a session row has been created for the selected exercise.
    @Published private(set) var activeSession: ExerciseSession?

    // MARK: Dependencies

    private let exerciseRepo: ExerciseRepository
    private let sessionRepo: SessionRepository
    private let auth: AuthService

    // MARK: Init

    init(
        exerciseRepo: ExerciseRepository = RepositoryContainer.shared.exercises,
        sessionRepo: SessionRepository   = RepositoryContainer.shared.sessions,
        auth: AuthService                = ServiceContainer.shared.auth
    ) {
        self.exerciseRepo = exerciseRepo
        self.sessionRepo  = sessionRepo
        self.auth         = auth
    }

    // MARK: - Load Exercises

    /// Fetches all active exercises from Supabase.
    /// Safe to call multiple times (e.g. on pull-to-refresh).
    func loadExercises() async {
        guard loadState != .loading else { return }
        loadState = .loading

        do {
            let fetched = try await exerciseRepo.fetchExercises()
            exercises = fetched
            loadState = .loaded
        } catch let error as ReSpeakError {
            loadState = .error(error.errorDescription ?? "Unknown error")
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }

    // MARK: - Select Exercise

    /// Creates an `exercise_sessions` row when the user taps an exercise.
    /// The resulting `ExerciseSession` is stored in `activeSession` and can
    /// be passed to the downstream session/recording screen.
    ///
    /// - Parameter exercise: The tapped `ExerciseDefinition`.
    func selectExercise(_ exercise: ExerciseDefinition) async {
        guard let userId = try? auth.requireUserId() else { return }

        do {
            let session = try await sessionRepo.createSession(
                exerciseId: exercise.id,
                userId: userId
            )
            activeSession = session
        } catch let error as ReSpeakError {
            // Surface the error without blocking the rest of the UI.
            loadState = .error(error.errorDescription ?? "Could not start session")
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }
}
