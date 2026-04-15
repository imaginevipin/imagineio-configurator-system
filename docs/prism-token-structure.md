# Prism Design System — Token Structure

**Version:** 1.0 by imagine.io
**Figma:** https://www.figma.com/design/kiwttYrNajH3hQwrtGtrle/Prism-Design-System?node-id=1-3

---

## Overview

The Prism Design System uses a **three-tier variable architecture** in Figma:

```
Tier 1 — Brand (Primitives)
  Raw color values. Named by palette + shade.
  e.g. Papaya/500 = #ec4e0b

         ↓ referenced by

Tier 2 — Alias (Semantic)
  No raw values. Points to Brand tokens.
  e.g. surface/primary/default → Papaya/500

         ↓ consumed by

Tier 3 — Components
  Component properties bind to Alias tokens directly.
  e.g. Button background → surface/primary/default
```

**Why this matters:** When a Brand primitive changes (e.g. Papaya/500 gets a new hex), every Alias that references it updates automatically — and every component using that Alias updates too. One change, zero manual fixes.

---

## Collection 1: Brand (Primitives)

> Figma collection: **Brand**
> Purpose: Raw palette values. The single source of truth for all color values.
> Rule: Never use these directly in components. Always go through an Alias token.

### Papaya (Primary Brand)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Papaya/100` | `#fbdcce` | `--papaya-100` |
| `Papaya/200` | `#f7b89d` | `--papaya-200` |
| `Papaya/300` | `#f4956d` | `--papaya-300` |
| `Papaya/400` | `#f0713c` | `--papaya-400` |
| `Papaya/500` | `#ec4e0b` | `--papaya-500` ← primary brand color |
| `Papaya/600` | `#bd3e09` | `--papaya-600` |
| `Papaya/700` | `#8e2f07` | `--papaya-700` |
| `Papaya/800` | `#5e1f04` | `--papaya-800` |
| `Papaya/900` | `#2f1002` | `--papaya-900` |

### Green (Success)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Green/100` | `#ccf0db` | `--green-100` |
| `Green/200` | `#99e2b7` | `--green-200` |
| `Green/300` | `#66d394` | `--green-300` |
| `Green/400` | `#33c570` | `--green-400` |
| `Green/500` | `#00b64c` | `--green-500` |
| `Green/600` | `#00923d` | `--green-600` |
| `Green/700` | `#006d2e` | `--green-700` |
| `Green/800` | `#00491e` | `--green-800` |
| `Green/900` | `#00240f` | `--green-900` |

### Red (Error)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Red/100` | `#fbced7` | `--red-100` |
| `Red/200` | `#f79daf` | `--red-200` |
| `Red/300` | `#f46d88` | `--red-300` |
| `Red/400` | `#f03c60` | `--red-400` |
| `Red/500` | `#ec0b38` | `--red-500` |
| `Red/600` | `#bd092d` | `--red-600` |
| `Red/700` | `#8e0722` | `--red-700` |
| `Red/800` | `#5e0416` | `--red-800` |
| `Red/900` | `#2f020b` | `--red-900` |

### Blue (Information)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Blue/100` | `#ceeefb` | `--blue-100` |
| `Blue/200` | `#9ddcf7` | `--blue-200` |
| `Blue/300` | `#6dcbf4` | `--blue-300` |
| `Blue/400` | `#3cb9f0` | `--blue-400` |
| `Blue/500` | `#0ba8ec` | `--blue-500` |
| `Blue/600` | `#0986bd` | `--blue-600` |
| `Blue/700` | `#07658e` | `--blue-700` |
| `Blue/800` | `#04435e` | `--blue-800` |
| `Blue/900` | `#02222f` | `--blue-900` |

### Yellow (Warning)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Yellow/100` | `#fbf2ce` | `--yellow-100` |
| `Yellow/200` | `#f7e59d` | `--yellow-200` |
| `Yellow/300` | `#f4d96d` | `--yellow-300` |
| `Yellow/400` | `#f0cc3c` | `--yellow-400` |
| `Yellow/500` | `#ecbf0b` | `--yellow-500` |
| `Yellow/600` | `#bd9909` | `--yellow-600` |
| `Yellow/700` | `#8e7307` | `--yellow-700` |
| `Yellow/800` | `#5e4c04` | `--yellow-800` |
| `Yellow/900` | `#2f2602` | `--yellow-900` |

