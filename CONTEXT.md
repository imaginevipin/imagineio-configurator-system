# Project Context — imagine.io Configurator Generation System

**GitHub repo:** https://github.com/imaginevipin/imagineio-configurator-system
**Local path:** `/Users/vipinmeena/Desktop/01 Projects/06 Configurator-Claude System`
**Design system:** Prism Design System (PDS) — PP Neue Montreal font, Papaya (#ec4e0b) brand primary
**Last updated:** 2026-04-22

---

## What This Project Is

A Claude Code system for generating complete, responsive, accessible product configurators from a simple requirement. The system lives in this repo and works in two modes:

1. **As a Claude Code Skill** — install once via `./install.sh`, then use `/imagineio:configurator` from any project on any machine
2. **As a standalone project** — clone the repo, open with `claude .`, and build configurators directly

The first configurator built with this system is the **Kitchen Configurator** (see below).

---

## Repo Structure

```
imagineio-configurator-system/
├── CLAUDE.md                          # Claude's project instructions (rules + doc pointers)
├── README.md                          # Public-facing overview and usage guide
├── CONTEXT.md                         # This file — full session context for Claude
├── install.sh                         # One-time skill installer: copies to ~/.claude/skills/imagineio/
│
├── .claude/
│   └── skills/
│       └── imagineio/
│           └── configurator/
│               └── SKILL.md           # Self-contained Claude Code skill (invoked via /imagineio:configurator)
│
├── docs/
│   ├── configurator-instructions.md   # Master 4-phase process (Phase 1–4, step by step)
│   ├── configurator-architecture.md   # Layout archetypes, component specs, responsive, CSS variables
│   ├── requirement-template.md        # How to parse requirements and extract product data
│   └── prism-token-structure.md       # Full Prism Design System token reference
│
├── assets/
│   ├── fonts/                         # PP Neue Montreal .otf files (6 weights)
│   └── logos/                         # imagine.io Mark.svg (copied from ~/.claude/logos/)
│
├── Kitchen Configurator Brief/        # Client brief folder for the first configurator
│   └── assets/
│       ├── 01 Layout/
│       ├── 02 Island/
│       ├── 03 Base Cabinet/
│       ├── 04 Wall Cabinet/
│       ├── 05 Tall Cabinet/
│       ├── 06 Door Style/
│       ├── 07 Door Handle/
│       ├── 08 Appliances/
│       ├── 09 Cabinet Finish/
│       ├── 10 Counter Top Finish/
│       └── 11 Hardware Finish/
│
└── output/
    └── kitchen-configurator.html      # First generated configurator (1899 lines, single file)
```

---

## The 4-Phase Generation System

Every configurator is built in strict order. No code until Phase 2 is confirmed.

| Phase | What Happens |
|-------|-------------|
| **1 — Understand** | Parse requirement, resolve design system (PDS or client), extract product data, ask all clarifying questions in one message |
| **2 — Plan** | Select layout archetype, map option groups to selector components, present style preferences for confirmation |
| **3 — Generate** | Write CSS tokens → layout → components → JS → responsive → accessibility |
| **4 — Validate** | Self-review against checklist (tokens, responsive, a11y, code quality), deliver with summary |

---

## Layout Archetypes

| Archetype | When to use |
|-----------|------------|
| **SBS-LR** | Default — preview left, options right |
| **SBS-RL** | Options are the focus, preview is secondary |
| **TC** | Three-column — extensive specs need dedicated space |
| **FW-BP** | Full-width preview + bottom panel — 1–3 options |
| **COMPACT** | Embedded widget |
| **VSTACK** | Mobile-only or mobile-first |
| **SPLIT** | 50/50 split — luxury/premium products |
| **WIZARD** | Step-by-step — 8+ sequential steps |
| **BUILD** | Modular assembly — user builds from parts |

The Kitchen Configurator uses a **SBS-RL variant** — floating left panel (options) over full-canvas preview.

---

## The `/imagineio:configurator` Skill

**File:** `.claude/skills/imagineio/configurator/SKILL.md`
**Invocation:** `/imagineio:configurator [product requirement]`
**Install:** `./install.sh` copies to `~/.claude/skills/imagineio/` — restart Claude Code after

The skill is self-contained: it includes the full 4-phase process, component specs, CSS variable block, and all rules. It works from any project directory, not just this repo.

**Adding more skills:** Create `.claude/skills/imagineio/your-skill-name/SKILL.md`, re-run `./install.sh`. Available as `/imagineio:your-skill-name`.

---

## GitHub Repo

**URL:** https://github.com/imaginevipin/imagineio-configurator-system
**Visibility:** Shared with the team (not public — team access)
**Git user:** imaginevipin
**Main branch:** `main`

### When to Push

Push to the repo whenever:
- A new configurator is generated and working in the browser
- The skill (`SKILL.md`) is updated or improved
- New docs are added or existing docs are revised
- A new product brief is added to the project
- Any structural change to the system (install script, CLAUDE.md, README, etc.)

### How to Push (from this project directory)

```bash
git add <specific files>
git commit -m "Short description of what changed"
git push origin main
```

Always use specific file adds, never `git add -A` blindly (avoids committing `.DS_Store`, temp files, etc.).

**Do not push:** Raw brief assets (client IP), `.DS_Store`, font `.otf` files (already gitignored if listed), or anything in `untitled folder/`.

### Commit History So Far

```
0cd1334  Add README with system overview and skill installation guide
c41631e  Add /imagineio:configurator skill and install script
cde82a9  Initial commit — Configurator Generation System
```

The Kitchen Configurator (`output/kitchen-configurator.html`) and `CONTEXT.md` have not yet been committed — they should be included in the next push.

---

## Kitchen Configurator — Current State

**File:** `output/kitchen-configurator.html` (1899 lines, single-file HTML/CSS/JS)
**Status:** Working in browser. Floating panel layout fully implemented with chat panel.

### UI Layout — Three Floating Panels Over Full Canvas

```
body
  div.configurator-body  (height:100vh, position:relative, display:flex, background:#eeecea)
    div.toolbar            (position:absolute; top:16px; right:16px — floating pill, z-index:60)
    aside.config-panel     (position:absolute; top:0; left:0; bottom:0; width:284px — z-index:50)
      div.panel-header       (logo + title, flex-shrink:0)
      div.config-panel-scroll (flex:1; min-height:0 — scrollable config options)
        section.option-section × 11
      div.chat-panel         (flex-shrink:0 — collapsible chat, pinned to bottom)
    main.preview-zone      (flex:1, fills full canvas width and height)
      div#kitchen-render     (SVG kitchen scene injected here)
    div.status-bar         (position:absolute; bottom:16px; right:16px — floating pill, z-index:60)
```

### Config Panel

**Header:** imagine.io Mark SVG (24×21px, inline, mask ID `mask1_panel`, orange `mix-blend-mode:color` overlay) + separator + "Kitchen Configurator" title (14px SemiBold).

**Option groups (top to bottom in scroll area):**

| Section | Select type | State key | Assets |
|---|---|---|---|
| Layout | Single | `state.layout` | `../Kitchen Configurator Brief/assets/01 Layout/` |
| Island | Single | `state.island` | `../Kitchen Configurator Brief/assets/02 Island/` |
| Base Cabinet | Multi | `state.baseCabinets[]` | `../Kitchen Configurator Brief/assets/03 Base Cabinet/` |
| Wall Cabinet | Multi | `state.wallCabinets[]` | `../Kitchen Configurator Brief/assets/04 Wall Cabinet/` |
| Tall Cabinet | Multi | `state.tallCabinets[]` | `../Kitchen Configurator Brief/assets/05 Tall Cabinet/` |
| Door Style | Single | `state.doorStyle` | `../Kitchen Configurator Brief/assets/06 Door Style/` |
| Door Handle | Single | `state.doorHandle` | `../Kitchen Configurator Brief/assets/07 Door Handle/` |
| Appliances | Multi | `state.appliances[]` | `../Kitchen Configurator Brief/assets/08 Appliances/` |
| Cabinet Finish | Single (material) | `state.cabinetFinish` | `../Kitchen Configurator Brief/assets/09 Cabinet Finish/` |
| Countertop Finish | Single (material) | `state.countertopFinish` | `../Kitchen Configurator Brief/assets/10 Counter Top Finish/` |
| Hardware Finish | `<select>` dropdown | `state.hardwareFinish` | — |

Single-select: `.is-selected` class + `2px` orange border on active swatch.
Multi-select: `.is-multi-selected` class + `.check-badge` (orange circle + checkmark, top-right corner).

**Chat panel (bottom of config panel):**
- Toggle: "✦ CHAT" + chevron → `toggleChat()` → adds `.is-open` to `.chat-panel`
- Expanded height: `300px` (flex column — messages scroll + input area pinned)
- Bot messages: `.chat-msg` (grey bg, full width)
- User messages: `.chat-msg.user` (subtle orange bg, right-aligned, `max-width:88%`)
- Input: `input.chat-input` (pill shape) + orange send button → `sendChat()`, Enter key also sends
- Default greeting pre-loaded in DOM

### Floating Toolbar (top-right pill)

`border-radius:12px; height:48px; box-shadow:0 2px 16px rgba(0,0,0,0.12)`

Button order (left → right): 2D/3D toggle | divider | Dimensions | Hide Walls | Hide Backsplash | divider | Reset Camera | divider | Undo | Redo | divider | Fullscreen | divider | Generate Assets CTA

All icons: `16×16px`, `viewBox="0 0 24 24"`, `stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`. Active state: `.is-active` class.

Tooltips: `data-tooltip="..."` on each button → CSS `::after`/`::before` pseudo-elements show label below on hover. Pure CSS, no JS.

### Floating Status Pill (bottom-right)

`border-radius:100px` (full pill); contains "LIVE STATUS" label + green dot (`--success-dot:#22c55e`) + "STABLE" text.

### Canvas & SVG Scene

Background: `#eeecea`. Four layout scenes rendered as inline SVG into `div#kitchen-render`:
- `renderUShape()` — default
- `renderLShape()`
- `renderGalley()`
- `renderSingleWall()`

Each scene respects: `state.showWalls`, `state.showBacksplash`, `state.showDimensions`, `state.cabinetFinish`, `state.countertopFinish`, `state.island`.

Helper functions: `drawBaseCab()`, `drawWallCab()`, `handleBar()`, `dimArrow()`, `dimLabel()`, `getHandleColor()`.

### JS State Object

```javascript
const state = {
  layout: 'u_shaped',         // 'u_shaped' | 'l_shaped' | 'galley' | 'single_wall'
  island: 'none',             // 'none' | 'standard' | 'large'
  baseCabinets: [],
  wallCabinets: [],
  tallCabinets: [],
  doorStyle: 'solid',
  doorHandle: 'none',
  appliances: [],
  cabinetFinish: 'walnut',
  countertopFinish: 'white_metallic_ct',
  hardwareFinish: 'brushed_nickel',
  viewMode: '2d',
  showDimensions: false,
  showWalls: true,
  showBacksplash: true
};
```

Undo/redo: `history[]` array of `JSON.stringify(state)` snapshots + `historyIndex` pointer. `syncUIToState()` syncs all button `.is-active`/`.is-selected` classes back to state after undo/redo.

### Known Bugs Fixed

- **Floating panel collapse** — when `.preview-zone` was `position:absolute`, the flex container had no in-flow children and collapsed to zero height. Fix: only `.config-panel` is `position:absolute`; `.preview-zone` stays `flex:1`.
- **SVG mask ID collision** — logo appears in two places. Panel header uses `mask1_panel`, avoiding conflicts with any future reuse.

### What Is Not Yet Done

- [ ] 3D view mode — button exists, state tracks it, but scene still renders 2D SVG
- [ ] Chat AI integration — `sendChat()` appends user message locally, no API call
- [ ] `generateAssets()` — shows `alert()` summary, not wired to export/API
- [ ] Mobile/responsive — config panel is fixed-width, no breakpoints for small screens
- [ ] Config panel hide/toggle — no way to collapse the left panel to see full canvas
- [ ] `output/kitchen-configurator.html` and `CONTEXT.md` not yet committed to GitHub
