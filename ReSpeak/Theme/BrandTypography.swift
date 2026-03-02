// BrandTypography.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines the typographic scale and helper modifiers for the HovaRehab /
// ReSpeak design system. All fonts use Dynamic Type-compatible system sizes
// so they respond correctly to the user's accessibility text-size preference.
//
// Usage:
//   Text("Welcome").font(BrandTypography.largeTitle)
//   Text("Section").brandStyle(.headline)

import SwiftUI

// MARK: - BrandTypography

/// Typographic scale for the ReSpeak / HovaRehab design system.
/// Uses system fonts as placeholders. Replace font family name when the
/// official HovaRehab typeface is licensed and bundled.
public enum BrandTypography {

    // MARK: - Display / Heading

    /// Largest display heading. Used for onboarding hero text and splash screens.
    // MARK: Replace with HovaRehab custom font when available
    public static let largeTitle: Font = .system(size: 34, weight: .bold, design: .rounded)

    /// Primary section heading. Used for screen titles and top-level page names.
    // MARK: Replace with HovaRehab custom font when available
    public static let title1: Font = .system(size: 28, weight: .bold, design: .rounded)

    /// Secondary heading. Used for card headers and prominent labels.
    // MARK: Replace with HovaRehab custom font when available
    public static let title2: Font = .system(size: 22, weight: .semibold, design: .rounded)

    /// Tertiary heading. Used for sub-section labels and grouped list headers.
    // MARK: Replace with HovaRehab custom font when available
    public static let title3: Font = .system(size: 20, weight: .semibold, design: .rounded)

    /// Section / content headline. Used for prominent labels inside cards.
    // MARK: Replace with HovaRehab custom font when available
    public static let headline: Font = .system(size: 17, weight: .semibold, design: .default)

    // MARK: - Body

    /// Standard body text. Used for all paragraph and list item content.
    // MARK: Replace with HovaRehab custom font when available
    public static let body: Font = .system(size: 17, weight: .regular, design: .default)

    /// Slightly smaller body variant. Used for supplementary copy inside cards.
    // MARK: Replace with HovaRehab custom font when available
    public static let callout: Font = .system(size: 16, weight: .regular, design: .default)

    /// Supporting descriptive text. Used below headlines for context.
    // MARK: Replace with HovaRehab custom font when available
    public static let subheadline: Font = .system(size: 15, weight: .regular, design: .default)

    // MARK: - Small / Meta

    /// Fine-print text. Used for legal text, version numbers, and timestamps.
    // MARK: Replace with HovaRehab custom font when available
    public static let footnote: Font = .system(size: 13, weight: .regular, design: .default)

    /// Primary caption. Used for image captions and compact data labels.
    // MARK: Replace with HovaRehab custom font when available
    public static let caption1: Font = .system(size: 12, weight: .regular, design: .default)

    /// Secondary caption. Used for smallest supplementary metadata.
    // MARK: Replace with HovaRehab custom font when available
    public static let caption2: Font = .system(size: 11, weight: .regular, design: .default)

    // MARK: - Interactive

    /// Button label text. Used for all primary and secondary button labels.
    // MARK: Replace with HovaRehab custom font when available
    public static let button: Font = .system(size: 17, weight: .semibold, design: .default)

    /// Navigation bar title text.
    // MARK: Replace with HovaRehab custom font when available
    public static let navTitle: Font = .system(size: 17, weight: .semibold, design: .default)
}

// MARK: - BrandTextStyle

/// Semantic text style pairings combining a font and its standard foreground color.
/// Apply via the `.brandStyle(_:)` View modifier.
public enum BrandTextStyle {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
    case onPrimary       // Body weight text meant for primary-colored surfaces
}

// MARK: - View Modifier

/// Applies a paired font + foreground color for a given `BrandTextStyle`.
private struct BrandTextStyleModifier: ViewModifier {
    let style: BrandTextStyle

    func body(content: Content) -> some View {
        switch style {
        case .largeTitle:
            content
                .font(BrandTypography.largeTitle)
                .foregroundStyle(BrandColors.onBackground)
        case .title1:
            content
                .font(BrandTypography.title1)
                .foregroundStyle(BrandColors.onBackground)
        case .title2:
            content
                .font(BrandTypography.title2)
                .foregroundStyle(BrandColors.onBackground)
        case .title3:
            content
                .font(BrandTypography.title3)
                .foregroundStyle(BrandColors.onBackground)
        case .headline:
            content
                .font(BrandTypography.headline)
                .foregroundStyle(BrandColors.onBackground)
        case .body:
            content
                .font(BrandTypography.body)
                .foregroundStyle(BrandColors.onBackground)
        case .callout:
            content
                .font(BrandTypography.callout)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        case .subheadline:
            content
                .font(BrandTypography.subheadline)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        case .footnote:
            content
                .font(BrandTypography.footnote)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        case .caption1:
            content
                .font(BrandTypography.caption1)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        case .caption2:
            content
                .font(BrandTypography.caption2)
                .foregroundStyle(BrandColors.onBackgroundSecondary)
        case .onPrimary:
            content
                .font(BrandTypography.body)
                .foregroundStyle(BrandColors.onPrimary)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a semantic brand text style (font + foreground color pairing).
    ///
    /// Example:
    /// ```swift
    /// Text("Hello").brandStyle(.headline)
    /// ```
    func brandStyle(_ style: BrandTextStyle) -> some View {
        self.modifier(BrandTextStyleModifier(style: style))
    }
}
