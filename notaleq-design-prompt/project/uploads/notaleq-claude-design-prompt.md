# Claude Design Brief — Notaleq (multi-line ledger calculator)

You are designing a mobile app called **Notaleq**. Before producing any screen,
**first show me your understanding of the information architecture** (a screen
map + flows), then build a **design system**, then design **every screen in both
light and dark**. Work in this order and don't skip the IA step.

---

## 0. What the app is (read carefully)

Notaleq is **not a normal calculator**. It's a **multi-line ledger calculator**
for everyday money math (monthly budget / household reckoning).

- The user types a **vertical list of lines**, top to bottom.
- **Each line is its own small calculator expression** that evaluates to one
  signed number (e.g. `-200*4` → `-800`, `100/2` → `50`).
- **Each line can carry a comment** next to its amount (e.g. "المرتب", "ايجار").
- The app keeps a **live running total** of all the line results, always visible.
- A line can be **comment-only** (acts as a section header, contributes `0`).
- Invalid / incomplete / divide-by-zero lines are **flagged as errors** and
  **excluded from the total** (shown but visually marked, never crash).
- Sheets can be **saved by name** into a searchable **history**, or kept as an
  **auto-persisted draft**.

Think: a spreadsheet column + a calculator + a notes app, fused into one calm,
numbers-forward mobile screen.

---

## 1. Hard constraints (these define the product — honor them in the visuals)

1. **RTL / bidi first.** The UI language is **Arabic** (Egyptian). Comments are
   Arabic; **amounts are Western digits `0-9`** with `,` thousands and `.`
   decimal. Both live **in the same row** — design must hold up when the comment
   is long AND the amount is long. Show this stress case in the designs, don't
   hide it.
2. **Tabular / monospaced figures for all amounts** so columns of numbers align
   vertically down the ledger and in the total.
3. **Two input zones per line, two different keyboards:**
   - **Amount → a custom in-app numpad** (the OS keyboard must NEVER appear for
     amounts).
   - **Comment → the system keyboard only.**
4. **The active (currently-edited) line shows a large number**, Samsung-style.
   Once committed, it settles down into the list at normal size. The amount being
   typed is visibly bigger than the rest.
5. **Live total is sticky**, sitting directly **above the numpad**, never
   scrolling away.
6. **Every numpad key needs a clearly depressed pressed-state** (this is a core
   feel requirement — the key must look physically pushed in), plus implied
   haptic + click-sound feedback.
7. **Light + dark themes**, both first-class.

---

## 2. Screen map / IA (produce this first, then design)

Lay out the navigation and flows for these screens before designing them:

1. **Calculator (Ledger)** — the home screen, where 90% of usage happens.
2. **History** — list of saved sheets, searchable, tap to load.
3. **Save sheet** — name + confirm (default name = current date/time).
4. **Settings** — toggles + preferences.
5. **AC confirmation** — destructive "clear the whole sheet" guard.
6. **Empty states** — fresh empty draft, and empty history.

Show how the user moves between them (e.g. ledger ⇄ history, ledger → save,
ledger → settings).

---

## 3. Design system (build this second)

Deliver a proper system page covering:

- **Brand feel / direction.** Target mood: **calm, precise, trustworthy** — it's
  a money tool. Numbers-forward and highly legible, with a refined,
  Samsung-calculator-inspired numpad that feels a notch more premium than the
  stock OS calculator. Pick **one accent color** with intent and justify it.
- **Color tokens** — full **light + dark** sets: surfaces/backgrounds, text
  (primary/secondary/muted), accent, **error** color (for flagged lines), and a
  subtle treatment for **signed values** (decide whether negatives get a quiet
  color cue — keep it tasteful, this is a ledger not a stoplight). Provide the
  numpad's own surface/key tokens.
- **Typography** — define the **amount type style** (tabular figures, the large
  active style + the settled list style + the big total style) and the **Arabic
  comment / label style**. Choose fonts that render Arabic cleanly and have
  tabular numerals.
- **Spacing scale, corner radii, elevation/shadows, iconography style, motion**
  (key-press depress, line-commit transition, optional total count-up).
- **Touch targets:** numpad keys must be thumb-friendly (≥ 48dp), comfortably
  reachable one-handed.

---

## 4. Component inventory (design these as reusable pieces)

- **LedgerRow** — variants: normal (amount + comment), **active/focused** (large
  amount), **error** (flagged, excluded), **section-header** (comment-only, no
  amount), and amount-only (no comment).
- **TotalBar** — sticky, label + large total, optional currency, sits above the
  numpad.
- **NumpadKey** — three families with distinct visual weight: **digits**
  (`0-9`, `.`), **operators** (`+ − × ÷`, `(`, `)`, `%`), **functions** (`⌫`,
  `C`, `AC`, `↵` new-line, and a **toggle key that jumps to the comment field**).
  Each in states: default / **pressed (clearly depressed)** / disabled (e.g.
  operators disable once 2 are placed).
- **Numpad** — the full key grid, laid out for one-handed thumb use. Decide a
  clean, defensible arrangement of the keys above.
- **TopBar** — sheet name (or "مسودّة / Draft"), access to history, save, settings.
- **SearchField** — for history.
- **HistoryListItem** — sheet name, date, cached total preview; supports
  tap-to-load and a delete affordance.
- **ToggleRow / Stepper / Segmented control** — for settings (sound, haptic,
  decimal places, theme mode), 
- **Dialog** + **BottomSheet** — for AC confirmation and Save.
- **Empty-state** treatments.

---

## 5. Screen-by-screen detail (design third — light + dark each)

### 5.1 Calculator (Ledger) — the heart
- Top: sheet name + history / save / settings access.
- Middle: the scrollable **ledger** — rows of `amount + comment`, with the
  **active line enlarged**. Include in the mock: a couple normal lines, a
  **negative** line, an **error** line, and a **comment-only section header**.
- Above the numpad: the **sticky TotalBar**.
- Bottom: the **custom numpad**.
- Show the screen in **two moments**: (a) mid-typing an amount (active line big,
  numpad in focus), and (b) editing a comment (system keyboard implied / numpad
  swapped out via the comment-toggle).

**Use this real sheet as the sample data** (it's the canonical example — name
"مصاريف الشهر", total should read **1750**):

| amount | comment |
|---|---|
| 10000 | المرتب |
| -1000 | المحامي |
| -500 | عزومة |
| -3000 | ايجار |
| -5000 | مصاريف البيت |
| 2000 | باقي حسابي عند التاجر |
| -800  | الدفعات اللي عليا |
| 50    | بتوع الحلاق |

### 5.2 History
- Search bar (by name + date), list of saved sheets (name, date, total),
  tap-to-load, delete affordance, and an **empty-history** state.

### 5.3 Save sheet (bottom sheet or dialog)
- Name field **prefilled with current date/time**, save / cancel.

### 5.4 Settings
- Toggles: **click sound**, **haptics**. Stepper: **decimal places** (default 2).
- Optional **currency** picker. **Theme mode**: light / dark / system. About.

### 5.5 AC confirmation
- Destructive guard before wiping the whole sheet. Make the stakes clear.

---

## 6. Deliverables & order

1. **IA / screen map + flows** (first).
2. **Design system page** (tokens, type, components, states).
3. **All screens above, in light AND dark**, including the stress cases
   (long comment + long amount in one row, error line, active-line-large moment).

Keep it cohesive: one system, consistently applied. Prioritize **legibility of
numbers**, **RTL correctness**, and **the tactile numpad feel**.
