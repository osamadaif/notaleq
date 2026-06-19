# Notaleq — Project Guide (CLAUDE.md)

Notaleq is a **multi-line ledger calculator** (Flutter, Android + iOS, **local-only**,
no backend/network). Each *line* is an independent calculator expression that
evaluates to one signed number; the app keeps a **live running total** of all line
results, and every line can carry an optional Arabic comment. Sheets are saved by
name into a searchable history, or kept as an auto-persisted draft.

> **Source of truth:** `files/SCHEMA.md` (ERD, SQLite DDL, expression grammar,
> interaction rules, persistence) and `files/PROJECT_INSTRUCTIONS.md`. Keep code
> consistent with them; if a change requires touching the schema, flag it.

The UI is **Arabic-first / RTL**. Talk to the user (Osama) in Egyptian Arabic;
keep technical terms in English.

---

## Architecture

**Clean Architecture + feature modules.** Feature code lives under
`lib/features/<feature>/`; shared infrastructure under `lib/core/`.

Three features:

- `calculator` — the editor: lines + custom numpad + live total. (Hub screen.)
- `history` — saved sheets (`is_draft = 0`), search by name/date, tap to load.
- `settings` — sound / haptic / decimal_places / theme / currency.

### Core layer (`lib/core/`)

- `app/` — root `NotaleqApp` widget (`MaterialApp`, themes, locale, i18n wiring,
  `onGenerateRoute: AppRouter.onGenerateRoute`).
- `di/injection_container.dart` — single `setUpInjector()` that registers every
  service/repo/cubit in `GetIt`, grouped into `_initX()` helpers (one per
  feature). Awaited in `main()` before `runApp()`.
- `database/` — the drift SQLite DB: the two tables from `SCHEMA.md`
  (`calculations`, `lines`) + DAOs. Generated `*.g.dart` lives here. **The drift
  classes are the persistence data models** — don't hand-write them.
- `errors/failures.dart` — `Failures` (sealed) + `DatabaseFailure`,
  `ValidationFailure`, `NotFoundFailure`, `UnexpectedFailure`. No
  `ServerFailure`/network failures — the app is local-only.
- `extensions/` — Dart/Flutter extensions (string null/blank, context helpers;
  add decimal helpers when money logic lands).
- `language/` — **manual i18n**: `assets/translations/{ar,en}.json` +
  `AppLocalizations` (loads JSON, `context.tr(key)`) + `LangKeys` constants.
  Arabic is primary, English is the fallback.
- `routes/` — `AppRoutes` (named-route constants) + `BaseRoute` (custom
  `PageRouteBuilder` with a scale+fade transition).
- `style/` — **the design system, extracted from the Claude Design handoff**
  (`notaleq-design-prompt/project/Notaleq.dc.html`). See the next section.
- `widgets/` — cross-feature reusable widgets.
- `bloc_observer.dart` — `AppBlocObserver`, logs Cubit transitions in debug only.

### Feature layer (`lib/features/<feature>/`)

```
feature/
  data/
    models/      # mapping/DTOs above drift classes, only if needed
    repos/       # repository impl: talks to the DAO, returns Either<Failures, T>
  domain/
    entities/    # plain domain entities (Freezed where useful)
    parser/      # calculator only — pure-Dart expression parser/evaluator,
                 # zero Flutter imports, unit-testable
  presentation/
    cubit/       # Cubit + immutable (Freezed) state
    screens/
    widgets/
```

---

## Design system (`lib/core/style/`)

Extracted verbatim from the Claude Design handoff — **do not redesign**; reuse
these tokens.

| Concern | File | Notes |
|---|---|---|
| Colors | `app_colors.dart` | `AppColors` as a `ThemeExtension`. Full **light + dark** semantic sets (surfaces, text, accent, quiet `negative` clay tint, louder `error` set, numpad surface/key tokens). Read via `context.colors`. |
| Typography | `app_text_styles.dart` | `AppTextStyles`. IBM Plex Sans Arabic for all Arabic text; IBM Plex Mono (tabular) for all amounts. Styles are color-less; widgets apply color from `AppColors`. |
| Spacing / radii / elevation / motion / sizes | `app_dimens.dart` | `AppSpacing` (4pt base), `AppRadii` (12/16/24/28/999), `AppElevation`, `AppMotion` (key depress 80ms, line commit 180ms, total count-up 240ms), `AppSizes` (key heights, icon stroke). |
| Theme | `app_theme.dart` | `AppTheme.light` / `AppTheme.dark` build `ThemeData` and register `AppColors`. `AppThemeMode` maps the persisted `theme_mode` string ↔ `ThemeMode`. |
| Assets | `app_assets.dart` | Translation JSON paths. The exact design icons are SVGs under `assets/icons/`, rendered via `flutter_svg` (`AppIcons` + `AppSvgIcon`). |
| Fonts | `assets/fonts/` + `pubspec.yaml` | IBM Plex Sans Arabic (300–700) + IBM Plex Mono (400–700), bundled and registered. |

**Reusable widgets extracted from the design:**

