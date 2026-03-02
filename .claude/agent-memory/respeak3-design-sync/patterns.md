# BrandKit Patterns & Integration Notes

## Web Integration

### React/Vite entry point (main.tsx or _app.tsx)
```tsx
import './styles/theme.css'  // or wherever theme.css is placed
```

### tailwind.config.ts
```ts
import { tokens } from '../brandkit/generated/web/tailwind.tokens'
export default {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: { ...tokens }
  }
}
```

### Example: Button component using tokens
```tsx
// Uses Tailwind classes backed by token values
export function PrimaryButton({ label }: { label: string }) {
  return (
    <button
      className="
        bg-primary text-on-primary
        font-semibold text-md
        px-xl py-md
        rounded-md
        shadow-card
        hover:opacity-90 active:opacity-80
        transition-opacity
      "
    >
      {label}
    </button>
  )
}
```

### Example: Card component using tokens
```tsx
export function Card({ children }: { children: React.ReactNode }) {
  return (
    <div
      className="
        bg-surface
        rounded-lg
        shadow-card
        p-lg
        border border-border
      "
      style={{ borderWidth: 'var(--layout-border-default)' }}
    >
      {children}
    </div>
  )
}
```

### Example: Raw CSS custom properties (non-Tailwind)
```css
.my-button {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
  font-size: var(--typography-size-md);
  font-weight: var(--typography-weight-semibold);
  padding: var(--layout-spacing-md) var(--layout-spacing-xl);
  border-radius: var(--layout-radius-md);
  box-shadow: var(--shadow-card);
}
```

## iOS Integration (SwiftUI)

### SwiftUI usage examples
```swift
// Colors
Text("Hello").foregroundStyle(BrandColors.onBackground)
Rectangle().fill(BrandColors.primary)
Color.brand800   // via Color extension shorthand

// Typography + color pairing
Text("Welcome").brandStyle(.display)
Text("Section header").brandStyle(.headline)
Text("Body copy").brandStyle(.body)
Text("On button").brandStyle(.onPrimary)

// Spacing
.padding(Spacing.lg)          // 16 pt
.padding(.horizontal, Spacing.screenHorizontal)
VStack(spacing: Spacing.xl) { ... }

// Border radius
.clipShape(RoundedRectangle(cornerRadius: Radii.card))
.clipShape(RoundedRectangle(cornerRadius: Radii.button))
RoundedRectangle(cornerRadius: Radii.pill)

// Shadows (view modifier shorthand)
cardView.cardShadow()
modal.floatingShadow()
elevatedCard.elevatedShadow()

// Shadows (direct token)
.shadow(
  color: Shadows.sm.color,
  radius: Shadows.sm.radius,
  x: Shadows.sm.x,
  y: Shadows.sm.y
)

// Border width
.strokeBorder(BrandColors.border, lineWidth: BorderWidth.`default`)
.strokeBorder(BrandColors.border, lineWidth: BorderWidth.thin)
```

### Xcode Build Phase setup
1. Open Xcode project
2. Select the ReSpeak target
3. Go to Build Phases
4. Click "+" -> "New Run Script Phase"
5. Drag the new phase above "Compile Sources"
6. Paste:
   ```bash
   bash "$SRCROOT/scripts/sync-brand.sh"
   ```
7. Check "Show environment variables in build log" for debugging

## Generator Architecture

### Token flow
```
brandkit/tokens/colors.json      \
brandkit/tokens/typography.json   } -> generate-ios.ts -> brandkit/generated/ios/*.swift
brandkit/tokens/layout.json      /
                                  } -> generate-web.ts -> brandkit/generated/web/theme.css
                                                       -> brandkit/generated/web/tailwind.tokens.ts
```

### Backward compatibility design
Generated Swift files maintain ALL aliases from the manually written Theme/ files:
- BrandColors: primary, secondary, accent, background, surface, surfaceVariant,
  onPrimary, onBackground, onBackgroundSecondary, error, success, warning, info, border, disabled
- BrandTypography: largeTitle, title1, title2, title3, callout, subheadline, footnote,
  caption1, caption2, navTitle (legacy aliases to new role names)
- Shadows: cardColor/cardRadius/cardX/cardY, elevatedColor/.., floatingColor/.. (flat legacy API)
- Spacing: screenHorizontal, sectionGap, cardPadding, rowPadding, iconLabelGap (semantic aliases)
- Radii: card, button, input, sheet, pill, avatar, badge (semantic aliases)

This means: updating token values in JSON, re-running gen, and copying to Theme/ will
NEVER break existing SwiftUI call sites.