### Grey (Neutral)
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Grey/50`  | `#f6f6f6` | `--grey-50` |
| `Grey/100` | `#e5e5e5` | `--grey-100` |
| `Grey/200` | `#cccccc` | `--grey-200` |
| `Grey/300` | `#b2b2b2` | `--grey-300` |
| `Grey/400` | `#999999` | `--grey-400` |
| `Grey/500` | `#7f7f7f` | `--grey-500` |
| `Grey/600` | `#666666` | `--grey-600` |
| `Grey/700` | `#4d4d4d` | `--grey-700` |
| `Grey/800` | `#333333` | `--grey-800` |
| `Grey/900` | `#1a1a1a` | `--grey-900` |

### Foundations
| Variable | Value | CSS Property |
|----------|-------|--------------|
| `White` | `#ffffff` | `--white` |
| `Dark`  | `#141414` | `--dark` |

---

## Collection 2: Alias (Semantic Tokens)

> Figma collection: **Alias**
> Purpose: Semantic meaning mapped from Brand primitives. These are what components consume.
> Rule: Always prefer Alias tokens in UI code. Use Brand primitives only when no Alias fits.

### Naming Pattern
```
[layer] / [role] / [state]

layer  → text | surface | border | icons
role   → default | primary | error | information | warning | success | disabled | on-color
state  → default | default-hover | on-color | on-color-hover | default-subtle | default-subtle-hover | focus | disabled
```

### Text Tokens (`text/`)
| Figma Variable | Resolves To | CSS Property |
|----------------|-------------|--------------|
| `text/default/heading` | Grey/900 | `--text-default-heading` |
| `text/default/body` | Grey/700 | `--text-default-body` |
| `text/default/caption` | Grey/700 | `--text-default-caption` |
| `text/default/placeholder` | Grey/500 | `--text-default-placeholder` |
| `text/on-color/heading` | White | `--text-on-color-heading` |
| `text/on-color/body` | White | `--text-on-color-body` |
| `text/on-color/caption` | Grey/50 | `--text-on-color-caption` |
| `text/on-color/placeholder` | Grey/50 | `--text-on-color-placeholder` |
| `text/primary/default` | Papaya/500 | `--text-primary-default` |
| `text/primary/default-hover` | Papaya/600 | `--text-primary-default-hover` |
| `text/primary/on-color` | White | `--text-primary-on-color` |
| `text/error/default` | Red/500 | `--text-error-default` |
| `text/error/default-hover` | Red/600 | `--text-error-default-hover` |
| `text/error/on-color` | White | `--text-error-on-color` |
| `text/information/default` | Blue/500 | `--text-information-default` |
| `text/information/default-hover` | Blue/600 | `--text-information-default-hover` |
| `text/information/on-color` | White | `--text-information-on-color` |
| `text/warning/default` | Yellow/500 | `--text-warning-default` |
| `text/warning/default-hover` | Yellow/600 | `--text-warning-default-hover` |
| `text/warning/on-color` | White | `--text-warning-on-color` |
| `text/success/default` | Green/500 | `--text-success-default` |
| `text/success/default-hover` | Green/600 | `--text-success-default-hover` |
| `text/success/on-color` | White | `--text-success-on-color` |
| `text/disabled/default` | Grey/400 | `--text-disabled-default` |
| `text/disabled/on-color` | Grey/500 | `--text-disabled-on-color` |

### Surface Tokens (`surface/`)
| Figma Variable | Resolves To | CSS Property |
|----------------|-------------|--------------|
| `surface/default` | White | `--surface-default` |
| `surface/page` | White | `--surface-page` |
| `surface/page-secondary` | Grey/50 | `--surface-page-secondary` |
| `surface/default-secondary` | Grey/50 | `--surface-default-secondary` |
| `surface/primary/default` | Papaya/500 | `--surface-primary-default` |
| `surface/primary/default-hover` | Papaya/600 | `--surface-primary-default-hover` |
| `surface/primary/default-subtle` | Papaya/100 | `--surface-primary-default-subtle` |
| `surface/primary/default-subtle-hover` | Papaya/200 | `--surface-primary-default-subtle-hover` |
| `surface/error/default` | Red/500 | `--surface-error-default` |
| `surface/error/default-hover` | Red/600 | `--surface-error-default-hover` |
| `surface/error/default-subtle` | Red/100 | `--surface-error-default-subtle` |
| `surface/error/default-subtle-hover` | Red/200 | `--surface-error-default-subtle-hover` |
| `surface/information/default` | Blue/500 | `--surface-information-default` |
| `surface/information/default-hover` | Blue/600 | `--surface-information-default-hover` |
| `surface/information/default-subtle` | Blue/100 | `--surface-information-default-subtle` |
| `surface/information/default-subtle-hover` | Blue/200 | `--surface-information-default-subtle-hover` |
| `surface/warning/default` | Yellow/500 | `--surface-warning-default` |
| `surface/warning/default-hover` | Yellow/600 | `--surface-warning-default-hover` |
| `surface/warning/default-subtle` | Yellow/100 | `--surface-warning-default-subtle` |
| `surface/warning/default-subtle-hover` | Yellow/200 | `--surface-warning-default-subtle-hover` |
| `surface/success/default` | Green/500 | `--surface-success-default` |
| `surface/success/default-hover` | Green/600 | `--surface-success-default-hover` |
| `surface/success/default-subtle` | Green/100 | `--surface-success-default-subtle` |
| `surface/success/default-subtle-hover` | Green/200 | `--surface-success-default-subtle-hover` |
| `surface/disabled/disabled` | Grey/200 | `--surface-disabled-disabled` |

