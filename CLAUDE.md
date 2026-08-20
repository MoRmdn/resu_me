# resu_me — Mohamed Ramadan's portfolio

A single-page Flutter Web portfolio, deployed to Firebase Hosting. One scrolling
page, seven sections, plus a small admin route for contact submissions.

Design codename: **Obsidian & Copper**. The visual language is specified in
`design/` and is the authority for anything visual — read it before touching UI.

---

## Quick start

```bash
flutter pub get
```

Run the web app (this is the only target that's actively exercised):

```bash
flutter run -d chrome
```

Static analysis — should report only the 7 known `splash_screen_service.dart`
infos, nothing else:

```bash
flutter analyze lib
```

> Run `flutter analyze lib`, not bare `flutter analyze`. The latter also walks
> `build/ios/SourcePackages/**` and reports errors from vendored Firebase
> example code that have nothing to do with this project.

Build and deploy:

```bash
flutter build web --release && firebase deploy
```

CI deploys from `.github/workflows/firebase-deploy.yml`.

---

## Architecture

Plain `StatefulWidget` + `setState`. No state-management package, no DI, no
routing package — the app is one page and doesn't need them.

```
lib/
├── main.dart                  ThemeData: palette, type scale, component themes
├── firebase_options.dart      generated — do not hand-edit
│
├── pages/
│   ├── home_page.dart         the scroll host + nav wiring + scroll progress
│   └── admin_page.dart        contact-submission inbox (not linked from the UI)
│
├── widgets/                   one file per page section, plus shared primitives
│   ├── navigation_bar.dart    fixed pill nav, hamburger under 680px
│   ├── hero_section.dart      headline, metric counters, live view count
│   ├── tech_marquee.dart      infinite ticker-driven strip
│   ├── about_section.dart     bio + outcome-stat grid
│   ├── experience_timeline.dart  expandable role rows
│   ├── projects_section.dart  flagship card + responsive grid
│   ├── skills_section.dart    grouped capability table
│   ├── contact_section.dart   CTAs, link panel, Firebase-backed form
│   ├── system_section.dart    design-system appendix (palette/type/logo/motion)
│   ├── site_footer.dart
│   ├── cursor_glow.dart       pointer-following copper radial (desktop only)
│   ├── eyebrow.dart           shared mono section label
│   └── mo_rmdn_logo.dart      the composed-M mark, CustomPainter
│
├── models/                    Experience, Project — plain immutable classes
├── data/portfolio_data.dart   all project + experience content
├── services/
│   ├── realtime_database_service.dart  contact submissions + view counter
│   ├── url_launcher_service.dart       mailto/tel/external links
│   └── splash_screen_service.dart      dismisses the HTML splash (web only)
└── utils/
    ├── app_colors.dart        every colour token
    ├── constants.dart         identity, contact, URLs, layout constants
    └── responsive_helper.dart breakpoint predicates
```

### How the page is composed

`home_page.dart` owns a `ScrollController` and a `List<GlobalKey>` — one key per
navigable section. The nav calls `_scrollToSection(index)`, which resolves the
key's context and calls `Scrollable.ensureVisible`. A `Stack` layers, bottom to
top: the scrolling content, the 2px copper scroll-progress bar, then the nav pill.

Each section widget paints its own full-bleed background and centres a
`AppConstants.maxContentWidth` (1240px) column inside it. Section backgrounds
alternate `ink900` / `ink800` so they separate without needing rules.

**The scroll host is a `SingleChildScrollView` + `Column`, deliberately not a
`ListView`.** This is load-bearing — see `design/IMPLEMENTATION-MAP.md`
§ "Layout invariants" before changing it. The short version: lazy slivers break
both the `GlobalKey` nav scrolling and the resizing experience accordion.

### Firebase

Realtime Database, two paths:

- `contact_submissions/` — pushed by the contact form; read by `admin_page.dart`.
- `views` — a counter incremented once per page load, streamed live into the
  hero card and footer.

Rules live in `database.rules.json`. Config is `firebase_options.dart`
(generated) and `firebase.json` (hosting + rules).

---

## Design system

`design/` is the source of truth for anything visual:

| File | What it is |
|---|---|
| `design/DESIGN-SYSTEM.md` | tokens, type scale, components, motion, and a "Not yet built" gap list |
| `design/LOGO.md` | the composed-M mark: geometry, variations, usage rules |
| `design/IMPLEMENTATION-MAP.md` | **read this first** — spec → Dart file mapping, layout invariants, gotchas |
| `design/portfolio-redesign.dc.html` | the original Claude Design artboard, for reference rendering |

House rules:

- **No raw hex in widget files.** Every colour comes from `AppColors`. Need a
  new shade? Add it to `AppColors` first.
- **One copper accent per viewport.** If two things are copper, one is wrong.
- Elevation is hairlines and offsets, not blur.
- Fonts are `'Archivo'` and `'JetBrains Mono'` by exact family name.

---

## Known constraints

These are real and will bite you. They're why some code looks unusual.

**`google_fonts` and `font_awesome_flutter` are removed and must stay removed.**
Neither compiles on the installed Flutter SDK: `IconData` became a `final`
class (font_awesome extends it), and `google_fonts` has a const map keyed on
`FontWeight`, which no longer has primitive equality. Fonts now load from a
`<link>` in `web/index.html`. Store links use text + `↗` instead of brand icons.
Don't re-add either package to "clean this up" — it breaks the build outright.

**Never drive `setState` from `MouseRegion.onHover`.** It corrupts Flutter
web's mouse tracker and freezes pointer input for the entire page. The hero's
cursor-follow glow (`lib/widgets/cursor_glow.dart`) is therefore rebuild-free:
the pointer position lives in a `ValueNotifier` handed to the painter as its
`repaint` `Listenable`, so a move repaints one `RepaintBoundary` and never
rebuilds a widget. Keep any new pointer-tracked effect to that pattern.

**Sections get unbounded height.** Because the page is a
`SingleChildScrollView`, any `Center` wrapping section content needs
`heightFactor: 1`, and page-level `Column`s need `mainAxisSize: MainAxisSize.min`.
Otherwise: `RenderFlex object was given an infinite size`.

**Don't measure intrinsics across a cover-fitted image.** `IntrinsicHeight` and
`Row(crossAxisAlignment: stretch)` assert `height.isFinite`; an `Image` sized to
`double.infinity` reports unbounded intrinsic height. Give media panels an
explicit height and wrap the image in `SizedBox.expand`.

**Ticker callbacks must check `hasContentDimensions`,** not just `hasClients` —
otherwise reading `maxScrollExtent` throws on the first frames. See
`tech_marquee.dart`.

**`Container` takes `color:` or `decoration:`, never both.** Flutter asserts and
the whole subtree renders as a red error box. Put the fill inside
`BoxDecoration(color: …)`.

**Debugging layout errors:** the console fills with `Another exception was
thrown: …` cascades; `RenderBox was not laid out` is always a symptom. Filter
the console for `error-causing widget` to get the real widget and `file:line`.

**`AppColors` legacy aliases** (`primaryBlue`, `cardBackground`, `textPrimary`, …)
exist only so `admin_page.dart` keeps compiling against the new palette. Don't
use them in new code.

---

## Conventions

- `flutter analyze lib` clean before you call something done. The only
  acceptable output is the 7 known `splash_screen_service.dart` infos.
- `dart format lib` after edits.
- Content changes go in `lib/data/portfolio_data.dart` or
  `lib/utils/constants.dart`, not inline in widgets — except one-off section
  prose, which lives with its section.
- Responsive behaviour: prefer `LayoutBuilder` against real constraints inside
  a section; use `ResponsiveHelper` breakpoints for page-level layout switches.

## Open items

- Only Arcit-AI has a screenshot (`assets/images/arcit-ai.png`, wired via
  `Project.imageUrl`). Other projects fall back to the wireframe placeholder —
  drop a PNG in `assets/images/` and set `imageUrl` on that project to fill it.
- Light ("Bone") theme is specced in `design/DESIGN-SYSTEM.md` §1.2 but not
  implemented; the app is dark-only.
- `prefers-reduced-motion` is not wired up (`MediaQuery.disableAnimations`).
- `admin_page.dart` has no route or auth — it's reachable only by editing code.
