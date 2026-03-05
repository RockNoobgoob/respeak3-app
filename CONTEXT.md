# ReSpeak — Project Context

## What is ReSpeak?

ReSpeak is an iOS speech therapy app (SwiftUI, iOS 17+) built for the HovaRehab platform. It is designed for patients doing guided speech therapy exercises and for clinicians managing those patients. The app is in early development — the design system and app shell are in place, but no backend, authentication, or real feature logic exists yet.

---

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI (no UIKit, no storyboards)
- **Architecture:** Feature-folder layout, service/repository containers stubbed for future DI
- **Project root:** `ReSpeak.xcodeproj` at the repo root
- **Source root:** `ReSpeak/` folder

---

## Design System

All UI must use the HovaRehab brand tokens. Never use raw hex colors, raw CGFloat spacing, or system fonts directly — always go through these enums:

| File | Token enum | What it provides |
|---|---|---|
| `ReSpeak/Theme/BrandColors.swift` | `BrandColors` | Semantic colors (primary, secondary, accent, surface, background, error, success, etc.) |
| `ReSpeak/Theme/BrandTypography.swift` | `BrandTypography`, `BrandTextStyle` | Font scale + `.brandStyle(_:)` view modifier |
| `ReSpeak/Theme/BrandGradients.swift` | `BrandGradients` | Named LinearGradient / RadialGradient tokens |
| `ReSpeak/Theme/Spacing.swift` | `Spacing` | 4pt-base spacing scale (xxs=4 through xxxl=64) |
| `ReSpeak/Theme/Radii.swift` | `Radii` | Corner radius tokens (input=8, button=12, card=16, sheet=24) |
| `ReSpeak/Theme/Shadows.swift` | `Shadows` | 3-level shadow system + `.cardShadow()`, `.elevatedShadow()`, `.floatingShadow()` view modifiers |

Key color values for reference:
- `BrandColors.primary` = deep navy `#1A3C5E`
- `BrandColors.secondary` = steel blue `#2E6DA4`
- `BrandColors.accent` = teal `#00B4D8`
- `BrandColors.background` = light blue-white `#F4F7FB`
- `BrandColors.surface` = white `#FFFFFF`
- `BrandColors.onPrimary` = white (text on dark backgrounds)
- `BrandColors.onBackground` = near-black navy `#1C2B3A`

---

## File & Folder Structure

```
ReSpeak/
  App/
    ReSpeakApp.swift          — @main entry point, renders AppView
    AppView.swift             — root router (onboarding vs main app)
    MainTabView.swift         — 4-tab shell for authenticated users

  Features/
    Practice/
      PracticeView.swift      — Practice tab: hero card + exercise list (REAL scaffold)
      ExerciseRowView.swift   — Reusable exercise card component
    Report/
      ReportView.swift        — Report tab stub ("Coming soon")
    Help/
      HelpView.swift          — Help tab stub ("Coming soon")
    Settings/
      SettingsView.swift      — Settings tab stub ("Coming soon")

  Views/
    ContentView.swift         — Legacy root view, currently renders LoginView
    LoginView.swift           — Login screen (UI only, no auth wired)
    ThemeDemoView.swift       — Design system visual catalog (dev tool, keep it)

  Theme/
    BrandColors.swift
    BrandTypography.swift
    BrandGradients.swift
    Spacing.swift
    Radii.swift
    Shadows.swift

  Services/
    ServiceContainer.swift    — Singleton stub for future services

  Repositories/
    RepositoryContainer.swift — Singleton stub for future repositories
```

---

## Navigation & Routing

### App entry point
`ReSpeakApp.swift` → renders `AppView`

### AppView (root router)
Reads `@AppStorage("hasCompletedOnboarding"): Bool`.
- `false` → shows `OnboardingQuizView` placeholder (inline in AppView.swift, tap "Continue" to proceed)
- `true` → shows `MainTabView`

> Note: `LoginView` exists and is fully designed but is NOT currently wired into the auth flow. `ContentView` renders it but `ContentView` is not used by `ReSpeakApp` — `AppView` is the real root. LoginView needs to be integrated once auth is implemented.

### MainTabView (authenticated shell)
`TabView` with 4 tabs, tint `BrandColors.primary`:

| Tab index | Label | Icon | View | Status |
|---|---|---|---|---|
| 0 | Practice | `mic.fill` | `PracticeView` | Real scaffold |
| 1 | Report | `chart.bar.fill` | `ReportView` | Stub |
| 2 | Help | `questionmark.circle.fill` | `HelpView` | Stub |
| 3 | Settings | `gearshape.fill` | `SettingsView` | Stub |

### PracticeView (tab 0)
`NavigationStack` wrapping a `ScrollView`:
- Hero gradient card at the top
- "Today's Exercises" section with hardcoded `ExerciseRowView` instances (no real data yet)

All other tabs are `NavigationStack` stubs showing "Coming soon".

---

## What Is NOT Built Yet

- Authentication (login form exists, no backend call)
- Onboarding quiz (placeholder only)
- Any real data models or data layer
- Backend / API integration
- Report, Help, Settings screen content
- Exercise detail / session recording screens
- Any ViewModel or state management beyond local `@State`
- `ServiceContainer` and `RepositoryContainer` are empty singletons

---

## Conventions to Follow

- All colors, fonts, spacing, radii, and shadows **must** come from the token enums above
- Feature screens live in `ReSpeak/Features/<FeatureName>/`
- Each screen gets its own `NavigationStack` (not a single root stack)
- Use `BrandColors.background` or `BrandGradients.backgroundGradient` as screen backgrounds
- Cards use `BrandColors.surface` + `Radii.card` + `.cardShadow()`
- Primary buttons use `BrandGradients.buttonGradient` fill + `Radii.button` clip + `BrandColors.onPrimary` label
- Secondary buttons use `BrandColors.surface` fill + `BrandColors.border` stroke + `BrandColors.primary` label