### Border Tokens (`border/`)
| Figma Variable | Resolves To | CSS Property |
|----------------|-------------|--------------|
| `border/default` | Grey/50 | `--border-default` |
| `border/default-secondary` | Grey/100 | `--border-default-secondary` |
| `border/primary/default` | Papaya/500 | `--border-primary-default` |
| `border/primary/default-hover` | Papaya/600 | `--border-primary-default-hover` |
| `border/primary/default-subtle` | Papaya/100 | `--border-primary-default-subtle` |
| `border/primary/default-subtle-hover` | Papaya/200 | `--border-primary-default-subtle-hover` |
| `border/primary/focus` | Papaya/500 | `--border-primary-focus` |
| `border/error/default` | Red/500 | `--border-error-default` |
| `border/error/default-hover` | Red/600 | `--border-error-default-hover` |
| `border/error/default-subtle` | Red/100 | `--border-error-default-subtle` |
| `border/error/default-subtle-hover` | Red/200 | `--border-error-default-subtle-hover` |
| `border/error/focus` | Red/500 | `--border-error-focus` |
| `border/information/default` | Blue/500 | `--border-information-default` |
| `border/information/default-hover` | Blue/600 | `--border-information-default-hover` |
| `border/information/default-subtle` | Blue/100 | `--border-information-default-subtle` |
| `border/information/default-subtle-hover` | Blue/200 | `--border-information-default-subtle-hover` |
| `border/information/focus` | Blue/500 | `--border-information-focus` |
| `border/warning/default` | Yellow/500 | `--border-warning-default` |
| `border/warning/default-hover` | Yellow/600 | `--border-warning-default-hover` |
| `border/warning/default-subtle` | Yellow/100 | `--border-warning-default-subtle` |
| `border/warning/default-subtle-hover` | Yellow/200 | `--border-warning-default-subtle-hover` |
| `border/warning/focus` | Yellow/500 | `--border-warning-focus` |
| `border/success/default` | Green/500 | `--border-success-default` |
| `border/success/default-hover` | Green/600 | `--border-success-default-hover` |
| `border/success/default-subtle` | Green/100 | `--border-success-default-subtle` |
| `border/success/default-subtle-hover` | Green/200 | `--border-success-default-subtle-hover` |
| `border/success/focus` | Green/500 | `--border-success-focus` |
| `border/disabled/disabled` | Grey/200 | `--border-disabled-disabled` |

### Icon Tokens (`icons/`)
| Figma Variable | Resolves To | CSS Property |
|----------------|-------------|--------------|
| `icons/primary/default` | Papaya/500 | `--icons-primary-default` |
| `icons/primary/default-hover` | Papaya/600 | `--icons-primary-default-hover` |
| `icons/primary/on-color` | White | `--icons-primary-on-color` |
| `icons/primary/on-color-hover` | White | `--icons-primary-on-color-hover` |
| `icons/error/default` | Red/500 | `--icons-error-default` |
| `icons/error/default-hover` | Red/600 | `--icons-error-default-hover` |
| `icons/error/on-color` | White | `--icons-error-on-color` |
| `icons/information/default` | Blue/500 | `--icons-information-default` |
| `icons/information/default-hover` | Blue/600 | `--icons-information-default-hover` |
| `icons/information/on-color` | White | `--icons-information-on-color` |
| `icons/warning/default` | Yellow/500 | `--icons-warning-default` |
| `icons/warning/default-hover` | Yellow/600 | `--icons-warning-default-hover` |
| `icons/warning/on-color` | White | `--icons-warning-on-color` |
| `icons/success/default` | Green/500 | `--icons-success-default` |
| `icons/success/default-hover` | Green/600 | `--icons-success-default-hover` |
| `icons/success/on-color` | White | `--icons-success-on-color` |
| `icons/disabled/default` | Grey/400 | `--icons-disabled-default` |
| `icons/disabled/on-color` | Grey/500 | `--icons-disabled-on-color` |

