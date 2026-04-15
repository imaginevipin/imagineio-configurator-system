# Configurator Generation System — imagine.io

## What This Project Does

This project generates product configurators. When given a requirement (in any format), follow the system defined in the documents below to build a complete, responsive, accessible configurator.

## Documents (Read in This Order)

1. **`docs/configurator-instructions.md`** — Master process. Follow Phase 1 through Phase 4 in strict order. This is your step-by-step playbook.
2. **`docs/configurator-architecture.md`** — Layout archetypes, component specs, responsive behavior, spacing, transitions, states, CSS variable block. This is your reference spec for WHAT to build.
3. **`docs/requirement-template.md`** — How to parse requirements, extract product data, resolve design systems (PDS vs client). This is your guide for understanding WHAT is being asked.
4. **`docs/prism-token-structure.md`** — Prism Design System token values. Use when in PDS mode (default).

## Rules

### Process Rules
- ALWAYS read `docs/configurator-instructions.md` first before doing anything
- ALWAYS complete Phase 1 (Receive and Understand) before writing any code
- ALWAYS resolve the design system (PDS or client) before generation
- ALWAYS ask clarifying questions in ONE message when required information is missing
- ALWAYS present style preferences (layout, swatch shape, option presentation, CTA style, selection indicator) before generating code, unless the user says to skip
- NEVER start coding until you have: product name, at least one option group with options, CTA label, design system resolved, and style preferences confirmed

### Design System Rules
- Default to PDS (Prism Design System) unless a client brand/website/screenshot is provided
- If client mode: extract visual values, present them for confirmation, wait for approval before generating
- The configurator's CSS variable NAMES stay the same in both modes. Only VALUES change.

### Code Rules
- ALL CSS must use semantic variables from the `:root` block — NEVER use raw hex values in component styles
- ALL spacing must use `var(--s-*)` scale variables — no magic numbers
- ALL z-index must use `var(--z-*)` scale — no arbitrary values
- Output single-file HTML + CSS + JS unless told otherwise
- Write mobile-first CSS with min-width breakpoints
- Every interactive element needs keyboard navigation and ARIA attributes

### Output Rules
- Save generated configurators to the `output/` folder
- Always provide a summary of what was built, which archetype was chosen and why, and any assumptions made
- Never invent product data (option names, prices, colors) — use placeholders and flag them if data is missing

## Quick Reference

| Need | Document | Section |
|------|----------|---------|
| How to process a requirement | configurator-instructions.md | Section 2-3 |
| Layout archetype selection | configurator-architecture.md | Section 2 + 9 |
| Component specs and states | configurator-architecture.md | Section 3 |
| Responsive behavior | configurator-architecture.md | Section 4 |
| CSS variable block | configurator-architecture.md | Section 5.6 |
| Design system extraction (client) | requirement-template.md | Section 3 |
| What to ask when info is missing | requirement-template.md | Section 4 + 6 |
| Code patterns and validation | configurator-instructions.md | Section 5 + 6 |
