// ThemeDemoView.swift
// ReSpeak
// Created: 2026-03-01
//
// A scrollable visual catalog of every theme token defined in the
// HovaRehab / ReSpeak design system. Use this view during development to
// verify colors, typography, gradients, spacing, corner radii, and shadows
// before integrating them into real product screens.
//
// This view is intentionally standalone — it does not depend on any ViewModel
// or business logic.

import SwiftUI

// MARK: - ThemeDemoView

struct ThemeDemoView: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.sectionGap) {

                    // -------------------------------------------------------
                    // MARK: Colors
                    // -------------------------------------------------------
                    DemoSection(title: "Colors") {
                        colorGrid
                    }

                    // -------------------------------------------------------
                    // MARK: Typography
                    // -------------------------------------------------------
                    DemoSection(title: "Typography") {
                        typographySpecimen
                    }

                    // -------------------------------------------------------
                    // MARK: Gradients
                    // -------------------------------------------------------
                    DemoSection(title: "Gradients") {
                        gradientPreviews
                    }

                    // -------------------------------------------------------
                    // MARK: Spacing
                    // -------------------------------------------------------
                    DemoSection(title: "Spacing Scale") {
                        spacingScale
                    }

                    // -------------------------------------------------------
                    // MARK: Corner Radii
                    // -------------------------------------------------------
                    DemoSection(title: "Corner Radii") {
                        radiiPreviews
                    }

                    // -------------------------------------------------------
                    // MARK: Shadows
                    // -------------------------------------------------------
                    DemoSection(title: "Shadows") {
                        shadowPreviews
                    }

