# مهمة Notaleq — تجهيز الأساس بس (مش implementation للـ features دلوقتي)

أنت Claude Code بتشتغل على Flutter app اسمه **Notaleq**: multi-line ledger calculator،
كل line بيتحسب لرقم واحد signed، وفيه running total live، وكل line ليه comment اختياري.
التفاصيل الكاملة (ERD، DDL، parsing grammar، interaction rules) موجودة في `SCHEMA.md` و في
project instructions جوه المشروع — **دول الـ source of truth، التزم بيهم وماتخالفهمش.**

---

## ⚠️ مهم — اقرأ ده الأول قبل أي كود
الرد ده مالهوش علاقة بتنفيذ أي feature. شغلك محصور في الحاجات دي بس، وبعدها **تقف وتستناني**:

1. تجيب الـ design وتستخرج منه الـ design system والـ components.
2. تجهّز الـ `pubspec.yaml` بالـ dependencies.
3. تعمل ملف `CLAUDE.md` فيه الـ project structure والـ conventions.
4. تعرض عليّ الخطة وتستنى موافقتي.

**متكتبش أي feature / business-logic / parser code في الـ pass ده.** التركيز كله على الأساس.

---

## Phase 0 — اقرأ وافهم
- اقرأ `SCHEMA.md` و الـ project instructions بالكامل.
- Fetch الـ design، اقرأ الـ readme بتاعه، وافتح الملف:
  - **URL:** https://api.anthropic.com/v1/design/h/bijQnegOGo1NX3nsEg8tOw?open_file=Notaleq.dc.html
  - **File:** `Notaleq.dc.html`

---

## Phase 1 — استخرج الـ design system (ده الأهم بالنسبالي)
الهدف: **متعملش recreate لأي حاجة Claude Design عملتها.** انقل اللي موجود زيّ ما هو
ورتّبه في أماكنه shared عشان reuse، من غير ما تغيّر الشكل:

- الـ colors → `lib/core/style/app_colors.dart`
- الـ typography / text styles → `lib/core/style/app_text_styles.dart`
- الـ theme (light / dark / system) → theme manager في `lib/core/style/`
- الـ fonts → حطها في `assets/fonts/` وسجّلها في `pubspec.yaml`
- الـ images / icons / assets → `lib/core/style/app_assets.dart` + فولدر `assets/`
- الـ reusable components/widgets اللي في الـ design (numpad keys، line row، total bar،
  buttons، ...): لو cross-feature تتحط في `lib/core/widgets/`، ولو خاصة بـ feature تتحط جوه
  `presentation/widgets/` بتاع الـ feature.

ملاحظات:
- **بلاش تغيّر الـ visual design** أو تعيد تصميم أي حاجة من الأول.
- لو فيه قيمة design system مش واضحة أو ناقصة من الملف، **اسألني بدل ما تخمّن**.

---

## Phase 1.5 — جهّز الـ pubspec.yaml والـ dependencies
ضيف الـ packages دي. **استخدم `flutter pub add` / `dart pub add` عشان الـ versions تتحل
لأحدث متوافق** — متعملش pin لأرقام ثابتة من دماغك.

**dependencies (runtime):**
- `flutter_bloc` — Cubit / state management.
- `get_it` — dependency injection.
- `drift` — الـ DB.
- `sqlite3_flutter_libs` — الـ native SQLite libs اللي drift بيحتاجها على mobile.
- `path_provider` + `path` — تحديد مكان ملف الـ DB.
- `fpdart` — للـ `Either<Failures, T>`. (لو تفضّل `dartz` ماشي، بس fpdart أحدث وأنشط maintenance —
  اختار **واحد بس** والتزم بيه.)
- `decimal` — الفلوس / precision.
- `shared_preferences` — الـ settings + `active_calculation_id`.
- `intl` — الـ `NumberFormat` / formatting.
- `freezed_annotation` — annotations بتاعة Freezed (دي runtime مش dev).

**dev_dependencies:**
- `build_runner` — الـ codegen runner.
- `drift_dev` — codegen بتاع drift.
- `freezed` — codegen بتاع الـ states.
- (`flutter_lints` غالباً موجود من `flutter create` — سيبه.)

ملاحظات:
- **مش محتاجين `json_serializable` / `json_annotation`** — الـ app local-only، مفيش JSON DTOs،
  و drift بيعمل الـ serialization بتاع الـ DB لوحده.
- باكدج صوت الـ click (`soundpool` أو `flutter_soloud`) **سيبها لوقت ما نبني الـ feedback layer**
  مش في الـ pass ده. الـ haptics أصلاً built-in (`HapticFeedback`) مش محتاجة package.
- بعد أي codegen change: `dart run build_runner build --delete-conflicting-outputs`.

---

## Phase 2 — اكتب CLAUDE.md
اعمل ملف `CLAUDE.md` في root المشروع يوصّف الـ structure والـ conventions اللي تحت.
ده مبني على architecture بشتغل بيها في الشغل، بس **متظبط للـ app ده اللي هو local-only
(SQLite) ومفيهوش أي network / backend**:

### Architecture
Clean Architecture + feature modules تحت `lib/features/`، و shared infrastructure تحت `lib/core/`.

