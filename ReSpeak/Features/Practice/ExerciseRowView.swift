// ExerciseRowView.swift
// ReSpeak
// Created: 2026-03-05
//
// Reusable card row representing a single speech therapy exercise.
// Used inside PracticeView's exercise list.

import SwiftUI

// MARK: - ExerciseRowView

struct ExerciseRowView: View {

    let title: String
    let subtitle: String
    let duration: String
    let iconName: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            iconCircle
            labelStack
            Spacer()
            durationBadge
        }
        .padding(Spacing.md)
        .background(BrandColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radii.card))
        .shadow(
            color: Shadows.cardColor,
            radius: Shadows.cardRadius,
            x: Shadows.cardX,
            y: Shadows.cardY
        )
    }

    // MARK: - Subviews

    private var iconCircle: some View {
        ZStack {
            Circle()
                .fill(BrandColors.primary)
                .frame(width: 44, height: 44)
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(BrandColors.onPrimary)
        }
    }

    private var labelStack: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(title)
                .font(BrandTypography.headline)
                .foregroundStyle(BrandColors.onBackground)
            Text(subtitle)
                .font(BrandTypography.subheadline)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        }
    }

    private var durationBadge: some View {
        Text(duration)
            .font(BrandTypography.caption1)
            .foregroundStyle(BrandColors.primary)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs)
            .background(BrandColors.primary.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(BrandColors.primary.opacity(0.25), lineWidth: 1)
            )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.md) {
        ExerciseRowView(
            title: "Vowel Stretches",
            subtitle: "Warm up your vocal range",
            duration: "5 min",
            iconName: "waveform"
        )
        ExerciseRowView(
            title: "Breath Control",
            subtitle: "Diaphragmatic breathing rhythm",
            duration: "8 min",
            iconName: "wind"
        )
        ExerciseRowView(
            title: "Rhythm Pacing",
            subtitle: "Metered speech cadence",
            duration: "6 min",
            iconName: "metronome"
        )
    }
    .padding(Spacing.screenHorizontal)
    .background(BrandColors.background)
}