- Cross-feature → `lib/core/widgets/`: `app_icons.dart` (`AppIcons` SVG paths + `AppSvgIcon`),
  `app_buttons.dart` (`PrimaryButton`/`SecondaryButton`), `search_field.dart`,
  `empty_state.dart`, `app_bottom_sheet.dart`, `confirm_dialog.dart` (AC guard),
  `toggle_row.dart`, `stepper_row.dart`, `segmented_control.dart`.
- Calculator → `features/calculator/presentation/widgets/`: `numpad_key.dart`
  (families digit/operator/function/commit; default/pressed/disabled states),
  `numpad.dart`, `ledger_row.dart` (header/normal/negative/active/error/
  amount-only variants), `total_bar.dart`, `ledger_top_bar.dart`.
- History → `features/history/presentation/widgets/`: `history_list_item.dart`.

All widgets are **pure presentation** — they take display-ready strings + enums +
callbacks. No business logic, parsing, money math, or persistence lives in them.

---

## State management

- `flutter_bloc` with **Cubit** (not event-based Bloc).
- State classes use **Freezed** (immutable, `copyWith`, equality, sealed/union
  states like initial/loading/loaded/error). Freezed 3.x: write
  `sealed class XState with _$XState` and `const factory` variants.
- **Freezed is for states and non-DB domain entities only.** DB models come from
  drift — never duplicate them with Freezed.
- Every Cubit is registered in `GetIt` and provided via
  `BlocProvider(create: (_) => getIt<XCubit>())`.
- `AppBlocObserver` is set in `main()` (debug logging only).

## Error handling

`Either<Failures, T>` (**fpdart**) across the data/domain boundary. Repositories
return `Either`. Left is always a `Failures` subtype (all local — DB/validation).

## Money / precision

Use the **`decimal`** package. Amounts are stored/computed as **decimal strings**
— **never `double`** (`0.1 + 0.2` breaks). Format for display with `intl`
`NumberFormat` (Western digits `0-9`, `,` thousands on the integer part only,
`.` decimal). Presentation widgets receive **already-formatted** strings.

## Dependency injection (conventions)

- Services / DB / SharedPreferences → `registerLazySingleton`.
- Repositories → `registerLazySingleton`.
- Cubits → `registerFactory` (fresh instance per screen).

## Routing (steps to add a route)

1. Add the name constant in `AppRoutes`.
2. Register the Cubit(s) in `injection_container.dart`.
3. Add the `case` in `AppRouter` returning
   `BaseRoute(page: BlocProvider(create: (_) => getIt<XCubit>(), child: XScreen()))`.

## Code generation

`build_runner` drives **drift** (DB) and **freezed** (states). After any change to
tables or state classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Dependencies (why each is here)

Runtime: `flutter_bloc` (Cubit) · `get_it` (DI) · `drift` + `sqlite3_flutter_libs`
(DB) · `path_provider` + `path` (DB file location) · `fpdart`
(`Either<Failures,T>`) · `decimal` (money) · `shared_preferences`
(settings + `active_calculation_id`) · `intl` (`NumberFormat`) ·
`freezed_annotation` (state annotations) · `flutter_localizations` (SDK; Arabic
RTL Material localization) · `flutter_svg` (renders the exact design icon set).

Dev: `build_runner` · `drift_dev` · `freezed` · `flutter_lints`.

Deliberately **not** added: `json_serializable`/`json_annotation` (local-only, no
JSON DTOs — drift handles DB serialization). The click-sound package
(`soundpool`/`flutter_soloud`) is deferred to the feedback layer; haptics use the
built-in `HapticFeedback`.

---

## Persistence summary (see `SCHEMA.md`)

- SQLite (drift), two tables: `calculations` (draft `is_draft=1` + saved sheets
  `is_draft=0`, with `cached_total`) and `lines`. A drift `watch()` over lines
  makes the live total + history list reactive for free.
- SharedPreferences: `active_calculation_id`, `sound_enabled`, `haptic_enabled`,
  `decimal_places` (default 2), `currency_code`, `theme_mode`.

---

## Folder tree

```
lib/
  core/
    app/         app.dart
    di/          injection_container.dart
    database/    app_database.dart (+ app_database.g.dart) — drift DB + DAOs
    errors/      failures.dart
    extensions/  string_extensions.dart · context_extensions.dart
    format/      amount_formatter.dart
    language/    app_localizations.dart · language_keys.dart
    routes/      app_routes.dart · base_route.dart · app_router.dart
    style/       app_colors.dart · app_text_styles.dart · app_dimens.dart
                 app_theme.dart · app_assets.dart        # ← design system
    widgets/     app_icons · app_buttons · search_field · empty_state
                 app_bottom_sheet · confirm_dialog · toggle_row
                 stepper_row · segmented_control
    bloc_observer.dart
  features/
    calculator/  data/repos · domain/{entities,parser,expression_input}
                 presentation/{cubit,screens,widgets}        # ← implemented
    history/     data/repos · presentation/{cubit,screens,widgets}  # ← implemented
    settings/    data/repos · presentation/{cubit,screens,widgets}  # ← implemented
  main.dart
assets/
  fonts/         IBM Plex Sans Arabic (300–700) · IBM Plex Mono (400–700)
  translations/  ar.json · en.json
```

## Commands

```bash
flutter pub get
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs   # after codegen changes
flutter run
```
