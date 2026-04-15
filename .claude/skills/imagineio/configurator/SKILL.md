---
name: configurator
description: Build a complete, responsive, accessible product configurator from a requirement. Follows the imagine.io 4-phase Configurator Generation System — understand, plan, generate, validate. Supports PDS (Prism Design System) and client brand modes. Outputs single-file HTML/CSS/JS by default.
when_to_use: "When asked to build a product configurator, variant picker, or customization UI for any product — chairs, apparel, vehicles, furniture, electronics, etc. Works from any project directory."
user-invocable: true
allowed-tools: Read Grep Glob Bash Write
argument-hint: "[product requirement or description]"
---

# imagine.io Configurator Builder

You are building a product configurator following the imagine.io Configurator Generation System.

**CRITICAL:** Follow all 4 phases in strict order. Do not write a single line of code until Phase 1 and Phase 2 are complete and the user has confirmed their preferences.

---

## Phase 1 — Receive and Understand

### Step 1: Read Everything First

The requirement arrives in any format: paragraph, bullet list, Figma link, screenshot, spreadsheet, or a casual message like "build a chair configurator with 3 fabrics and 5 colors." Read it fully before doing anything.

### Step 2: Resolve the Design System (FIRST — before extracting product data)

| Signal | Mode |
|--------|------|
| No brand/client mentioned | **PDS** (Prism Design System) |
| "Use our design system" / "PDS" / "Prism" / "imagine.io style" | **PDS** |
| Internal demo or showcase | **PDS** |
| Client name / "match their site" / screenshot / Figma link provided | **Client mode** — extract visual values |
| Vague aesthetic ("clean, modern") | Ask: do they have a reference site, or use PDS? |

**If PDS mode:** Use the CSS variable block in this file. No confirmation needed.

**If Client mode:**
1. Extract visual values from whatever reference was provided (screenshot → observe; Figma → use tools; URL → ask for screenshot or fetch)
2. From one primary color derive the full primary scale (hover = 10–15% darker; subtle = HSL lightness 93–96%; subtle-hover = lightness 87–91%)
3. Populate the full flat variable block (Section: CSS Variables below)
4. Present extracted values to the user and wait for confirmation BEFORE generating any code

### Step 3: Extract Product Data

**Critical (must have — ask if missing):**
- Product name
- At least one option group with options (e.g., Color: Red, Blue, Green)
- CTA label/action ("Add to Cart", "Get Quote", "Configure")

**Important (infer or ask if ambiguous):**
- Option type per group: color (hex values) → color swatch; texture images → image swatch; text values → text pill; 8+ items → dropdown
- Pricing: base price, per-option modifiers
- Product images or "use placeholders"
- Layout preference (if stated)

**Nice to have (use defaults if absent):**
- Description, SKU, rating, trust badges — omit if not provided

### Step 4: Identify Gaps and Ask All Questions in ONE Message

Group questions as: Product Data → Design → Behavior. Offer defaults the user can accept. If the requirement is very complete, state your plan and proceed without unnecessary questions.

**Never ask about:** spacing, breakpoints, component sizing, z-index, transition timing — these are handled by spec.

---

## Phase 2 — Plan

### Step 5: Select Layout Archetype

Work through this decision tree in order:

```
1. Check for explicit constraints first:
   ├── "embed" / "widget" / "PDP" → COMPACT
   ├── "mobile only" / "mobile app" → VSTACK
   ├── Modular assembly product → BUILD
   ├── "luxury" / "immersive" / "premium" → SPLIT
   ├── "step-by-step" / "wizard" / 8+ sequential categories → WIZARD
   └── None → continue

2. Count option groups:
   ├── 1–3 groups:
   │   ├── Big visual is priority → FW-BP (full-width preview + bottom panel)
   │   └── Standard → SBS-LR (default)
   ├── 3–6 groups:
   │   ├── Extensive product specs/info → TC (three-column)
   │   ├── Config is the star, preview secondary → SBS-RL
   │   └── Standard → SBS-LR (default)
   ├── 6–10 groups:
   │   ├── Independent/parallel options → SBS-LR with accordion
   │   └── Sequential/dependent options → WIZARD
   └── 10+ groups → WIZARD

3. Per option group, select selector:
   ├── Hex color values → Color Swatch (circle or rounded square)
   ├── Material/texture images → Image Swatch (rectangular)
   ├── Size/dimension text → Text Pill
   ├── Product variants with photos → Card Selector
   ├── 8+ options → Dropdown
   ├── Continuous numeric → Slider
   └── Integer quantity → Stepper

4. Swatch sizing:
   ├── 2–4 options → L or XL swatches
   ├── 5–8 options → M swatches
   ├── 9–15 options → S swatches
   └── 16+ → XS or switch to Dropdown

5. Option group presentation:
   ├── 1–4 groups → all visible, stacked
   ├── 5–7 groups → accordion (first group open)
   └── 8+ groups → accordion all collapsed, or WIZARD
```

