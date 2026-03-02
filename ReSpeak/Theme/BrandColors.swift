// BrandColors.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines all semantic color tokens for the HovaRehab / ReSpeak design system.
// Every static property is marked with a replacement comment so the brand
// handoff team can locate and swap values in one pass.
//
// Usage:
//   Text("Hello").foregroundStyle(BrandColors.onBackground)
//   Rectangle().fill(BrandColors.primary)

import SwiftUI

// MARK: - Color(hex:) helper

extension Color {
    /// Initialise a SwiftUI Color from a 6-digit hex string (e.g. "#1A3C5E").
    /// Alpha defaults to 1.0 (fully opaque).
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8)  & 0xFF) / 255.0
        let b = Double( int        & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - BrandColors

/// Semantic color tokens for the ReSpeak / HovaRehab design system.
/// All values are placeholders — replace hex strings with the official
/// HovaRehab brand palette once finalised.
public enum BrandColors {

    // MARK: - Core Brand

    /// Main brand color. Used for primary buttons, active navigation indicators,
    /// and key interactive elements.
    // MARK: Replace with HovaRehab brand token
    public static let primary: Color = Color(hex: "#1A3C5E")       // Deep navy blue

    /// Supporting brand color. Used for secondary buttons, icons, and
    /// complementary UI surfaces.
    // MARK: Replace with HovaRehab brand token
    public static let secondary: Color = Color(hex: "#2E6DA4")     // Medium steel blue

    /// Highlight / call-to-action color. Used for CTAs, badges, and
    /// attention-drawing UI elements.
    // MARK: Replace with HovaRehab brand token
    public static let accent: Color = Color(hex: "#00B4D8")        // Calm teal / sky blue

    // MARK: - Surface & Background

    /// Main application background. Used as the root page background.
    // MARK: Replace with HovaRehab brand token
    public static let background: Color = Color(hex: "#F4F7FB")    // Very light blue-tinted white

    /// Card / panel surface. Used for elevated containers, list rows,
    /// and modal sheets.
    // MARK: Replace with HovaRehab brand token
    public static let surface: Color = Color(hex: "#FFFFFF")       // Pure white

    /// Slightly tinted surface variant for alternate rows or nested cards.
    // MARK: Replace with HovaRehab brand token
    public static let surfaceVariant: Color = Color(hex: "#EAF1FB") // Light blue-tinted surface

    // MARK: - On-Color Text / Icon Tints

    /// Text or icon color placed on top of `primary` backgrounds.
    // MARK: Replace with HovaRehab brand token
    public static let onPrimary: Color = Color(hex: "#FFFFFF")     // White

    /// Body text and primary icon color placed on `background` or `surface`.
    // MARK: Replace with HovaRehab brand token
    public static let onBackground: Color = Color(hex: "#1C2B3A")  // Near-black navy

    /// Secondary / muted text color for captions, hints, and placeholders.
    // MARK: Replace with HovaRehab brand token
    public static let onBackgroundSecondary: Color = Color(hex: "#5A7089") // Muted slate

    // MARK: - Semantic States

    /// Error / destructive state. Used for validation messages, destructive
    /// buttons, and alert indicators.
    // MARK: Replace with HovaRehab brand token
    public static let error: Color = Color(hex: "#D62839")         // Medical red

    /// Success state. Used for confirmation messages and positive indicators.
    // MARK: Replace with HovaRehab brand token
    public static let success: Color = Color(hex: "#2A9D5C")       // Calm green

    /// Warning state. Used for cautionary prompts and advisory messages.
    // MARK: Replace with HovaRehab brand token
    public static let warning: Color = Color(hex: "#F4A020")       // Amber

    /// Informational state. Used for non-critical notices and helper text.
    // MARK: Replace with HovaRehab brand token
    public static let info: Color = Color(hex: "#2E6DA4")          // Mirrors secondary

    // MARK: - Border & Separator

    /// Subtle border / divider color for cards, list separators, and input fields.
    // MARK: Replace with HovaRehab brand token
    public static let border: Color = Color(hex: "#D0DFF0")        // Light blue-gray

    /// Disabled state color for text, icons, and controls.
    // MARK: Replace with HovaRehab brand token
    public static let disabled: Color = Color(hex: "#B0C4D8")      // Washed-out blue-gray
}
