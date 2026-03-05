// PracticeView.swift
// ReSpeak
//
// Home screen for the Practice tab. Fetches live exercise data from
// Supabase via PracticeViewModel. Navigates into an exercise session
// after creating a session row on selection.

import SwiftUI

// MARK: - PracticeView

struct PracticeView: View {

    @StateObject private var viewModel = PracticeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                BrandColors.background
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Spacing.sectionGap) {
                        heroCard
                        exerciseSection
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.xl)
                }
                .refreshable {
                    await viewModel.loadExercises()
                }
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadExercises()
            }
        }
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(BrandGradients.primaryGradient)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 120, height: 120)
                .offset(x: 220, y: -20)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Ready to practice?")
                    .font(BrandTypography.title2)
                    .foregroundStyle(BrandColors.onPrimary)

                Text("Complete today's exercises to keep your progress on track.")
                    .font(BrandTypography.subheadline)
                    .foregroundStyle(BrandColors.onPrimary.opacity(0.80))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.lg)
        }
        .frame(height: 140)
        .shadow(
            color: Shadows.elevatedColor,
            radius: Shadows.elevatedRadius,
            x: Shadows.elevatedX,
            y: Shadows.elevatedY
        )
    }

    // MARK: - Exercise Section

    @ViewBuilder
    private var exerciseSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Today's Exercises")
                .font(BrandTypography.title3)
                .foregroundStyle(BrandColors.onBackground)

            switch viewModel.loadState {
            case .idle:
                EmptyView()

            case .loading:
                exerciseLoadingPlaceholder

            case .loaded:
                if viewModel.exercises.isEmpty {
                    emptyState
                } else {
                    exerciseList
                }

            case .error(let message):
                errorState(message: message)
            }
        }
    }

    // MARK: - Exercise List

    private var exerciseList: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(viewModel.exercises) { exercise in
                Button {
                    Task { await viewModel.selectExercise(exercise) }
                } label: {
                    ExerciseRowView(
                        title: exercise.title,
                        subtitle: exercise.subtitle,
                        duration: exercise.durationLabel,
                        iconName: exercise.iconName
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Loading Placeholder

    private var exerciseLoadingPlaceholder: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: Radii.card)
                    .fill(BrandColors.surface)
                    .frame(height: 76)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.card)
                            .fill(BrandColors.surfaceVariant.opacity(0.6))
                    )
                    .cardShadow()
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "tray")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(BrandColors.onBackgroundSecondary)

            Text("No exercises scheduled today.")
                .font(BrandTypography.subheadline)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }

    // MARK: - Error State

    private func errorState(message: String) -> some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(BrandColors.error)

            Text(message)
                .font(BrandTypography.subheadline)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .multilineTextAlignment(.center)

            Button {
                Task { await viewModel.loadExercises() }
            } label: {
                Text("Retry")
                    .font(BrandTypography.button)
                    .foregroundStyle(BrandColors.onPrimary)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.sm)
                    .background(BrandGradients.buttonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: Radii.button))
            }
            .cardShadow()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }
}

// MARK: - Shimmer Modifier

/// Lightweight shimmer animation for skeleton loading cards.
private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear,                           location: phase - 0.3),
                        .init(color: .white.opacity(0.35),             location: phase),
                        .init(color: .clear,                           location: phase + 0.3)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.plusLighter)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.3
                }
            }
            .clipped()
    }
}

private extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Preview

#Preview {
    PracticeView()
}