### Step 6: Present Style Preferences to the User

Before writing code, present this concise set of choices. The user can approve all with one message or adjust specific items.

```
Before I build, a few quick style choices:

1. LAYOUT: [recommended archetype] — [one-line reason]
   Other options that could work: [alternatives]

2. OPTION SELECTORS:
   [Group name]: [recommended component] — [reason]
   (list each group where there's a genuine choice)

3. OPTION GROUP PRESENTATION: [all visible / accordion] — [reason]

4. SWATCH SHAPE (if color options): Circular or rounded square?

5. CTA STYLE: Price inside button ("Add to Cart — $450") or price separate above?

6. SELECTION INDICATOR: Border highlight + checkmark badge, or border only?

Go with these, or want to tweak anything?
```

**Skip this step if:** requirement already specifies all styling, or user previously said "just build it."

### Step 7: Confirm Before Generating

You must have ALL of these before writing code:
- [ ] Product name
- [ ] At least one option group with defined options
- [ ] CTA label
- [ ] Design system resolved (PDS confirmed, or client values confirmed by user)
- [ ] Style preferences confirmed (layout, selectors, presentation)

---

## Phase 3 — Generate

### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Product Name] Configurator</title>
  <style>
    /* 1. DESIGN SYSTEM TOKENS — :root block (see CSS Variables section) */
    /* 2. RESET AND BASE */
    /* 3. LAYOUT — configurator container, visual-zone, control-zone */
    /* 4. VISUAL ZONE — preview-area, thumbnail-strip, action-icons */
    /* 5. CONTROL ZONE — product-title-block, option-groups */
    /* 6. SELECTION COMPONENTS — swatches, pills, cards, dropdowns */
    /* 7. CTA AND COMMERCE — buttons, price-display */
    /* 8. STATES — loading, error, disabled */
    /* 9. RESPONSIVE — mobile-first, min-width breakpoints */
    /* 10. ACCESSIBILITY — focus styles, reduced motion */
  </style>
</head>
<body>
  <div class="configurator configurator--[archetype]" role="region" aria-label="[Product Name] Configurator"
       data-base-price="[price]" data-currency="USD">

    <div class="visual-zone">
      <div class="preview-area">
        <img class="preview-image" src="[url or placeholder]" alt="[Product Name]" />
        <div class="action-icons">
          <button class="action-icon" aria-label="Fullscreen"><!-- icon --></button>
        </div>
      </div>
      <div class="thumbnail-strip" role="listbox" aria-label="Product views">
        <!-- thumbnails if multiple views -->
      </div>
    </div>

    <div class="control-zone">
      <div class="product-title-block">
        <span class="product-category">[Category]</span>
        <h1 class="product-name">[Product Name]</h1>
        <p class="product-description">[Description]</p>
        <span class="product-price">$[base price]</span>
      </div>

      <div class="option-groups">
        <!-- Each option group: -->
        <div class="option-group" data-group="[group-id]">
          <div class="option-group-header">
            <span class="option-group-label">[LABEL]</span>
            <span class="option-group-value">[Current Selection]</span>
          </div>
          <div class="option-group-content" role="radiogroup" aria-label="Select [group]">
            <!-- Selection components here -->
          </div>
        </div>
      </div>

      <div class="cta-section">
        <div class="price-display">
          <span class="price-label">Total:</span>
          <span class="price-value">$[price]</span>
        </div>
        <button class="cta-primary">[CTA Label]</button>
      </div>
    </div>

  </div>
  <script>/* state, handlers, price calc, image swap, keyboard nav */</script>