---

## Collection 3: Typography

> Figma collection: **Font**
> Purpose: Font family, weights, and the full type scale.
> Structure: Each style has three variables — `text size`, `line height`, `paragraph spacing`. Composite tokens combine these into a single font definition used by components.

### Font Family & Weights
| Variable | Value |
|----------|-------|
| `Font/Primary` | `PP Neue Montreal` |
| `Font/PP Neue Montreal/Weight/Light` | Light (300) |
| `Font/PP Neue Montreal/Weight/Regular` | Regular (400) |
| `Font/PP Neue Montreal/Weight/Book` | Book (450) |
| `Font/PP Neue Montreal/Weight/Medium` | Medium (500) |
| `Font/PP Neue Montreal/Weight/SemiBold` | SemiBold (600) |
| `Font/PP Neue Montreal/Weight/Bold` | Bold (700) |

### Responsive Modes

The Font variable collection has **three modes**: Desktop (1440px), Tablet (1024px), Mobile (440px).
Only H1–H4 change across breakpoints. H5, H6, and all Copy styles are fixed across all screen sizes.

### Heading Scale Variables

| Figma Variable Group | Desktop | Tablet | Mobile | LH Desktop | LH Tablet | LH Mobile | Letter Spacing |
|----------------------|---------|--------|--------|-----------|-----------|-----------|----------------|
| `Font/Heading/H1/*` | 60px | 60px | 48px | 72px | 72px | 56px | -2px |
| `Font/Heading/H2/*` | 48px | 48px | 40px | 56px | 56px | 48px | -2px |
| `Font/Heading/H3/*` | 40px | 40px | 32px | 48px | 48px | 40px | -1px |
| `Font/Heading/H4/*` | 32px | 32px | 28px | 40px | 40px | 32px | -1px |
| `Font/Heading/H5/*` | 24px | 24px | 24px | 28px | 28px | 28px | -0.12px |
| `Font/Heading/H6/*` | 20px | 20px | 20px | 24px | 24px | 24px | 0 |

### Body & Copy Scale Variables

All copy styles are consistent across all breakpoints — no responsive changes.

| Figma Variable Group | Size (all) | Line Height (all) | Letter Spacing |
|----------------------|------------|-------------------|----------------|
| `Font/Copy/body-lg/*` | 20px | 24px | 0 |
| `Font/Copy/body/*`    | 16px | 20px | 0 |
| `Font/Copy/small/*`   | 14px | 16px | 1px |
| `Font/Copy/caption/*` | 12px | 16px | 2px |

### Composite Font Tokens (used by components)

Each heading and copy style is available in multiple weights. Pattern: `[style]/[Weight]`

| Token | Size | Weight | LH | LS |
|-------|------|--------|----|----|
| `H1/Regular` | 60px | 400 | 72px | -2px |
| `H1/Medium` | 60px | 500 | 72px | -2px |
| `H1/SemiBold` | 60px | 600 | 72px | -2px |
| `H1/Bold` | 60px | 700 | 72px | -2px |
| `H2/Regular` | 48px | 400 | 56px | -2px |
| `H2/Medium` | 48px | 500 | 56px | -2px |
| `H2/SemiBold` | 48px | 600 | 56px | -2px |
| `H2/Bold` | 48px | 700 | 56px | -2px |
| `H3/Regular` | 40px | 400 | 48px | -1px |
| `H3/Medium` | 40px | 500 | 48px | -1px |
| `H3/SemiBold` | 40px | 600 | 48px | -1px |
| `H3/Bold` | 40px | 700 | 48px | -1px |
| `H4/Regular` | 32px | 400 | 40px | -1px |
| `H4/Medium` | 32px | 500 | 40px | -1px |
| `H4/SemiBold` | 32px | 600 | 40px | -1px |
| `H4/Bold` | 32px | 700 | 40px | -1px |
| `H5/Regular` | 24px | 400 | 28px | -0.12px |
| `H5/Medium` | 24px | 500 | 28px | -0.12px |
| `H5/SemiBold` | 24px | 600 | 28px | -0.12px |
| `H5/Bold` | 24px | 700 | 28px | -0.12px |
| `H6/Medium` | 20px | 500 | 24px | — |
| `H6/SemiBold` | 20px | 600 | 24px | — |
| `H6/Bold` | 20px | 700 | 24px | — |
| `body-lg/Regular` | 20px | 400 | 24px | — |
| `body-lg/Medium` | 20px | 500 | 24px | — |
| `body-lg/SemiBold` | 20px | 600 | 24px | — |
| `body-lg/Bold` | 20px | 700 | 24px | — |
| `body/Regular` | 16px | 400 | 20px | — |
| `body/Medium` | 16px | 500 | 20px | — |
| `body/SemiBold` | 16px | 600 | 20px | — |
| `body/Bold` | 16px | 700 | 20px | — |
| `small/Regular` | 14px | 400 | 16px | 1px |
| `small/Medium` | 14px | 500 | 16px | 1px |
| `small/SemiBold` | 14px | 600 | 16px | 1px |
| `small/Bold` | 14px | 700 | 16px | 1px |
| `caption/Regular` | 12px | 400 | 16px | 2px |
| `caption/Medium` | 12px | 500 | 16px | 2px |
| `caption/SemiBold` | 12px | 600 | 16px | 2px |
| `caption/Bold` | 12px | 700 | 16px | 2px |

