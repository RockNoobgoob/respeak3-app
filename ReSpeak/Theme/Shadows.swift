// Shadows.swift
// ReSpeak
// Created: 2026-03-01
//
// Defines subtle shadow tokens for the HovaRehab / ReSpeak design system.
// Shadows convey elevation and depth while keeping the UI clean and medical-grade.
// All shadows use a dark navy base color at low opacity for a soft, natural look
// rather than pure black.
//
// Usage:
//   .shadow(color: Shadows.cardColor, radius: Shadows.cardRadius,
//           x: Shadows.cardX, y: Shadows.cardY)
//   view.cardShadow()           // convenience modifier

import SwiftUI

// MARK: - Shadows

/// Shadow token definitions for the ReSpeak / HovaRehab design system.
/// Each shadow level is represented as a group of four related properties
/// (color, radius, x, y) so they can be applied atomically.
public enum Shadows {

    // MARK: - Level 1 — Subtle (Resting State)

    /// Shadow color for resting/idle cards and surface elements.
    // MARK: Replace with HovaRehab brand token if a tinted shadow is preferred
    public static let cardColor: Color = BrandColors.primary.opacity(0.08)

    /// Blur radius for resting card shadows.
    public static let cardRadius: CGFloat = 8

    /// Horizontal offset for resting card shadows.
    public static let cardX: CGFloat = 0

    /// Vertical offset for resting card shadows (slight downward = natural light).
    public static let cardY: CGFloat = 2

    // MARK: - Level 2 — Elevated (Pressed / Active State)

    /// Shadow color for elevated/active interactive cards.
    // MARK: Replace with HovaRehab brand token
    public static let elevatedColor: Color = BrandColors.primary.opacity(0.14)

    /// Blur radius for elevated shadows.
    public static let elevatedRadius: CGFloat = 16

    /// Horizontal offset for elevated shadows.
    public static let elevatedX: CGFloat = 0

    /// Vertical offset for elevated shadows.
    public static let elevatedY: CGFloat = 6

    // MARK: - Level 3 — Floating (Modal / Overlay)

    /// Shadow color for floating sheets, menus, and overlay panels.
    // MARK: Replace with HovaRehab brand token
    public static let floatingColor: Color = BrandColors.primary.opacity(0.20)

    /// Blur radius for floating shadows.
    public static let floatingRadius: CGFloat = 28

    /// Horizontal offset for floating shadows.
    public static let floatingX: CGFloat = 0

    /// Vertical offset for floating shadows.
    public static let floatingY: CGFloat = 10

    // MARK: - Level 0 — None (Flat / Bordered Style)

    /// Transparent shadow — use when a flat, bordered card style is needed
    /// instead of a shadow-based elevation cue.
    public static let noneColor: Color = .clear
    public static let noneRadius: CGFloat = 0
    public static let noneX: CGFloat = 0
    public static let noneY: CGFloat = 0
}

// MARK: - Shadow ViewModifiers

/// Applies the standard resting card shadow.
private struct CardShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(
            color: Shadows.cardColor,
            radius: Shadows.cardRadius,
            x: Shadows.cardX,
            y: Shadows.cardY
        )
    }
}

/// Applies the elevated (pressed/active) card shadow.
private struct ElevatedShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(
            color: Shadows.elevatedColor,
            radius: Shadows.elevatedRadius,
            x: Shadows.elevatedX,
            y: Shadows.elevatedY
        )
    }
}

/// Applies the floating (modal/overlay) shadow.
private struct FloatingShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(
            color: Shadows.floatingColor,
            radius: Shadows.floatingRadius,
            x: Shadows.floatingX,
            y: Shadows.floatingY
        )
    }
}

// MARK: - View Extension

public extension View {
    /// Applies the standard resting card shadow (Level 1).
    func cardShadow() -> some View {
        self.modifier(CardShadowModifier())
    }

    /// Applies the elevated card shadow for pressed/active states (Level 2).
    func elevatedShadow() -> some View {
        self.modifier(ElevatedShadowModifier())
    }

    /// Applies the floating shadow for modals and overlays (Level 3).
    func floatingShadow() -> some View {
        self.modifier(FloatingShadowModifier())
    }
}