                    // -------------------------------------------------------
                    // MARK: Combined Components
                    // -------------------------------------------------------
                    DemoSection(title: "Combined Components") {
                        combinedComponents
                    }

                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.vertical, Spacing.lg)
            }
            .background(BrandGradients.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Theme Demo")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Color Grid

    private var colorGrid: some View {
        let tokens: [(String, Color)] = [
            ("primary",             BrandColors.primary),
            ("secondary",           BrandColors.secondary),
            ("accent",              BrandColors.accent),
            ("background",          BrandColors.background),
            ("surface",             BrandColors.surface),
            ("surfaceVariant",      BrandColors.surfaceVariant),
            ("onPrimary",           BrandColors.onPrimary),
            ("onBackground",        BrandColors.onBackground),
            ("onBg Secondary",      BrandColors.onBackgroundSecondary),
            ("error",               BrandColors.error),
            ("success",             BrandColors.success),
            ("warning",             BrandColors.warning),
            ("info",                BrandColors.info),
            ("border",              BrandColors.border),
            ("disabled",            BrandColors.disabled),
        ]

        return LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
            spacing: Spacing.sm
        ) {
            ForEach(tokens, id: \.0) { name, color in
                ColorSwatch(name: name, color: color)
            }
        }
    }

    // MARK: - Typography Specimen

    private var typographySpecimen: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            TypographyRow(label: "largeTitle  34 Bold",   font: BrandTypography.largeTitle)
            TypographyRow(label: "title1  28 Bold",       font: BrandTypography.title1)
            TypographyRow(label: "title2  22 Semibold",   font: BrandTypography.title2)
            TypographyRow(label: "title3  20 Semibold",   font: BrandTypography.title3)
            TypographyRow(label: "headline  17 Semibold", font: BrandTypography.headline)
            TypographyRow(label: "body  17 Regular",      font: BrandTypography.body)
            TypographyRow(label: "callout  16 Regular",   font: BrandTypography.callout)
            TypographyRow(label: "subheadline  15",       font: BrandTypography.subheadline)
            TypographyRow(label: "footnote  13",          font: BrandTypography.footnote)
            TypographyRow(label: "caption1  12",          font: BrandTypography.caption1)
            TypographyRow(label: "caption2  11",          font: BrandTypography.caption2)
        }
    }

    // MARK: - Gradient Previews

    private var gradientPreviews: some View {
        VStack(spacing: Spacing.sm) {
            GradientSwatch(name: "primaryGradient",    gradient: AnyShapeStyle(BrandGradients.primaryGradient))
            GradientSwatch(name: "heroGradient",       gradient: AnyShapeStyle(BrandGradients.heroGradient))
            GradientSwatch(name: "accentGradient",     gradient: AnyShapeStyle(BrandGradients.accentGradient))
            GradientSwatch(name: "buttonGradient",     gradient: AnyShapeStyle(BrandGradients.buttonGradient))
            GradientSwatch(name: "backgroundGradient", gradient: AnyShapeStyle(BrandGradients.backgroundGradient))
            GradientSwatch(name: "successGradient",    gradient: AnyShapeStyle(BrandGradients.successGradient))
            GradientSwatch(name: "errorGradient",      gradient: AnyShapeStyle(BrandGradients.errorGradient))
        }
    }

    // MARK: - Spacing Scale

    private var spacingScale: some View {
        let steps: [(String, CGFloat)] = [
            ("xxs — 4",   Spacing.xxs),
            ("xs — 8",    Spacing.xs),
            ("sm — 12",   Spacing.sm),
            ("md — 16",   Spacing.md),
            ("lg — 24",   Spacing.lg),
            ("xl — 32",   Spacing.xl),
            ("xxl — 48",  Spacing.xxl),
            ("xxxl — 64", Spacing.xxxl),
        ]

        return VStack(alignment: .leading, spacing: Spacing.xs) {
            ForEach(steps, id: \.0) { label, value in
                HStack(spacing: Spacing.sm) {
                    Text(label)
                        .font(BrandTypography.caption1)
                        .foregroundStyle(BrandColors.onBackgroundSecondary)
                        .frame(width: 90, alignment: .leading)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(BrandColors.primary.opacity(0.6))
                        .frame(width: value, height: 14)

                    Spacer()
                }
            }
        }
    }

    // MARK: - Radii Previews

    private var radiiPreviews: some View {
        let steps: [(String, CGFloat)] = [
            ("xs — 4",   Radii.xs),
            ("sm — 8",   Radii.sm),
            ("md — 12",  Radii.md),
            ("lg — 16",  Radii.lg),
            ("xl — 24",  Radii.xl),
            ("xxl — 32", Radii.xxl),
        ]

        return LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
            spacing: Spacing.sm
        ) {
            ForEach(steps, id: \.0) { label, radius in
                VStack(spacing: Spacing.xxs) {
                    RoundedRectangle(cornerRadius: radius)
                        .fill(BrandColors.primary.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(BrandColors.primary.opacity(0.4), lineWidth: 1)
                        )
                        .frame(height: 48)

                    Text(label)
                        .font(BrandTypography.caption2)
                        .foregroundStyle(BrandColors.onBackgroundSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    // MARK: - Shadow Previews

    private var shadowPreviews: some View {
        HStack(spacing: Spacing.md) {
            ShadowCard(label: "Level 1\nCard")
                .shadow(
                    color: Shadows.cardColor,
                    radius: Shadows.cardRadius,
                    x: Shadows.cardX,
                    y: Shadows.cardY
                )

            ShadowCard(label: "Level 2\nElevated")
                .shadow(
                    color: Shadows.elevatedColor,
                    radius: Shadows.elevatedRadius,
                    x: Shadows.elevatedX,
                    y: Shadows.elevatedY
                )

            ShadowCard(label: "Level 3\nFloating")
                .shadow(
                    color: Shadows.floatingColor,
                    radius: Shadows.floatingRadius,
                    x: Shadows.floatingX,
                    y: Shadows.floatingY
                )
        }
    }

    // MARK: - Combined Components

    private var combinedComponents: some View {
        VStack(spacing: Spacing.md) {
            // Sample card
            SamplePatientCard()

            // Sample primary button
            Button(action: {}) {
                Text("Start Session")
                    .font(BrandTypography.button)
                    .foregroundStyle(BrandColors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                    .background(BrandGradients.buttonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: Radii.button))
            }
            .cardShadow()

            // Sample secondary button
            Button(action: {}) {
                Text("View Report")
                    .font(BrandTypography.button)
                    .foregroundStyle(BrandColors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                    .background(BrandColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Radii.button))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.button)
                            .stroke(BrandColors.border, lineWidth: 1)
                    )
            }

            // Sample status badges
            HStack(spacing: Spacing.sm) {
                StatusBadge(label: "Active", color: BrandColors.success)
                StatusBadge(label: "Pending", color: BrandColors.warning)
                StatusBadge(label: "Error", color: BrandColors.error)
                StatusBadge(label: "Info", color: BrandColors.info)
            }
        }
    }
}

// MARK: - Subcomponents

/// Section wrapper with a header label.
private struct DemoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(BrandTypography.title3)
                .foregroundStyle(BrandColors.primary)

            Divider()
                .background(BrandColors.border)

            content
        }
    }
}