</body>
</html>
```

### CSS Token Rules (Non-Negotiable)

- **NEVER** use raw hex values in component styles. Only in `:root`.
- **NEVER** use arbitrary px values for spacing. Always `var(--s-*)`.
- **NEVER** hardcode font families. Always `var(--font-primary)`.
- **NEVER** use arbitrary z-index values. Always `var(--z-*)`.

```css
/* WRONG */  .btn { background: #ec4e0b; padding: 12px 16px; }
/* RIGHT */  .btn { background: var(--surface-primary-default); padding: var(--s-300) var(--s-400); }
```

### CSS Reset

```css
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: var(--font-primary); color: var(--text-default-body); background: var(--surface-page); -webkit-font-smoothing: antialiased; }
img { display: block; max-width: 100%; height: auto; }
button { cursor: pointer; border: none; background: none; font: inherit; color: inherit; }
```

### Responsive Structure (Mobile-First)

```css
/* Base: mobile */
.configurator { display: flex; flex-direction: column; padding: var(--s-300); }

/* Tablet: 768px+ */
@media (min-width: 768px) { .configurator { flex-direction: row; padding: var(--s-400); } }

/* Desktop: 1024px+ */
@media (min-width: 1024px) { .configurator { padding: var(--s-600); max-width: 1440px; margin: 0 auto; } }
```

### Hover State Gating

```css
@media (hover: hover) { .swatch:hover { border-color: var(--border-primary-default-subtle-hover); } }
.swatch:active { transform: scale(0.96); }
```

### Focus Styles

```css
.swatch:focus-visible, .pill:focus-visible, .cta-primary:focus-visible {
  outline: 2px solid var(--border-primary-focus); outline-offset: 2px;
}
```

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { transition-duration: 0.01ms !important; animation-duration: 0.01ms !important; }
}
```

### Data Attributes Convention

```html
<!-- Selectable option -->
<button class="color-swatch" role="radio"
  data-group="color" data-option="charcoal-grey"
  data-label="Charcoal Grey" data-price-modifier="0"
  aria-selected="false" tabindex="0">
```

### JavaScript Patterns

**State object:**
```javascript
const state = {
  selections: {},        // { groupId: optionId }
  price: { base: 0, total: 0 },
  currentView: 'front',
  ui: { openAccordion: null, isMobile: false }
};
```

**Selection handler:**
```javascript
function handleSelect(groupId, optionId) {
  state.selections[groupId] = optionId;
  const group = document.querySelector(`[data-group="${groupId}"]`);
  group.querySelectorAll('[data-option]').forEach(o => {
    o.classList.remove('is-selected'); o.setAttribute('aria-selected', 'false');
  });
  const sel = group.querySelector(`[data-option="${optionId}"]`);
  sel.classList.add('is-selected'); sel.setAttribute('aria-selected', 'true');
  const header = group.querySelector('.option-group-value');
  if (header) header.textContent = sel.dataset.label;
  updatePrice(); updatePreviewImage();
}
```

**Price calculation:**
```javascript
function updatePrice() {
  let total = state.price.base;
  Object.entries(state.selections).forEach(([gid, oid]) => {
    const opt = document.querySelector(`[data-group="${gid}"] [data-option="${oid}"]`);
    if (opt?.dataset.priceModifier) total += parseFloat(opt.dataset.priceModifier);
  });
  document.querySelectorAll('.price-value').forEach(el => {
    el.textContent = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(total);
  });
}
```

**Image crossfade:**
```javascript
function updatePreviewImage() {
  const img = document.querySelector('.preview-image');
  if (!img) return;
  const newSrc = getImageForSelections(state.selections);
  if (!newSrc || newSrc === img.src) return;
  img.style.opacity = '0';
  img.addEventListener('transitionend', function h() {
    img.src = newSrc; img.onload = () => { img.style.opacity = '1'; };
    img.removeEventListener('transitionend', h);
  }, { once: true });
}
```

**Keyboard navigation:**
```javascript
function handleKeyboardNav(e, groupId) {
  const opts = [...document.querySelectorAll(`[data-group="${groupId}"] [data-option]`)];
  const cur = opts.findIndex(o => o.classList.contains('is-selected'));
  let next;
  if (e.key === 'ArrowRight' || e.key === 'ArrowDown') { e.preventDefault(); next = (cur + 1) % opts.length; }
  else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') { e.preventDefault(); next = (cur - 1 + opts.length) % opts.length; }
  else if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); handleSelect(groupId, opts[cur].dataset.option); return; }
  else return;
  opts[next].focus(); handleSelect(groupId, opts[next].dataset.option);
}
```