### Core layer (`lib/core/`)
- `app/` — root app widget + `MaterialApp` + theme wiring.
- `di/injection_container.dart` — `setUpInjector()` واحدة بتسجّل كل الـ services/repos/cubits
  في `GetIt`، مجمّعة في `_initX()` helpers (واحد لكل feature)، و بتتعمل `await` في `main()`
  قبل `runApp()`.
- `database/` — تعريف الـ SQLite DB بـ **drift** (الجدولين `calculations` و `lines` بالظبط
  زي SCHEMA.md) + الـ DAOs. الـ generated code (`*.g.dart`) يقعد هنا. الـ DB classes اللي drift
  بيولّدها هي الـ data models بتاعة الـ persistence (مش محتاجين نعيد عملها بإيد).
- `errors/` — `Failures` base + `DatabaseFailure`. **مفيش `DioException` / `ServerFailure`
  لإن مفيش network خالص** — الـ failures كلها local DB / validation.
- `extensions/` — Dart extensions (string null/empty، context helpers، decimal helpers).
- `language/` — manual i18n: `assets/translations/{ar,en}.json` + `AppLocalizations` + key
  constants. (الـ app عربي أساساً.)
- `routes/` — `AppRoutes` (named-route constants) + `BaseRoute` (custom `PageRouteBuilder`
  بـ scale transition).
- `style/` — الـ design system كله جاي من Claude Design: `AppColors`، theme manager
  (light/dark/system)، `AppTextStyles`، `AppAssets`، fonts.
- `widgets/` — shared reusable widgets عبر أكتر من feature.
- `bloc_observer.dart` — `AppBlocObserver` يلوج الـ transitions في debug بس.

### Feature layer (`lib/features/<feature>/`)
```
feature/
  data/
    models/      # mapping/DTOs لو محتاج فوق drift classes (الـ DB models نفسها drift بيولّدها)
    repos/       # repository implementation، بتكلّم الـ DB DAO، وبترجّع Either<Failures, T>
  domain/
    entities/
    # (خاص بالـ calculator) parser/evaluator: pure Dart، صفر Flutter imports، unit-testable
  presentation/
    cubit/       # Cubit + immutable state classes
    screens/
    widgets/
```
الـ features المتوقّعة:
- `calculator` — الـ editor: lines + custom numpad + live total.
- `history` — الـ saved sheets (is_draft=0) + search بالاسم/التاريخ + tap to load.
- `settings` — sound / haptic / decimal_places / theme / currency.

### State management
- `flutter_bloc` بـ **Cubit** (مش full Bloc بـ events — ده اللي SCHEMA ماشي عليه).
- الـ **states بـ `Freezed`** (immutable + `copyWith` + equality + sealed/union states زي
  initial/loading/loaded/error). الـ DB models بس هي اللي drift بيولّدها — **Freezed للـ states
  والـ domain entities اللي مش DB، مش للـ DB models** (عشان مفيش تكرار).
- كل Cubit متسجّل في `GetIt` ويتقدّم عبر `BlocProvider(create: (_) => getIt<XCubit>())`.
- `AppBlocObserver` في debug بس.

### Code generation
- المشروع فيه `build_runner` أصلاً عشان **drift** و **Freezed**. أي تعديل على tables أو
  states يتبعه `dart run build_runner build --delete-conflicting-outputs`.

### Dependency Injection (conventions)
- Services / DB / SharedPreferences → `registerLazySingleton`.
- Repos → `registerLazySingleton`.
- Cubits → `registerFactory` (instance جديدة لكل screen).

### Error handling
- `Either<Failures, T>` (dartz أو fpdart) على الـ data/domain boundary. الـ repos بترجّع `Either`.

### Money / precision
- package `decimal`، الأرقام تتخزّن وتتحسب **decimal strings**، **ممنوع `double` للمبالغ**.

### Routing (steps لإضافة route)
1. ضيف الـ name constant في `AppRoutes`.
2. سجّل الـ Cubit(s) في `injection_container.dart`.
3. ضيف الـ `case` في الـ router يرجّع `BaseRoute(page: BlocProvider(...))`.

### Folder tree
حط `lib/` tree كامل بالشكل ده (عدّله حسب اللي طلع فعلاً):
```
lib/
  core/
    app/
    di/        injection_container.dart
    database/
    errors/
    extensions/
    language/
    routes/
    style/     # ← الـ design system من Claude Design
    widgets/
    bloc_observer.dart
  features/
    calculator/   data/  domain/  presentation/
    history/      data/  domain/  presentation/
    settings/     data/  domain/  presentation/
  main.dart
```

---

## Phase 3 — قف واستنى موافقتي
بعد ما تخلّص Phase 1 و 2، اعرض عليّ:

1. الـ `CLAUDE.md` كامل.
2. الـ folder structure النهائي + إيه اللي اتنقل من الـ design و راح فين بالظبط.
3. أي gaps أو نقص في الـ design system لازم أحسمه قبل ما تبدأ features.

> **قرارات محسومة (متسألش عليها):** الـ DB = **drift**. الـ states = **Freezed**.
> الـ DB models تيجي من drift، والـ Freezed للـ states و الـ non-DB domain entities بس.

**ومتبدأش أي feature implementation غير لما أوافق.**
