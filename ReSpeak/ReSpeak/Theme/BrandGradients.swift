// BrandGradients.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines all gradient tokens for the HovaRehab / ReSpeak design system.
// Gradients use the BrandColors palette so swapping brand colors automatically
// propagates here. Gradient stops are also independently documented so the
// brand team can fine-tune angles and opacity independently.
//
// Usage:
//   Rectangle().fill(BrandGradients.primaryGradient)
//   view.background(BrandGradients.backgroundGradient)

import SwiftUI

// MARK: - BrandGradients

/// Gradient tokens for the ReSpeak / HovaRehab design system.
/// All color stops reference BrandColors tokens.
/// Replace stops with HovaRehab brand colors once the palette is finalised.
public enum BrandGradients {

    // MARK: - Hero / Header

    /// Primary hero gradient. Used for full-bleed headers, onboarding screens,
    /// and navigation bar backgrounds.
    /// Sweeps from deep navy (primary) to medium steel blue (secondary).
    // MARK: Replace stops with HovaRehab brand colors
    public static let primaryGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.primary,
            BrandColors.secondary
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Deep hero gradient variant with an accent highlight.
    /// Used for splash screens and modal headers that need more visual punch.
    // MARK: Replace stops with HovaRehab brand colors
    public static let heroGradient: LinearGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: BrandColors.primary,   location: 0.0),
            .init(color: BrandColors.secondary,  location: 0.65),
            .init(color: BrandColors.accent,     location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - CTA / Accent

    /// Accent call-to-action gradient. Used for primary action buttons,
    /// progress bars, and highlighted badge backgrounds.
    /// Sweeps from teal accent to a slightly brighter sky-blue variant.
    // MARK: Replace stops with HovaRehab brand colors
    public static let accentGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.accent,
            BrandColors.accent.opacity(0.70)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Full-bleed button gradient (leading → trailing). Used when a button
    /// spans the full screen width and needs more visual depth than a solid fill.
    // MARK: Replace stops with HovaRehab brand colors
    public static let buttonGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.primary,
            BrandColors.secondary
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Background

    /// Subtle full-page background gradient. Used as the root view background
    /// to add warmth without competing with foreground content.
    /// Very light — nearly imperceptible on small screens.
    // MARK: Replace stops with HovaRehab brand colors
    public static let backgroundGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.background,
            BrandColors.surfaceVariant
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Card / Surface

    /// Card shimmer gradient. Used as a subtle shine overlay on elevated cards
    /// and panels to convey depth. Apply with low opacity (0.06–0.12).
    // MARK: Replace stops with HovaRehab brand colors
    public static let cardGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white.opacity(0.60),
            Color.white.opacity(0.00)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Card border gradient. Used as a 1pt stroke on premium card components
    /// to create a subtle edge highlight.
    // MARK: Replace stops with HovaRehab brand colors
    public static let cardBorderGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.border,
            BrandColors.surface
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Semantic State

    /// Success state gradient. Used for success banners, confirmation screens,
    /// and completed-step indicators.
    // MARK: Replace stops with HovaRehab brand colors
    public static let successGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.success,
            BrandColors.success.opacity(0.70)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Error / warning gradient. Used for destructive action confirmation banners.
    // MARK: Replace stops with HovaRehab brand colors
    public static let errorGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            BrandColors.error,
            BrandColors.warning
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Radial

    /// Radial spotlight gradient. Used for decorative background elements
    /// and focus-ring highlight overlays.
    // MARK: Replace stops with HovaRehab brand colors
    public static let spotlightGradient: RadialGradient = RadialGradient(
        gradient: Gradient(colors: [
            BrandColors.accent.opacity(0.25),
            BrandColors.accent.opacity(0.00)
        ]),
        center: .center,
        startRadius: 0,
        endRadius: 200
    )
}