/// Single color swatch tile with hex label.
private struct ColorSwatch: View {
    let name: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            RoundedRectangle(cornerRadius: Radii.sm)
                .fill(color)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.sm)
                        .stroke(BrandColors.border, lineWidth: 0.5)
                )

            Text(name)
                .font(BrandTypography.caption2)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
    }
}

/// Single typography specimen row.
private struct TypographyRow: View {
    let label: String
    let font: Font

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("The quick brown fox")
                .font(font)
                .foregroundStyle(BrandColors.onBackground)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(label)
                .font(BrandTypography.caption2)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        }
        .padding(.vertical, Spacing.xxs)
    }
}

/// Single gradient preview bar.
private struct GradientSwatch: View {
    let name: String
    let gradient: AnyShapeStyle

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: Radii.sm)
                .fill(gradient)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.sm)
                        .stroke(BrandColors.border.opacity(0.5), lineWidth: 0.5)
                )

            Text(name)
                .font(BrandTypography.caption1)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .frame(width: 120, alignment: .leading)
        }
    }
}

/// Shadow preview card tile.
private struct ShadowCard: View {
    let label: String

    var body: some View {
        RoundedRectangle(cornerRadius: Radii.card)
            .fill(BrandColors.surface)
            .frame(height: 72)
            .overlay(
                Text(label)
                    .font(BrandTypography.caption1)
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
                    .multilineTextAlignment(.center)
            )
            .frame(maxWidth: .infinity)
    }
}

/// Sample patient summary card combining surface, typography, and accent.
private struct SamplePatientCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Card header gradient bar
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Jordan M.")
                        .font(BrandTypography.headline)
                        .foregroundStyle(BrandColors.onPrimary)

                    Text("Session 12 of 24  •  Speech Therapy")
                        .font(BrandTypography.caption1)
                        .foregroundStyle(BrandColors.onPrimary.opacity(0.80))
                }

                Spacer()

                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(BrandColors.onPrimary.opacity(0.80))
            }
            .padding(Spacing.cardPadding)
            .background(BrandGradients.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: Radii.card))

            // Card body
            HStack(spacing: Spacing.md) {
                MetricTile(value: "78%", label: "Accuracy")
                MetricTile(value: "12 min", label: "Duration")
                MetricTile(value: "+5%", label: "vs Last")
            }
        }
        .padding(Spacing.cardPadding)
        .background(BrandColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radii.card))
        .cardShadow()
    }
}

/// A single metric tile inside a card.
private struct MetricTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text(value)
                .font(BrandTypography.title2)
                .foregroundStyle(BrandColors.primary)

            Text(label)
                .font(BrandTypography.caption1)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// A pill-shaped status badge.
private struct StatusBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(BrandTypography.caption1)
            .foregroundStyle(.white)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    ThemeDemoView()
}
