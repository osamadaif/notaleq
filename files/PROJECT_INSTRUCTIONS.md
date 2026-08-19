# Notaleq — Project Instructions

Paste this into the Claude Project's **custom instructions** field. It gives
every conversation in this project the full context of the app.

---

## What we're building

**Notaleq** is a Flutter calculator app with a local SQLite database — but
it's not a normal calculator. It's a **multi-line ledger calculator**: the user
enters a vertical list of lines, each line is its own small calculator
expression that evaluates to one signed number, each line can carry a **comment**
(e.g. "المرتب", "ايجار"), and the app keeps a **live running total** of all the
line results. Built for everyday money math like a monthly budget / household
reckoning. Calculations can be saved by name into a searchable history, or kept
as an auto-persisted draft.

The full data model, ERD, SQLite schema, and parsing rules live in `SCHEMA.md` —
treat that file as the source of truth and keep code consistent with it.

---

## Communication

- Talk to the user (Osama) in **Egyptian Arabic**. Keep all **technical terms in
  English** (package names, class names, Flutter/Dart terms, etc.).
- He works AI-assisted (Claude Code / Cowork). When implementing, produce
  **structured, phased prompts / steps**, not one giant dump.

---

## Tech stack

- **Flutter / Dart**, targeting Android + iOS.
- **State management:** `flutter_bloc` (Cubit). Immutable state classes.
- **Error handling:** `Either<Failures, T>` (dartz / fpdart) — the pattern he
  already uses. Repositories return `Either`.
- **Local DB:** SQLite. Recommended `drift` (type-safe + reactive `.watch()`
  streams make the live total and history list trivial with Cubit). `sqflite` is
  an acceptable lighter alternative if preferred — confirm with the user before
  picking.
- **Money / precision:** the `decimal` package. **Never use `double` for
  amounts** (`0.1 + 0.2` breaks). Store amounts as decimal strings.
- **Key-value:** `shared_preferences` (settings + `active_calculation_id`).
- **Formatting:** `intl` (`NumberFormat`). Western digits `0-9`, `,` thousands,
  `.` decimal.
- **Feedback:** `HapticFeedback` (lightImpact / selectionClick) + a low-latency
  click sound (`soundpool` or `flutter_soloud`, cached in memory). Respect the
  system silent/ringer mode. Both are user-toggleable in settings.
- **Keep dependencies minimal.** Don't add a package unless it clearly earns its
  place. No heavy UI kit.

---

## Architecture

- **Feature-based** structure: `lib/features/<feature_name>/` with
  `data / domain / presentation` layers per feature.
- A Cubit per feature with immutable states.
- Preserve the `Either<Failures, T>` pattern across the data/domain boundary.
- The expression parser/evaluator is pure Dart domain logic (no Flutter imports)
  so it's easily unit-tested.

---

## Domain rules (summary — see SCHEMA.md for detail)

**Per-line expression** = Samsung basic calculator, capped at **3 operands /
2 operators**:
- Operators `+ - * /`, with precedence (`* /` before `+ -`), parentheses to
  override, optional leading unary minus, and Samsung-style postfix `%`
  (`100 + 10% = 110`; `%` is a modifier, not a 4th operand).
- Decimal `.` (one per number, leading `.` → `0.`, trailing `.` allowed while
  typing). Thousands grouping on the **integer part only**, at display time.

**Interaction:**
- **Operator replace:** an operator pressed after an operator replaces it,
  except that replacing a trailing `× / ÷` with `+ / −` settles the valid
  prefix and opens the additive operator on the next row.
- On a valid row, `+ / −` commit it and start the next row carrying that
  operator. On an empty row they are written in place. On a trailing-operator
  row they replace in place unless the multiply/divide exception above applies.
  `× / ÷` stay in the current row while the input cap allows them.
- **New-line is blocked while the line is incomplete** (empty / only an operator
  / dangling operator). It commits and descends only when the line is a valid
  expression. Triggers: numpad `↵`, tapping the area below, or the keyboard
  return key while editing a comment.
- **`⌫`** deletes the last char; **C** clears the active line; **AC** clears the
  whole sheet (with confirmation).
- **Division by zero / invalid** → line flagged `is_error`, excluded from total,
  no crash.
- **`=`** on a valid expression inserts a persisted, non-editable subtotal and
  opens a continuation row. The subtotal updates when rows above it change and
  does not reset the running tape.
- **Export:** the calculator top bar has one Share action that opens an
  Image/PDF picker. Saved-sheet detail shows separate Image and PDF actions.
  After format selection, an explicit Watch-ad/Cancel dialog gates each export
  attempt. A rewarded-ad completion opens the native share sheet directly;
  there is no preview screen and no persisted unlock.
  The shared A4 document includes the sheet name/date, numbered operation table,
  comments and section headers, excluded errors, subtotals, currency, final
  total, and page numbering. Long PDFs paginate automatically; Image export
  shares the rasterized PDF pages as multiple PNG files when needed. Both
  formats always use the light design palette and an opaque light page
  background, even while the app is in dark mode. The header uses the bundled
  Notaleq mark with the app name underneath; operators are bold accent glyphs
  separated from their amounts, and table columns have vertical dividers.

**Total** = a running tape over non-error expression rows: leading `+ / −` add a
signed value, while leading `× / ÷` multiply or divide the running result.
Subtotal markers display the total above them without changing it. The final
total is recomputed live and cached in `calculations.cached_total`.

**Persistence:** active sheet auto-saved as a draft (`is_draft = 1`) so it
survives app kill. "Save" sets a name (`is_draft = 0`). History = saved sheets
by `updated_at`, searchable by name/date and opened read-only. `lines.entry_type`
stores `expression` / `subtotal`; schema v2 migrates v1 rows to `expression`.
Settings + `active_calculation_id` live in `shared_preferences`.

---

## UI / UX decisions

- **Row-based ledger layout**, not cards. A scrollable vertical list of lines:
  amount (large, right area) + comment beside it. Sticky **live total** at the
  bottom, directly above the numpad.
- **Active line shows a large number**, Samsung-style; once committed it settles
  into the list. The amount being typed is bigger than the rest.
- **RTL / bidi aware.** Arabic comments + Western-digit amounts in the same row;
  test early with long amounts and long comments — this layout breaks easily.
- **Two input zones per line:**
  - **Amount → custom in-app numpad** (no system keyboard). Use a no-keyboard
    field / custom widget so the OS keyboard never pops for amounts.
  - **Comment → system keyboard only.** Its return/action key = new line.
- **Numpad keys:** `0-9`, `.`, `+ - * /`, `(`, `)`, `%`, `⌫`, `C`, `AC`,
  `↵` (new line), and a toggle to jump to the comment field.
- **Key feedback on every press:** haptic + click sound + a visible pressed
  state (the button should clearly look depressed). Feedback respects the user
  toggles + system silent mode.
- **History screen:** saved sheets listed by name/date, searchable, tap to view
  read-only detail.
- **Light + dark themes.**

---

## Out of scope for v1

Soulver-style line references; currency conversion; cloud sync.
Note them as future work; don't build them yet.

---

## Working agreement

- Before writing code for a feature, confirm the approach in a short plan.
- Keep code aligned with `SCHEMA.md`; if a change requires touching the schema,
  flag it explicitly.
- Prefer pure, unit-testable domain logic for the parser/evaluator and the total.
