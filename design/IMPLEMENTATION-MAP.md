# Design → Code map

How the "Obsidian & Copper" spec lands in Dart. Read this before changing
anything visual — it tells you which file owns which part of the design.

## Source of truth chain

```
design/portfolio-redesign.dc.html   the original Claude Design artboard (reference render)
design/DESIGN-SYSTEM.md             tokens, scale, components, motion   ─┐
design/LOGO.md                      identity rules                      ─┤
                                                                         ├─→  lib/
lib/utils/app_colors.dart           every colour token, one class        ─┤
lib/main.dart                       ThemeData: fonts, type scale         ─┘
```

**Rule:** no raw hex in widget files. Every colour comes from `AppColors`.
If you need a shade that isn't there, add it to `AppColors` first.

## Token → Dart

| Spec token | Dart |
|---|---|
| `--ink-900` | `AppColors.ink900` |
| `--ink-800` | `AppColors.ink800` |
| `--ink-700` | `AppColors.ink700` |
| `--ink-600` | `AppColors.ink600` |
| `--bone` | `AppColors.bone` |
| `--bone-70/45/38/28` | `AppColors.bone70` / `bone62` / `bone45` / `bone38` / `bone28` |
| `--line` | `AppColors.line` |
| `--line-strong` | `AppColors.lineStrong` |
| `--copper` | `AppColors.copper` |
| `--copper` hover | `AppColors.copperBright` (`#FF8A45`) |
| `--copper-dim` | `AppColors.copperDim` |
| `--copper-wash` | `AppColors.copperWash` |
| `--jade` | `AppColors.jade` |
| `--rose` | `AppColors.rose` |
| max content width 1240 | `AppConstants.maxContentWidth` |
| section padding 128 / 76 | `AppConstants.sectionPaddingDesktop` / `…Mobile` |

`AppColors` also keeps a block of **legacy aliases** (`primaryBlue`,
`cardBackground`, `textPrimary`, …) mapped onto the new palette. They exist
only so `lib/pages/admin_page.dart` keeps compiling. Don't use them in new code.

## Section → file

Page order is defined in `lib/pages/home_page.dart`. Each section is a
self-contained widget that paints its own full-bleed background and centres a
`maxContentWidth` column inside it.

| # | Section | File | Background |
|---|---|---|---|
| — | Nav pill + scroll progress | `widgets/navigation_bar.dart` | translucent `ink700` |
| 0 | Hero | `widgets/hero_section.dart` | `ink900` |
| — | Tech marquee | `widgets/tech_marquee.dart` | `ink800` |
| 1 | About | `widgets/about_section.dart` | `ink900` |
| 2 | Experience | `widgets/experience_timeline.dart` | `ink800` |
| 3 | Projects | `widgets/projects_section.dart` | `ink900` |
| 4 | Skills | `widgets/skills_section.dart` | `ink800` |
| 5 | Contact | `widgets/contact_section.dart` | `ink900` |
| 6 | System appendix | `widgets/system_section.dart` | `ink800` |
| — | Footer | `widgets/site_footer.dart` | `ink900` |

Backgrounds alternate `ink900` / `ink800` to separate sections without rules.

### Shared primitives

| Widget | File | Use |
|---|---|---|
| `Eyebrow` | `widgets/eyebrow.dart` | mono uppercase section label (`01 / ABOUT`) |
| `MoRmdnMark` | `widgets/mo_rmdn_logo.dart` | the composed-M icon, `CustomPainter` |
| `MoRmdnLockup` | `widgets/mo_rmdn_logo.dart` | mark + wordmark |

## Layout invariants — do not break these

The page scrolls in a **`SingleChildScrollView` + `Column`**, deliberately not a
`ListView`. Two reasons, both load-bearing:

1. Nav scrolling uses `GlobalKey`s + `Scrollable.ensureVisible`. A lazy
   `ListView` doesn't build off-screen sections, so their keys have no
   `currentContext` and nav clicks silently do nothing.