---

## Collection 4: Scale (Spacing)

> Figma collection: **Scale**
> Purpose: Spacing values used for padding, margin, gap.
> CSS convention: `Scale/100` → `--s-100`

| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Scale/100` | 4px | `--s-100` |
| `Scale/200` | 8px | `--s-200` |
| `Scale/300` | 12px | `--s-300` |
| `Scale/400` | 16px | `--s-400` |
| `Scale/500` | 20px | `--s-500` |
| `Scale/600` | 24px | `--s-600` |
| `Scale/700` | 28px | `--s-700` |
| `Scale/800` | 32px | `--s-800` |
| `Scale/900` | 36px | `--s-900` |
| `Scale/1000` | 40px | `--s-1000` |
| `Scale/1100` | 48px | `--s-1100` |
| `Scale/1200` | 56px | `--s-1200` |
| `Scale/1300` | 64px | `--s-1300` |
| `Scale/1400` | 72px | `--s-1400` |

---

## Collection 5: Border

> Figma collection: **Border**
> Purpose: Border width and border radius values.

| Variable | Value | CSS Property |
|----------|-------|--------------|
| `Border Width/25` | 1px | `--bw-25` |
| `Border Width/100` | 4px | `--bw-100` |
| `Border Radius/100` | 4px | `--br-100` |
| `Border Radius/200` | 8px | `--br-200` |

---

## Variable Connection Map

```
Brand Collection          Alias Collection           Components
─────────────────         ────────────────────────   ─────────────────────
Papaya/500 (#ec4e0b) ──→ surface/primary/default  ──→ Button background
                    ──→ text/primary/default      ──→ Link color
                    ──→ border/primary/default    ──→ Input focus ring
                    ──→ icons/primary/default     ──→ Icon fill

Papaya/600 (#bd3e09) ──→ surface/primary/default-hover
                    ──→ text/primary/default-hover

Grey/900 (#1a1a1a)  ──→ text/default/heading     ──→ Page headings
Grey/700 (#4d4d4d)  ──→ text/default/body        ──→ Body text
Grey/50  (#f6f6f6)  ──→ surface/page-secondary   ──→ Page background
                    ──→ border/default            ──→ Subtle dividers
```

---

## CSS Naming Convention

Figma variable paths use `/` as separator. CSS properties use `-`.

| Figma Path | CSS Custom Property |
|------------|---------------------|
| `Papaya/500` | `--papaya-500` |
| `Scale/400` | `--s-400` |
| `Border Radius/100` | `--br-100` |
| `Border Width/25` | `--bw-25` |
| `text/default/heading` | `--text-default-heading` |
| `surface/primary/default` | `--surface-primary-default` |
| `border/primary/focus` | `--border-primary-focus` |
| `icons/primary/default` | `--icons-primary-default` |

---

## Notes

1. **Responsive modes** — Font variables have 3 modes: Desktop (1440px), Tablet (1024px), Mobile (440px). H1–H4 scale down on mobile. Desktop and Tablet share the same values. H5, H6, and all Copy styles are identical across all breakpoints.
2. **Alpha/Overlay tokens** — Used in some components (e.g. glow effects, overlays) but not in the Alias collection. Likely defined locally per component rather than as a global collection.
