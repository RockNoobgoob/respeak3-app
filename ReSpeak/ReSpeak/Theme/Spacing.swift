// Spacing.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines the spacing scale for the HovaRehab / ReSpeak design system.
// All layout padding, stack spacing, and margin values should derive from
// this scale to ensure visual rhythm and consistency.
//
// Usage:
//   .padding(Spacing.md)
//   VStack(spacing: Spacing.sm) { ... }

import SwiftUI

// MARK: - Spacing

/// Spacing scale for the ReSpeak / HovaRehab design system.
/// Based on a 4-pt base unit to align with iOS HIG recommendations.
public enum Spacing {

    // MARK: - Base Scale

    /// 4 pt — Micro gap. Used for icon-label pairs and tight inline groupings.
    public static let xxs: CGFloat = 4

    /// 8 pt — Extra small. Used for compact list row internal padding.
    public static let xs: CGFloat = 8

    /// 12 pt — Small. Used for internal card padding and between-item spacing
    /// in dense layouts.
    public static let sm: CGFloat = 12

    /// 16 pt — Medium (base unit). Used for standard section padding,
    /// card horizontal margins, and default VStack/HStack spacing.
    public static let md: CGFloat = 16

    /// 24 pt — Large. Used for between-section spacing and generous card padding.
    public static let lg: CGFloat = 24

    /// 32 pt — Extra large. Used for screen-edge padding on larger layouts
    /// and prominent visual separators between major content blocks.
    public static let xl: CGFloat = 32

    /// 48 pt — 2x Large. Used for hero section top spacing and prominent
    /// vertical breathing room on onboarding screens.
    public static let xxl: CGFloat = 48

    /// 64 pt — 3x Large. Used for large visual breaks and splash screen spacing.
    public static let xxxl: CGFloat = 64

    // MARK: - Semantic Aliases

    /// Standard horizontal screen margin (16 pt).
    /// Use for leading/trailing padding on full-width containers.
    public static let screenHorizontal: CGFloat = md

    /// Standard vertical section gap (24 pt).
    /// Use for spacing between major content sections on a screen.
    public static let sectionGap: CGFloat = lg

    /// Standard internal card padding (16 pt).
    /// Use for padding inside card and panel components.
    public static let cardPadding: CGFloat = md

    /// Compact row internal padding (12 pt).
    /// Use for list row vertical padding in dense table-style views.
    public static let rowPadding: CGFloat = sm

    /// Icon-to-label gap (8 pt).
    /// Use for horizontal spacing between an icon and its adjacent label.
    public static let iconLabelGap: CGFloat = xs
}