2. The experience accordion resizes in place. Inside a lazy sliver that
   desyncs the sliver's child-geometry bookkeeping and throws
   `Cannot hit test a render box that has never been laid out`, which kills
   pointer input for the whole page.

**Consequence:** every section gets *unbounded height*. So:

- The `Center` that wraps a section's max-width column **must** pass
  `heightFactor: 1`. A bare `Center` (`RenderPositionedBox`) expands to
  `constraints.biggest` — infinite here — and throws
  `RenderPositionedBox object was given an infinite size`.
- Any `Column` that is a direct child of the page (or of that `Center` /
  `ConstrainedBox`) **must** set `mainAxisSize: MainAxisSize.min`, or you get
  `RenderFlex object was given an infinite size`.
- Same for `Column`s nested inside `SizeTransition`.

Other invariants:

- **Don't measure intrinsics across a cover-fitted image.** `IntrinsicHeight`
  (and any `Row` with `CrossAxisAlignment.stretch` under it) calls
  `computeMaxIntrinsicHeight`, which asserts `height.isFinite`. An `Image`
  sized `height: double.infinity` reports unbounded intrinsic height and trips
  it. The flagship project card therefore gives its media panel an explicit
  height and uses `SizedBox.expand` around the `Image`, instead of stretching.
- `Container` takes **either** `color:` **or** `decoration:`, never both —
  Flutter asserts and the subtree renders as a red error box. If you need a
  border plus a fill, put the fill inside `BoxDecoration(color: …)`.
- Never drive `setState` from `MouseRegion.onHover`. It corrupts Flutter web's
  mouse tracker and freezes all pointer input (this is why the cursor-follow
  glow was removed). Hover *enter/exit* state is fine.
- **Ticker callbacks must check `hasContentDimensions`.** `TechMarquee` drives
  a `ScrollController` from a `Ticker`; `hasClients` alone is not enough,
  because on the first frames the position exists but isn't laid out and
  reading `maxScrollExtent` throws every frame.

### Debugging layout errors

Flutter web floods the console with `Another exception was thrown: …` summaries
that are all downstream cascades. `RenderBox was not laid out` is *always* a
symptom, never the cause. Find the real one:

```
read_console_messages(pattern: "error-causing widget")
```

That gives the widget and the `file:line` that actually broke. Note the console
buffer keeps pre-reload entries, so open a fresh tab before trusting a match.

## Responsive

`lib/utils/responsive_helper.dart`, breakpoints in `AppConstants`:

- `isMobile` → `< 680`: single column, hamburger nav, 20px page padding.
- `isTablet` → `680–900`: sections stack but keep desktop type sizes.
- desktop → `≥ 900`: 7/5 and 8/4 asymmetric splits, full nav, 32px padding.

Grids inside sections size themselves off `LayoutBuilder` constraints rather
than the global breakpoint, because a section's column can be narrower than
the viewport suggests.

## Fonts

`Archivo` (display/body) and `JetBrains Mono` (eyebrows, metadata) load from a
`<link>` in `web/index.html`. The `google_fonts` package is **not** used — see
`CLAUDE.md` § Known constraints.

In Dart, reference them by exact family name:

```dart
fontFamily: 'Archivo'        // also the ThemeData default, usually implicit
fontFamily: 'JetBrains Mono' // note the space
```

## Content

Copy and project/experience data live in:

- `lib/data/portfolio_data.dart` — projects and experience entries
- `lib/utils/constants.dart` — name, contact details, social + store URLs
- section widgets — headline/prose copy is inline, since it's one-off per section

## Known content gap

The flagship project card expects `assets/arcit_ai_screenshot.png`. The file
isn't in the repo yet, so `_ScreenshotOrPlaceholder` falls back to a wireframe
device placeholder. Drop the PNG in `assets/`, declare it under `flutter:
assets:` in `pubspec.yaml`, and it renders automatically.
