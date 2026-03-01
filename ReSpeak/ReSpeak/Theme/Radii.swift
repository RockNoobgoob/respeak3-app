// Radii.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines corner radius tokens for the HovaRehab / ReSpeak design system.
// Rounded corners signal warmth and approachability — key qualities for a
// medical rehabilitation product. All interactive surfaces should use at
// least `Radii.card` to maintain visual consistency.
//
// Usage:
//   .clipShape(RoundedRectangle(cornerRadius: Radii.card))
//   .cornerRadius(Radii.button)

import SwiftUI

// MARK: - Radii

/// Corner radius tokens for the ReSpeak / HovaRehab design system.
public enum Radii {

    // MARK: - Base Scale

    /// 4 pt — Extra small. Used for tags, badges, and tight inline chips.
    public static let xs: CGFloat = 4

    /// 8 pt — Small. Used for input fields, compact buttons, and icon containers.
    public static let sm: CGFloat = 8

    /// 12 pt — Medium. Used for secondary buttons, tooltip bubbles, and
    /// small panel containers.
    public static let md: CGFloat = 12

    /// 16 pt — Large. Used for primary card components, list cells with
    /// rich content, and bottom sheets.
    public static let lg: CGFloat = 16

    /// 24 pt — Extra large. Used for modal sheets, full-bleed hero cards,
    /// and prominent panels.
    public static let xl: CGFloat = 24

    /// 32 pt — 2x Large. Used for splash/onboarding illustration containers.
    public static let xxl: CGFloat = 32

    // MARK: - Semantic Aliases

    /// Standard card corner radius (16 pt).
    /// Use for all card and panel surface components.
    public static let card: CGFloat = lg

    /// Button corner radius (12 pt).
    /// Use for primary and secondary button shapes.
    public static let button: CGFloat = md

    /// Full-pill / fully rounded. Use for pill-shaped tags and toggle chips.
    /// Set to a sufficiently large value to guarantee full rounding on any height.
    public static let pill: CGFloat = 999

    /// Input field corner radius (8 pt).
    /// Use for text fields, search bars, and picker controls.
    public static let input: CGFloat = sm

    /// Sheet / bottom drawer corner radius (24 pt).
    /// Applied to the top corners of modal bottom sheets.
    public static let sheet: CGFloat = xl

    /// Avatar / profile image corner radius (8 pt).
    /// Applied to small profile photo thumbnails.
    public static let avatar: CGFloat = sm
}
