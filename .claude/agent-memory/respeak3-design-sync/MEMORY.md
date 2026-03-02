# ReSpeak3 Design Sync Agent — Persistent Memory

## Project Identity
- Brand: HovaRehab / ReSpeak3 (healthcare speech therapy rehabilitation app)
- Monorepo root: /c/Users/noah/Downloads/respeak3-app
- iOS project: ReSpeak/ (SwiftUI, Xcode project at ReSpeak.xcodeproj)
- BrandKit: brandkit/ (token source of truth, generators, generated outputs)

## Established Color Palette (HovaRehab)
- brand.900 = #0A1F44  (darkest navy — spec anchor)
- brand.800 = #1A3C5E  (primary interactive = `BrandColors.primary`)
- brand.500 = #2E6DA4  (secondary = `BrandColors.secondary`)
- accent.primary = #00B4D8  (teal CTA)
- surface.50 = #F4F7FB  (app background — very light blue-tinted white)
- surface.0 = #FFFFFF  (card / panel)
- surface.100 = #EAF1FB  (surfaceVariant)
- text.900 = #1C2B3A  (near-black body text)
- text.500 = #5A7089  (secondary/muted text)
- semantic.danger = #D62839, success = #2A9D5C, warning = #F4A020, info = #2E6DA4
- See brandkit/tokens/colors.json for full scale

## Token File Locations
- brandkit/tokens/colors.json       — color token source
- brandkit/tokens/typography.json   — type scale + semantic roles
- brandkit/tokens/layout.json       — spacing, radii, shadows, borders

## Generated Output Locations
- brandkit/generated/ios/BrandColors.swift
- brandkit/generated/ios/BrandTypography.swift
- brandkit/generated/ios/BrandLayout.swift
- brandkit/generated/web/theme.css           (CSS custom properties under :root)
- brandkit/generated/web/tailwind.tokens.ts  (Tailwind theme.extend object)

## iOS Theme Directory
- ReSpeak/Theme/ — Swift theme files live here
- Pre-existing manual files: BrandColors.swift, BrandTypography.swift, Spacing.swift,
  Radii.swift, Shadows.swift, BrandGradients.swift
- Generator replaces BrandColors, BrandTypography, BrandLayout (merged Spacing+Radii+Shadows)
- BrandGradients.swift references BrandColors tokens — stays manual, no generator needed

## Swift Naming Conventions
- Color scale: brand50, brand800, brand900 (no separator)
- Text scale: text900, text500, text300
- Surface scale: surface0, surface50, surface100
- Semantic: semanticSuccess, semanticDanger, semanticWarning, semanticInfo
- Accent: accentPrimary, accentSecondary, accentLight
- Fixed: fixedWhite, fixedBlack, fixedTransparent
- Spacing Swift keys: xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48, xxxxl=64
- Radii Swift keys: xs/sm/md/lg/xl/xxl/full — semantic: card=lg, button=md, pill=full
- "2xl" JSON key -> "xxl" Swift key (avoid leading-digit identifier)
- "default" is a Swift reserved word — use backtick: `default`
- Semantic aliases preserved on generated enums for backward compat with pre-existing code

## CSS Variable Naming
- Colors: --color-brand-900, --color-surface-50, --color-text-900
- Semantic: --color-semantic-danger, --color-semantic-success-light (camelCase->kebab-case)
- Accent: --color-accent-primary
- Aliases: --color-primary, --color-secondary, --color-background, --color-error, etc.
- Typography: --typography-size-xl, --typography-weight-semibold, --typography-line-height-tight
- Font families: --font-family-primary, --font-family-display, --font-family-mono
- Layout: --layout-spacing-lg, --layout-radius-md, --layout-border-thin
- Shadows: --shadow-sm, --shadow-md, --shadow-lg, --shadow-xl; aliases: --shadow-card etc.

## Tailwind Token Keys
- tokens.colors.brand['900'], tokens.colors.surface['0'], tokens.colors.semantic.success
- Top-level aliases: tokens.colors.primary, tokens.colors.error, tokens.colors.border
- tokens.fontSize['xl'], tokens.fontWeight.semibold, tokens.spacing.lg
- tokens.borderRadius.full = '9999px', tokens.boxShadow.card = 'var(--shadow-card)'
- Font family values use double-quoted strings to avoid single-quote conflicts

## Generator Run Command
cd brandkit && npm run gen        # runs both generators
cd brandkit && npm run gen:ios    # iOS only
cd brandkit && npm run gen:web    # web only

## iOS Sync Script
ReSpeak/scripts/sync-brand.sh — runs npm install + gen:ios, then copies Swift files to Theme/
Usage: bash ReSpeak/scripts/sync-brand.sh
Xcode Build Phase: bash "$SRCROOT/scripts/sync-brand.sh"

## Known Issues / Gotchas
- 'default' is a Swift reserved word — generator wraps it in backticks for BorderWidth.`default`
- Font family strings contain single quotes — tailwind generator must use double-quoted JS strings
- JSON keys starting with digits (2xl, 3xl) must be transformed for Swift (xxl, xxxl pattern)
- Tailwind token semantic alias values use CSS var() references, not raw hex
- Web component must import theme.css before using CSS custom properties
- Detail file: patterns.md
