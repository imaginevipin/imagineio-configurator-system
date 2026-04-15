# imagine.io Configurator Generation System

A Claude Code system for building complete, responsive, accessible product configurators from a simple requirement. Describe your product — Claude handles the rest.

---

## What It Does

Give Claude a product description and it will build a full configurator UI: layout selection, option selectors (swatches, pills, dropdowns), dynamic pricing, image swapping, mobile responsiveness, and keyboard accessibility — all in a single HTML file using the Prism Design System.

**Supports:**
- PDS (Prism Design System) — default for all imagine.io work
- Client brand mode — extract visual values from a screenshot, Figma file, or brand doc
- Output formats: single-file HTML (default), React, or Vue

---

## How to Use

### Option A — As a Claude Code Skill (Recommended)

Install the skill once, then use `/imagineio:configurator` from **any project**.

#### Install via Terminal

```bash
git clone https://github.com/imaginevipin/imagineio-configurator-system.git
cd imagineio-configurator-system
./install.sh
```

Restart Claude Code. The skill is now available everywhere.

#### Install via Claude Code UI

1. Download or clone this repo
2. Open Claude Code desktop app
3. Go to **Customize → Skills → + → Upload a skill**
4. Select the file: `.claude/skills/imagineio/configurator/SKILL.md`

> **Note:** The UI upload method registers the skill as `/configurator`. The terminal install preserves the `/imagineio:configurator` namespace, which is recommended as more imagine.io skills are added.

#### Using the Skill

From any project, open Claude Code and run:

```
/imagineio:configurator build a dining chair configurator with 3 fabrics and 5 leg finishes
```

Or just invoke it and describe your product interactively:

```
/imagineio:configurator
```

Claude will ask the right questions, confirm style preferences, then generate the configurator.

---

### Option B — As a Standalone Project

Clone the repo and use it directly in Claude Code. The `CLAUDE.md` file instructs Claude to follow the full generation system whenever you ask it to build a configurator.

```bash
git clone https://github.com/imaginevipin/imagineio-configurator-system.git
cd imagineio-configurator-system
claude .
```

Then just ask:

```
Build a configurator for a modular sofa with 4 fabric options and 3 leg finishes
```

Generated configurators are saved to the `output/` folder.

---

## The 4-Phase Process

Every configurator is built in strict order:

| Phase | What Happens |
|-------|-------------|
| **1 — Understand** | Parse requirement, resolve design system (PDS or client), extract product data, ask all clarifying questions in one message |
| **2 — Plan** | Select layout archetype, map option groups to selector components, present style preferences for confirmation |
| **3 — Generate** | Write CSS tokens → layout → components → JavaScript → responsive → accessibility |
| **4 — Validate** | Self-review against checklist (tokens, responsive, accessibility, code quality), deliver with summary |

---

## Layout Archetypes

| Archetype | When to use |
|-----------|------------|
| **SBS-LR** | Default — preview left, options right. Any product with 2–8 option groups |
| **SBS-RL** | Options are the focus, preview is secondary |
| **TC** | Three-column — extensive product specs need dedicated space |
| **FW-BP** | Full-width preview + bottom panel — 1–3 options, visual impact priority |
| **COMPACT** | Embedded widget — fits inside a larger page |
| **VSTACK** | Mobile-only or mobile-first layout |
| **SPLIT** | 50/50 split — luxury or premium products |
| **WIZARD** | Step-by-step — 8+ sequential configuration steps |
| **BUILD** | Modular assembly — user builds from component pieces |

---

## Design System

**PDS mode (default):** Uses Prism Design System tokens — Papaya brand color, PP Neue Montreal font, full semantic token set.

**Client mode:** Provide a screenshot, Figma link, or brand doc. Claude extracts the primary color, backgrounds, typography, border style, and derives a complete token set. You confirm the values before any code is written.

In both modes, the CSS variable names are identical — only the values change.

---

## Repository Structure

```
imagineio-configurator-system/
├── CLAUDE.md                          # Project instructions for Claude
├── README.md                          # This file
├── install.sh                         # One-time skill installer for your machine
│
├── .claude/
│   └── skills/
│       └── imagineio/
│           └── configurator/
│               └── SKILL.md           # Self-contained Claude Code skill
│
└── docs/
    ├── configurator-instructions.md   # Master process (Phase 1–4)
    ├── configurator-architecture.md   # Layout archetypes, components, specs
    ├── requirement-template.md        # How to parse requirements
    └── prism-token-structure.md       # Prism Design System token reference
```

---

## Adding More imagine.io Skills

This repo is structured to hold all imagine.io Claude Code skills under `.claude/skills/imagineio/`. To add a new skill:

1. Create a folder: `.claude/skills/imagineio/your-skill-name/`
2. Add a `SKILL.md` file with the required frontmatter and instructions
3. Run `./install.sh` to update your local installation
4. Team members pull the repo and re-run `./install.sh`

New skill becomes available as `/imagineio:your-skill-name`.