### Class Naming

```
.configurator               — Root container
.configurator--sbs-lr       — Archetype modifier (sbs-lr, sbs-rl, tc, fw-bp, compact, vstack, split, wizard)
.visual-zone                — Preview wrapper
.preview-area               — Image container
.preview-image              — The product image
.thumbnail-strip            — Thumbnail container
.thumbnail.is-active        — Active thumbnail
.control-zone               — Config panel wrapper
.product-title-block        — Product info section
.option-group               — Single option category
.option-group-header        — Label + current value row
.option-group-content       — Options container
.color-swatch               — Circular/square color swatch
.image-swatch               — Rectangular material swatch
.text-pill                  — Text option pill
.card-selector              — Card option
.dropdown                   — Dropdown wrapper
.cta-section                — CTA area
.cta-primary                — Primary action button
.price-display              — Price section
.price-value                — Price number

State classes:
.is-selected  .is-active  .is-open  .is-disabled  .is-loading  .has-error
```

### Output

Save to `output/[product-name]-configurator.html` (create the `output/` folder if it doesn't exist).

---

## Phase 4 — Validate and Deliver

### Self-Review Checklist (verify before presenting)

**Design System**
- [ ] Zero raw hex values in component styles (only in `:root`)
- [ ] All spacing uses `var(--s-*)`
- [ ] Font uses `var(--font-primary)`
- [ ] Z-index uses `var(--z-*)`

**Layout**
- [ ] Correct archetype structure (Visual Zone + Control Zone)
- [ ] CTA at bottom of Control Zone (sticky on mobile)

**Components**
- [ ] Every option group shows current selection label
- [ ] All 4 states defined for each selector: default, hover, selected, disabled
- [ ] A default option is selected on load for every group

**Interactivity**
- [ ] Clicking an option updates visual state
- [ ] Option group header value text updates on selection
- [ ] Price recalculates on every change (if pricing enabled)
- [ ] Preview image crossfades on selection (if images exist)

**Responsive**
- [ ] Base CSS is mobile (column layout)
- [ ] 768px breakpoint switches to side-by-side where applicable
- [ ] 1024px breakpoint applies full desktop proportions
- [ ] CTA is sticky on mobile
- [ ] Touch targets ≥ 44px

**Accessibility**
- [ ] `role="radiogroup"` on option group containers
- [ ] `role="radio"` + `aria-selected` on each option
- [ ] `aria-label` on all icon buttons
- [ ] Arrow key navigation works
- [ ] `focus-visible` ring on all interactive elements
- [ ] `prefers-reduced-motion` included

**Code Quality**
- [ ] No inline styles
- [ ] No `!important` (except reduced-motion)
- [ ] `const`/`let` only, no `var`
- [ ] No `console.log` statements

### Delivery Summary Format

```
Here is the [Product Name] configurator.

**Layout:** [Archetype name] — [why chosen]
**Design System:** [PDS / Client name]
**Option Groups:** [count] — [list them]
**Pricing:** [dynamic / static / none]
**Responsive:** Desktop, Tablet, Mobile

**Assumptions made:**
- [Any defaults or placeholders used]
- [Any inferences not in the requirement]

Open the file in a browser to test. Let me know if you want adjustments.
```

---

## Handling Revisions

- **Visual changes** (colors, sizes): update `:root` variables or specific component styles only
- **Adding/removing options**: update HTML + JS for that group only; verify price calc still works
- **Layout change**: explain the impact before restructuring
- **Design system swap**: replace the `:root` block; nothing else should change if variables were used correctly

---

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Starting code before understanding requirement | Complete Phase 1 fully first |
| Inventing option names, prices, colors | Use placeholders, flag them with `<!-- PLACEHOLDER -->` |
| Writing `#ec4e0b` in component styles | Only hex in `:root`; always `var()` elsewhere |
| Building desktop-only | Mobile-first CSS, always include 768px + 1024px breakpoints |
| Using `<div onclick>` instead of `<button>` | Use semantic elements + ARIA roles |
| CTA scrolling off screen | Sticky on mobile; sticky Visual Zone on desktop |
| Multiple options selected at once | Always deselect all in group before selecting new one |
| Price not updating | Call `updatePrice()` from every `handleSelect()` |
| Image swap white flash | Use crossfade pattern — keep old image until new one has loaded |

---

## CSS Variables — PDS Default Values

Use these when in PDS mode. In client mode, replace values but keep all variable names.

```css
:root {
  /* PRIMARY */
  --surface-primary-default: #ec4e0b;
  --surface-primary-default-hover: #bd3e09;
  --surface-primary-default-subtle: #fbdcce;
  --surface-primary-default-subtle-hover: #f7b89d;
  --text-primary-default: #ec4e0b;
  --text-primary-default-hover: #bd3e09;
  --text-primary-on-color: #ffffff;
  --border-primary-default: #ec4e0b;
  --border-primary-default-hover: #bd3e09;
  --border-primary-default-subtle: #fbdcce;
  --border-primary-default-subtle-hover: #f7b89d;
  --border-primary-focus: #ec4e0b;
  --icons-primary-default: #ec4e0b;
  --icons-primary-default-hover: #bd3e09;
  --icons-primary-on-color: #ffffff;
  --icons-primary-on-color-hover: #ffffff;

  /* SURFACES */
  --surface-default: #ffffff;
  --surface-page: #ffffff;
  --surface-page-secondary: #f6f6f6;
  --surface-default-secondary: #f6f6f6;
  --surface-disabled-disabled: #cccccc;

  /* TEXT */
  --text-default-heading: #1a1a1a;
  --text-default-body: #4d4d4d;
  --text-default-caption: #4d4d4d;
  --text-default-placeholder: #7f7f7f;
  --text-on-color-heading: #ffffff;
  --text-on-color-body: #ffffff;
  --text-on-color-caption: #f6f6f6;
  --text-disabled-default: #999999;
  --text-disabled-on-color: #7f7f7f;

  /* BORDERS */
  --border-default: #f6f6f6;
  --border-default-secondary: #e5e5e5;
  --border-disabled-disabled: #cccccc;

  /* ICONS */
  --icons-disabled-default: #999999;
  --icons-disabled-on-color: #7f7f7f;

  /* STATUS */
  --surface-error-default: #ec0b38;
  --surface-error-default-subtle: #fbced7;
  --surface-success-default: #00b64c;
  --surface-success-default-subtle: #ccf0db;
  --surface-warning-default: #ecbf0b;
  --surface-warning-default-subtle: #fbf2ce;
  --surface-information-default: #0ba8ec;
  --surface-information-default-subtle: #ceeefb;
  --text-error-default: #ec0b38;
  --text-success-default: #00b64c;
  --text-warning-default: #ecbf0b;
  --text-information-default: #0ba8ec;

  /* BORDER RADIUS + WIDTH */
  --br-100: 4px;
  --br-200: 8px;
  --bw-25: 1px;
  --bw-100: 4px;

  /* SPACING */
  --s-100: 4px;  --s-200: 8px;  --s-300: 12px; --s-400: 16px;
  --s-500: 20px; --s-600: 24px; --s-700: 28px; --s-800: 32px;
  --s-900: 36px; --s-1000: 40px; --s-1100: 48px; --s-1200: 56px;
  --s-1300: 64px; --s-1400: 72px;

  /* Z-INDEX */
  --z-base: 0;
  --z-action-icons: 10;
  --z-thumb-nav: 15;
  --z-dropdown: 50;
  --z-floating-toolbar: 60;
  --z-sticky-cta: 100;
  --z-overlay-backdrop: 200;
  --z-overlay-panel: 210;
  --z-fullscreen: 300;

  /* TYPOGRAPHY */
  --font-primary: 'PP Neue Montreal', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

---

## Layout Archetype Proportions Reference

| Archetype | Visual Zone | Control Zone | When to use |
|-----------|------------|--------------|-------------|
| **SBS-LR** | 55–65% | 35–45% | Default. Any product, 2–8 option groups |
| **SBS-RL** | 55–65% | 35–45% | Config is the focus, many steps |
| **TC** | 40–50% center | 25–30% each side | Extensive product specs needed |
| **FW-BP** | 65–75% height | 25–35% height (bottom) | 1–3 groups, visual impact priority |
| **COMPACT** | 50–60% | 40–50% | Embedded widget, constrained space |
| **VSTACK** | 40–50% viewport height | Full width stacked | Mobile-only or mobile-first |
| **SPLIT** | 50% | 50% | Luxury/premium, equal visual weight |
| **WIZARD** | 50% | 50% | 8+ sequential steps, complex products |
| **BUILD** | 65–70% | 30–35% | Modular assembly products |
