# ReSpeak Project Memory

## Design System Token Names
The design system uses FLAT namespace enums (no `DS.` wrapper). Always reference:
- Colors: `BrandColors.primary`, `BrandColors.secondary`, `BrandColors.accent`, `BrandColors.background`, `BrandColors.surface`, `BrandColors.surfaceVariant`, `BrandColors.onPrimary`, `BrandColors.onBackground`, `BrandColors.onBackgroundSecondary`, `BrandColors.border`, `BrandColors.disabled`, `BrandColors.error`, `BrandColors.success`, `BrandColors.warning`, `BrandColors.info`
- Gradients: `BrandGradients.primaryGradient`, `BrandGradients.heroGradient`, `BrandGradients.accentGradient`, `BrandGradients.buttonGradient`, `BrandGradients.backgroundGradient`, `BrandGradients.cardGradient`, `BrandGradients.successGradient`, `BrandGradients.errorGradient`, `BrandGradients.spotlightGradient`
- Radii: `Radii.xs`(4), `Radii.sm`(8), `Radii.md`(12), `Radii.lg`(16), `Radii.xl`(24), `Radii.xxl`(32), `Radii.card`(=lg), `Radii.button`(=md), `Radii.pill`(999), `Radii.input`(=sm), `Radii.sheet`(=xl), `Radii.avatar`(=sm)
- Spacing: `Spacing.xxs`(4), `Spacing.xs`(8), `Spacing.sm`(12), `Spacing.md`(16), `Spacing.lg`(24), `Spacing.xl`(32), `Spacing.xxl`(48), `Spacing.xxxl`(64), `Spacing.screenHorizontal`(=md), `Spacing.sectionGap`(=lg), `Spacing.cardPadding`(=md), `Spacing.rowPadding`(=sm), `Spacing.iconLabelGap`(=xs)
- Shadows: `Shadows.cardColor/cardRadius/cardX/cardY`, `Shadows.elevatedColor/elevatedRadius/elevatedX/elevatedY`, `Shadows.floatingColor/floatingRadius/floatingX/floatingY`
- Typography: `BrandTypography.largeTitle`, `.title1`, `.title2`, `.title3`, `.headline`, `.body`, `.callout`, `.subheadline`, `.footnote`, `.caption1`, `.caption2`, `.button`, `.navTitle`
- View modifiers (extensions on View): `.cardShadow()`, `.elevatedShadow()`, `.floatingShadow()`, `.brandStyle(_:BrandTextStyle)`

## App Entry Point
- `@main` struct: `ReSpeakApp` in `/Users/noahhova/Documents/respeak3-app/ReSpeak/App/ReSpeakApp.swift`
- WindowGroup root: `AppView()`

## Key File Paths
- Entry point: `ReSpeak/App/ReSpeakApp.swift`
- Root router: `ReSpeak/App/AppView.swift` — reads `@AppStorage("hasCompletedOnboarding")`
- Tab shell: `ReSpeak/App/MainTabView.swift`
- Practice screen: `ReSpeak/Features/Practice/PracticeView.swift`
- Exercise row: `ReSpeak/Features/Practice/ExerciseRowView.swift`
- Report stub: `ReSpeak/Features/Report/ReportView.swift`
- Help stub: `ReSpeak/Features/Help/HelpView.swift`
- Settings stub: `ReSpeak/Features/Settings/SettingsView.swift`
- Login screen: `ReSpeak/Views/LoginView.swift`
- Theme tokens: `ReSpeak/Theme/` (BrandColors, BrandGradients, BrandTypography, Radii, Shadows, Spacing)
- Xcode project: `ReSpeak.xcodeproj/project.pbxproj`

## Folder Structure
```
ReSpeak/
  App/           — ReSpeakApp, AppView, MainTabView
  Theme/         — All DS token files
  Models/        — (empty)
  Views/         — ContentView, ThemeDemoView, LoginView (legacy flat views)
  Features/      — Feature-scoped screen folders
    Practice/    — PracticeView, ExerciseRowView
    Report/      — ReportView
    Help/        — HelpView
    Settings/    — SettingsView
  ViewModels/    — (empty)
  Services/      — ServiceContainer
  Repositories/  — RepositoryContainer
  Resources/     — (empty)
```

## Xcode Project File Conventions
- Every new Swift file MUST be added to `project.pbxproj` manually (3 places: PBXBuildFile, PBXFileReference, PBXSourcesBuildPhase, and optionally a PBXGroup)
- ID naming pattern used: `XX000001000000000000XX00` for fileRef, `XX000001000000000000XX01` for build file
- Prefix key used in this project: TH=Theme, VW=Views, AA=App/services, AP=App nav files, FT=Features
- Group IDs for existing groups: App=AA100001, Theme=AA100002, Models=AA100003, Views=AA100004, Features=FT100000, ViewModels=AA100005, Services=AA100006, Repositories=AA100007, Resources=AA100008

## Navigation Pattern
- `AppView` is root — branches on `@AppStorage("hasCompletedOnboarding")`
- Authenticated shell: `MainTabView` with 4 tabs (Practice=0, Report=1, Help=2, Settings=3)
- Each tab wraps its own `NavigationStack` (not a shared one at MainTabView level)
- Tab tint: `BrandColors.primary`

## Key Conventions
- `NavigationStack` only (never `NavigationView`)
- `#Preview {}` macro style (Swift 5.9)
- `private` state, `// MARK: -` section headers
- No hardcoded hex/magic numbers — always DS tokens
- iOS 16+ minimum deployment target
- Bundle ID: `com.hovarehab.respeak`
