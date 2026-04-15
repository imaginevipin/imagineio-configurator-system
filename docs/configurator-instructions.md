# Configurator Generation Instructions

**Version:** 1.0
**System:** imagine.io Configurator Generation System
**Audience:** Claude Code
**Last Updated:** March 2026

---

## 1. What This Document Is

This is the master playbook. When you (Claude Code) are asked to build a product configurator, this document governs your entire process from start to finish. It references two companion documents:

- **Configurator Architecture Reference** (`configurator-architecture.md`) — Layout archetypes, component specs, responsive rules, spacing, transitions, states. This is WHAT to build.
- **Requirement Parsing Guide** (`requirement-template.md`) — How to interpret requirements, extract data, resolve design systems, ask questions. This is HOW to understand what is being asked.

**This document is HOW to execute.** The step-by-step process, the code generation patterns, the quality checks, and the rules for every decision you make along the way.

---

## 2. End-to-End Workflow

Every configurator build follows this exact sequence. Do not skip or reorder phases.

```
PHASE 1: RECEIVE AND UNDERSTAND
  1.1  Receive the requirement (any format)
  1.2  Identify design system mode (PDS or Client)
  1.3  If Client mode: extract visual values, present to user, get confirmation
  1.4  Extract product data (options, pricing, images)
  1.5  Determine layout archetype
  1.6  Identify gaps
  1.7  Ask ALL clarifying questions in one message
  1.8  Wait for answers

PHASE 2: PLAN
  2.1  Assemble the internal requirement object
  2.2  Present style preferences to user (layout, swatch shape, accordion vs visible, CTA style, selection indicator)
  2.3  Finalize archetype and component mapping based on user choices
  2.4  Plan the responsive behavior
  2.5  Determine the file structure

PHASE 3: GENERATE
  3.1  Write the CSS (design tokens, layout, components, responsive, states)
  3.2  Write the HTML structure
  3.3  Write the JavaScript (state management, interactions, price calculation)
  3.4  Integrate images or placeholders

PHASE 4: VALIDATE AND DELIVER
  4.1  Self-review against the architecture spec
  4.2  Verify responsive behavior
  4.3  Verify accessibility
  4.4  Present the output to the user with a summary of what was built and any assumptions made
```

---

## 3. Phase 1: Receive and Understand

### 3.1 Receiving the Requirement

The requirement will arrive in an unpredictable format. It could be:
- A paragraph of text
- A structured document or spreadsheet
- A Figma link
- A screenshot with notes
- A conversation message like "build me a chair configurator with 3 fabrics and 5 leg colors"
- A combination of the above

Your first job is to READ everything provided before doing anything else. Do not start generating code the moment you see the word "configurator." Read first. Understand fully. Then act.

### 3.2 Design System Resolution (FIRST)

Follow Requirement Parsing Guide, Section 3.

**Decision:** Is this PDS or Client mode?

| Signal | Mode |
|--------|------|
| No brand/client mentioned | PDS |
| "Use our design system" / "PDS" / "Prism" | PDS |
| Internal demo or showcase | PDS |
| Client name mentioned | Client — need reference material |
| Screenshot of a website shared | Client — extract from screenshot |
| Figma link to client designs shared | Client — extract from Figma |
| Brand guidelines document shared | Client — extract from document |
| "Match their site" / "follow their brand" | Client — ask for reference if not provided |
| Vague aesthetic description only | Ask for clarification |

**If Client mode:**
1. Extract visual values per Requirement Parsing Guide Section 3.4
2. Derive the complete variable set per Requirement Parsing Guide Section 3.5
3. Present to user for confirmation per Requirement Parsing Guide Section 3.7
4. DO NOT proceed to Phase 2 until the design system is confirmed

**If PDS mode:**
- Load `prism-token-structure.md` as reference
- Use the PDS defaults from Architecture Reference Section 5.6
- No user confirmation needed. Proceed.

### 3.3 Extracting Product Data

Follow Requirement Parsing Guide, Sections 4 and 5.

Read the requirement and extract:

**Critical (must find or ask):**
- Product name
- Option groups (what can be customized)
- Options within each group (specific choices)
- CTA action/label

**Important (should find or infer):**
- Option types (color, material, size, etc.)
- Pricing (base price, modifiers)
- Images (URLs or "use placeholders")
- Layout preference

**Nice to have (use defaults if absent):**
- Description, SKU, rating, trust badges, specs
- Action icons, secondary CTA, quantity selector

### 3.4 Determining the Layout Archetype

Follow Architecture Reference, Section 9 (Decision Tree).

Work through the decision tree in order:
1. Check for explicit constraints (embed, mobile-only, modular, luxury, stepped)
2. Count option groups
3. Select archetype
4. If the requirement mentions a specific reference configurator from the Figma file, prioritize matching that layout pattern

**Important:** If you select an archetype, briefly explain WHY to the user when you present the plan. For example: "I am using the side-by-side layout (SBS-LR) because you have 4 option groups, which fits well in a scrollable panel alongside the preview."

### 3.5 Identifying Gaps and Asking Questions

Follow Requirement Parsing Guide, Section 6.

Compare what you have against the Critical and Important field lists. For every gap:
1. Check if it can be reasonably inferred (e.g., options listed as hex colors → type is "color")
2. If it cannot be inferred, add it to your questions list

**Ask ALL questions in ONE message.** Structure them as per Requirement Parsing Guide Section 6.2:
- Group by category (Product Data, Design, Behavior)
- Offer defaults where possible
- Explain briefly why each piece of info matters

**If the requirement is very complete:** Do not ask questions for the sake of asking. State your plan and proceed, noting any minor assumptions.

---

## 4. Phase 2: Plan

### 4.1 Assemble the Internal Requirement Object

Organize all extracted data into the structured format defined in Requirement Parsing Guide, Section 11. You do not need to show this to the user. This is your internal representation.

### 4.2 Present Style Preferences

Before making final component and layout decisions, present the user with a concise set of styling choices. This gives the team control over key visual decisions without requiring them to specify everything upfront.

**Rules for this step:**
- Present this AFTER Phase 1 is complete (you have all the product data)
- Combine this with your clarifying questions if you still have any from Phase 1
- Keep it short. Maximum 5 to 6 choices. Do not overwhelm.
- For each choice, state what you recommend and why, so the user can just say "go with your recommendations" if they want
- If the requirement already specifies a preference explicitly (e.g., "use accordion layout"), do not ask about that choice again

**Style preferences to present:**

```
Before I build, a few quick style preferences:

1. LAYOUT
   I recommend: [archetype name] — [one line reason]
   Other options that could work: [alternatives]

2. OPTION SELECTOR STYLE
   For [group name]: [recommended component] — [reason]
   Alternative: [other option]
   (Repeat for each group where there is a genuine choice, e.g., circular vs square swatches, image swatches vs card selectors)

3. OPTION GROUP PRESENTATION
   I recommend: [all visible / accordion / tabbed] — [reason]
   Alternative: [other option]

4. SWATCH SHAPE (if color options exist)
   Circular swatches or rounded square swatches?

5. CTA STYLE
   Price inside the button (e.g., "Add to Cart — $450") or price separate above the button?

6. SELECTION INDICATOR
   Border highlight + checkmark badge, or border highlight only?

Want me to go with these recommendations, or would you like to change any?
```

**When to SKIP this step:**
- If the requirement is extremely specific and already dictates all styling choices
- If the user has previously said "just build it, I'll adjust later" in this session
- If the user explicitly asks to skip preferences

**Example of a concise preference prompt:**

```
Before I build the Dining Chair configurator, a few quick style choices:

1. Layout: Side-by-side (preview left, panel right) — best fit for 2 option groups
2. Wood Finish options: Rectangular image swatches with labels (since you have texture images)
3. Seat Fabric options: Rectangular image swatches (same style for consistency) — or would you prefer circular color swatches?
4. Option groups: Both visible at once (only 2 groups, no need for accordion)
5. CTA: "Add to Cart" with price inside the button
6. Selection: Border highlight with checkmark badge in corner

Go with these, or want to tweak anything?
```

### 4.3 Archetype and Component Mapping

After receiving the user's preference response (or approval of defaults), finalize the component mapping.

For each option group, map it to a selector component:

| Option Group Type | Selector Component | Architecture Reference |
|-------------------|-------------------|----------------------|
| `color` (with hex values) | Color Swatch (circular or rounded square) | Section 3.3.2 / 3.3.3 |
| `material` (with image URLs) | Image Swatch (rectangular) | Section 3.3.1 |
| `variant` (with product photos) | Card Selector or Image Swatch L/XL | Section 3.3.5 / 3.3.1 |
| `size` (discrete text values) | Text Pill | Section 3.3.4 |
| `dropdown` (8+ options) | Dropdown Selector | Section 3.3.6 |
| `range` (continuous numeric) | Slider | Section 3.3.8 |
| `quantity` (integer) | Stepper | Section 3.3.9 |
| `toggle` (binary) | Two-option Text Pill or Toggle switch | Section 3.3.4 |
| `text-input` | Text input field | Not in architecture (implement as standard input with PDS/client styling) |

**Swatch size selection logic:**

| Number of Options | Recommended Swatch Size |
|-------------------|------------------------|
| 2 to 4 | L or XL |
| 5 to 8 | M |
| 9 to 15 | S |
| 16+ | XS, or switch to Dropdown |

**When multiple option groups exist, decide on presentation:**

| Number of Groups | Presentation |
|-----------------|-------------|
| 1 to 4 | All visible, stacked vertically |
| 5 to 7 | Accordion (collapsed by default, except first group open) |
| 8+ | Accordion all collapsed, or WIZARD archetype |

### 4.4 Plan the Responsive Behavior

Based on the selected archetype, check Architecture Reference Section 4.2 for that archetype's responsive transformation rules. You do not need to make any decisions here; just follow the spec. But verify:
- What happens at tablet (768px to 1023px)?
- What happens at mobile (below 768px)?
- Does the CTA become sticky on mobile?
- Do accordions auto-close on mobile?
- Do swatches resize?

### 4.5 Determine File Structure

**Default (single-file HTML):**
Everything in one `.html` file. CSS in a `<style>` block. JavaScript in a `<script>` block. This is the standard output unless the requirement specifies otherwise.

**React output:**
A single `.jsx` file with a default export component. CSS as inline styles or a CSS-in-JS approach using the design system variables. State managed with `useState` and `useEffect`.

**Vue output:**
A single `.vue` SFC file with `<template>`, `<style scoped>`, and `<script setup>` sections.

---

## 5. Phase 3: Generate

### 5.1 Code Structure (HTML Output)

Every configurator follows this structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Product Name] Configurator</title>
  <style>
    /* ===== DESIGN SYSTEM TOKENS ===== */
    :root {
      /* Full variable set from Architecture Reference Section 5.6 */
      /* Values from PDS or client extraction */
    }

    /* ===== RESET AND BASE ===== */
    /* Minimal reset */

    /* ===== LAYOUT ===== */
    /* Configurator container, Visual Zone, Control Zone */

    /* ===== VISUAL ZONE COMPONENTS ===== */
    /* Preview area, thumbnails, action icons */

    /* ===== CONTROL ZONE COMPONENTS ===== */
    /* Product title, option groups, selectors */

    /* ===== SELECTION COMPONENTS ===== */
    /* Swatches, pills, cards, dropdowns */
    /* Each with: default, hover, selected, disabled, focus states */

    /* ===== CTA AND COMMERCE ===== */
    /* Buttons, price display, trust badges */

    /* ===== STATES ===== */
    /* Loading, error, empty states */

    /* ===== RESPONSIVE ===== */
    /* Mobile-first: base mobile styles above */
    /* @media (min-width: 768px) { tablet styles } */
    /* @media (min-width: 1024px) { desktop styles } */
    /* @media (min-width: 1440px) { desktop-large styles } */

    /* ===== ACCESSIBILITY ===== */
    /* Focus styles, reduced motion, screen reader utilities */

    /* ===== ANIMATIONS ===== */
    /* Transitions per Architecture Reference Section 5.5 */
  </style>
</head>
<body>

  <div class="configurator" role="region" aria-label="[Product Name] Configurator">
    <!-- Structure depends on archetype -->
    <!-- See Section 5.3 for archetype-specific HTML -->
  </div>

  <script>
    /* ===== STATE ===== */
    /* Configuration state object */

    /* ===== INITIALIZATION ===== */
    /* Set defaults, render initial state */

    /* ===== SELECTION HANDLERS ===== */
    /* Click handlers for each option group */

    /* ===== PRICE CALCULATION ===== */
    /* Dynamic price updates */

    /* ===== IMAGE UPDATES ===== */
    /* Preview image swap on selection change */

    /* ===== RESPONSIVE BEHAVIOR ===== */
    /* Accordion auto-close on mobile, etc. */

    /* ===== ACCESSIBILITY ===== */
    /* Keyboard navigation handlers */
  </script>

</body>
</html>
```

### 5.2 CSS Generation Rules

#### 5.2.1 Reset

Use a minimal reset. Do not import a full reset library.

```css
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: var(--font-primary);
  color: var(--text-default-body);
  background: var(--surface-page);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

img {
  display: block;
  max-width: 100%;
  height: auto;
}

button {
  cursor: pointer;
  border: none;
  background: none;
  font: inherit;
  color: inherit;
}
```

#### 5.2.2 Token Usage Rules

- NEVER use raw hex values in component styles. Always use `var(--token-name)`.
- NEVER use magic numbers for spacing. Always use spacing scale variables (`var(--s-200)`, etc.).
- NEVER use arbitrary z-index values. Always use z-index scale variables.
- NEVER hardcode font families. Always use `var(--font-primary)`.
- The ONLY place raw hex values appear is inside the `:root {}` block.

```css
/* WRONG */
.button { background: #ec4e0b; padding: 12px 16px; }

/* CORRECT */
.button {
  background: var(--surface-primary-default);
  padding: var(--s-300) var(--s-400);
}
```

#### 5.2.3 Hover State Gating

All hover styles must be gated behind `@media (hover: hover)`:

```css
@media (hover: hover) {
  .swatch:hover {
    border-color: var(--border-primary-default-subtle-hover);
    transition: border-color 150ms ease-out;
  }
}

/* Active/press state for touch devices */
.swatch:active {
  transform: scale(0.96);
}
```

#### 5.2.4 Focus Styles

Every interactive element must have a visible focus indicator:

```css
/* Remove default outlines and replace with consistent focus ring */
.swatch:focus-visible,
.pill:focus-visible,
.card-selector:focus-visible,
.dropdown-trigger:focus-visible,
.cta-button:focus-visible {
  outline: 2px solid var(--border-primary-focus);
  outline-offset: 2px;
}
```

#### 5.2.5 Reduced Motion

Include at the end of the CSS:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }
}
```

#### 5.2.6 Responsive CSS Structure

Mobile-first. Base styles are mobile. Layer up:

```css
/* Base: mobile (below 768px) */
.configurator {
  display: flex;
  flex-direction: column;
  padding: var(--s-300);
}

/* Tablet (768px and up) */
@media (min-width: 768px) {
  .configurator {
    flex-direction: row;
    padding: var(--s-400);
  }
}

/* Desktop (1024px and up) */
@media (min-width: 1024px) {
  .configurator {
    padding: var(--s-600);
    max-width: 1440px;
    margin: 0 auto;
  }
}
```

### 5.3 HTML Structure by Archetype

#### SBS-LR (Side-by-Side: Preview Left, Panel Right)

```html
<div class="configurator configurator--sbs-lr">
  
  <div class="visual-zone">
    <div class="preview-area">
      <img class="preview-image" src="" alt="[Product Name]" />
      <div class="interaction-hint">Drag to rotate. Click to zoom.</div>
      <div class="action-icons">
        <button class="action-icon" aria-label="Fullscreen"><!-- icon --></button>
      </div>
    </div>
    <div class="thumbnail-strip" role="listbox" aria-label="Product views">
      <!-- Thumbnail items -->
    </div>
  </div>

  <div class="control-zone">
    <div class="product-title-block">
      <span class="product-category">[Category]</span>
      <h1 class="product-name">[Product Name]</h1>
      <p class="product-description">[Description]</p>
      <span class="product-price" data-base-price="1200">$1,200.00</span>
    </div>

    <div class="option-groups">
      <!-- Option Group 1 -->
      <div class="option-group" data-group="color">
        <div class="option-group-header">
          <span class="option-group-label">COLOR</span>
          <span class="option-group-value">Charcoal Grey</span>
        </div>
        <div class="option-group-content" role="radiogroup" aria-label="Select color">
          <!-- Selection components here -->
        </div>
      </div>

      <!-- More option groups -->
    </div>

    <div class="cta-section">
      <div class="price-display">
        <span class="price-label">Total:</span>
        <span class="price-value">$1,200.00</span>
      </div>
      <button class="cta-primary">[CTA Label]</button>
    </div>
  </div>

</div>
```

**For other archetypes:** Follow the same pattern but adjust the structure per the ASCII diagrams in Architecture Reference Section 2. The class naming convention stays consistent:
- `.configurator--{archetype}` for the main container modifier
- `.visual-zone` and `.control-zone` always present
- `.option-group` wraps each option category
- `.cta-section` wraps the CTA and price

### 5.4 JavaScript Generation Rules

#### 5.4.1 State Object

```javascript
const configuratorState = {
  selections: {
    // group_id: selected_option_id
  },
  price: {
    base: 0,
    modifiers: {},    // group_id: modifier_value
    total: 0
  },
  currentView: 'front',  // active thumbnail
  ui: {
    openAccordion: null,  // which accordion is open (mobile: only one)
    isMobile: false
  }
};
```

#### 5.4.2 Initialization

```javascript
function initConfigurator() {
  // 1. Set default selections
  // 2. Render initial state (highlights, prices)
  // 3. Set up event listeners
  // 4. Check viewport and set isMobile
  // 5. Set up resize listener for responsive behavior
}

document.addEventListener('DOMContentLoaded', initConfigurator);
```

#### 5.4.3 Selection Handler Pattern

Every selectable option must follow this pattern:

```javascript
function handleOptionSelect(groupId, optionId) {
  // 1. Update state
  configuratorState.selections[groupId] = optionId;

  // 2. Update UI — deselect all in group, select the chosen one
  const group = document.querySelector(`[data-group="${groupId}"]`);
  group.querySelectorAll('[data-option]').forEach(opt => {
    opt.classList.remove('is-selected');
    opt.setAttribute('aria-selected', 'false');
  });
  const selected = group.querySelector(`[data-option="${optionId}"]`);
  selected.classList.add('is-selected');
  selected.setAttribute('aria-selected', 'true');

  // 3. Update the option group header value text
  const header = group.querySelector('.option-group-value');
  if (header) header.textContent = selected.dataset.label;

  // 4. Recalculate price
  updatePrice();

  // 5. Update preview image
  updatePreviewImage();

  // 6. Handle dependencies (if any)
  handleDependencies(groupId);
}
```

#### 5.4.4 Price Calculation

```javascript
function updatePrice() {
  let total = configuratorState.price.base;

  Object.entries(configuratorState.selections).forEach(([groupId, optionId]) => {
    const option = document.querySelector(
      `[data-group="${groupId}"] [data-option="${optionId}"]`
    );
    if (option && option.dataset.priceModifier) {
      total += parseFloat(option.dataset.priceModifier);
    }
  });

  configuratorState.price.total = total;

  // Update all price displays
  document.querySelectorAll('.price-value').forEach(el => {
    el.textContent = formatPrice(total);
  });
}

function formatPrice(amount) {
  // Use the currency from the requirement
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'  // Replace with requirement currency
  }).format(amount);
}
```

#### 5.4.5 Image Swap

```javascript
function updatePreviewImage() {
  const img = document.querySelector('.preview-image');
  if (!img) return;

  // Determine the correct image based on current selections
  const newSrc = getImageForSelections(configuratorState.selections);
  if (newSrc === img.src) return;

  // Crossfade transition
  img.style.opacity = '0';
  img.addEventListener('transitionend', function handler() {
    img.src = newSrc;
    img.onload = () => { img.style.opacity = '1'; };
    img.removeEventListener('transitionend', handler);
  }, { once: true });
}
```

#### 5.4.6 Keyboard Navigation

Implement for all selection components:

```javascript
function handleKeyboardNav(e, groupId) {
  const options = Array.from(
    document.querySelectorAll(`[data-group="${groupId}"] [data-option]`)
  );
  const current = options.findIndex(opt => opt.classList.contains('is-selected'));

  let next;
  switch (e.key) {
    case 'ArrowRight':
    case 'ArrowDown':
      e.preventDefault();
      next = (current + 1) % options.length;
      break;
    case 'ArrowLeft':
    case 'ArrowUp':
      e.preventDefault();
      next = (current - 1 + options.length) % options.length;
      break;
    case 'Enter':
    case ' ':
      e.preventDefault();
      handleOptionSelect(groupId, options[current].dataset.option);
      return;
    default:
      return;
  }

  options[next].focus();
  handleOptionSelect(groupId, options[next].dataset.option);
}
```

#### 5.4.7 Responsive JavaScript

```javascript
function checkViewport() {
  const wasMobile = configuratorState.ui.isMobile;
  configuratorState.ui.isMobile = window.innerWidth < 768;

  if (wasMobile !== configuratorState.ui.isMobile) {
    handleViewportChange();
  }
}

function handleViewportChange() {
  if (configuratorState.ui.isMobile) {
    // Collapse all accordions except the first
    // Make CTA sticky behavior active
    // Adjust any JS-dependent responsive behavior
  } else {
    // Expand all accordions (or restore desktop state)
    // Remove sticky CTA behavior
  }
}

window.addEventListener('resize', debounce(checkViewport, 150));
```

#### 5.4.8 Dependency Handling

```javascript
function handleDependencies(changedGroupId) {
  // For each group that depends on the changed group:
  // 1. Filter available options based on new selection
  // 2. If currently selected option is now unavailable, auto-select first available
  // 3. Update UI to show/hide/disable options
  // 4. Recalculate price (already called in handleOptionSelect, but re-verify)
}
```

### 5.5 Data Attributes Convention

All product data should be in HTML data attributes so the JavaScript can read it:

```html
<!-- On the configurator container -->
<div class="configurator"
     data-base-price="1200"
     data-currency="USD">

<!-- On each option item -->
<button class="color-swatch is-selected"
        data-group="color"
        data-option="charcoal-grey"
        data-label="Charcoal Grey"
        data-price-modifier="0"
        aria-selected="true"
        role="radio"
        tabindex="0">
```

### 5.6 Class Naming Convention

Use BEM-like flat naming. No deep nesting.

```
.configurator               — Main container
.configurator--sbs-lr        — Archetype modifier
.visual-zone                 — Preview area wrapper
.preview-area                — Image container
.preview-image               — The product image
.thumbnail-strip             — Thumbnail container
.thumbnail                   — Individual thumbnail
.thumbnail.is-active         — Active thumbnail
.control-zone                — Config panel wrapper
.product-title-block         — Product info section
.product-name                — Product heading
.option-group                — Single option category
.option-group-header         — Label + value row
.option-group-content        — Options container
.color-swatch                — Circular color swatch
.color-swatch.is-selected    — Selected state
.image-swatch                — Rectangular image swatch
.text-pill                   — Text option pill
.card-selector               — Card option
.dropdown                    — Dropdown wrapper
.dropdown-trigger            — Dropdown button
.dropdown-panel              — Dropdown options list
.dropdown-option             — Individual dropdown option
.slider-input                — Range slider wrapper
.stepper                     — Quantity stepper
.cta-section                 — CTA area
.cta-primary                 — Primary action button
.cta-secondary               — Secondary action button
.price-display               — Price section
.price-value                 — The price number
.trust-badges                — Trust badges row

State classes (always prefixed with is- or has-):
.is-selected                 — Selected option
.is-active                   — Active thumbnail/tab
.is-open                     — Open accordion/dropdown
.is-disabled                 — Disabled option
.is-loading                  — Loading state
.has-error                   — Error state
```

---

## 6. Phase 4: Validate and Deliver

### 6.1 Self-Review Checklist

Before presenting the output, verify ALL of the following:

**Design System:**
- [ ] All colors use CSS variables from `:root`, never raw hex in component styles
- [ ] Font family uses `var(--font-primary)`
- [ ] Spacing uses `var(--s-*)` scale variables
- [ ] Border radius uses `var(--br-*)` variables
- [ ] Z-index uses `var(--z-*)` variables
- [ ] If Client mode: values match what user confirmed

**Layout:**
- [ ] Archetype structure matches Architecture Reference Section 2
- [ ] Visual Zone and Control Zone proportions are correct for the archetype
- [ ] CTA is properly positioned (bottom of Control Zone on desktop, sticky on mobile)

**Components:**
- [ ] Every option group has a label showing the current selection
- [ ] Every selectable option has default, hover, selected, and disabled states defined in CSS
- [ ] Selected state uses `--border-primary-default` (2px border)
- [ ] A default option is selected on load for every group

**Interactivity:**
- [ ] Clicking an option updates the selection state visually
- [ ] Selection updates the option group header value text
- [ ] Price recalculates on every selection change (if pricing is enabled)
- [ ] Preview image updates on selection change (if image mapping exists)
- [ ] Dependencies filter options correctly (if dependencies exist)

**Responsive:**
- [ ] Base styles are mobile (flex-direction: column)
- [ ] Tablet breakpoint (768px) switches to side-by-side where applicable
- [ ] Desktop breakpoint (1024px) applies full proportions
- [ ] CTA is sticky on mobile with shadow and background
- [ ] Swatches resize per Architecture Reference Section 4.3
- [ ] Accordions auto-close on mobile (if applicable)
- [ ] Thumbnail strip scrolls horizontally on mobile
- [ ] Touch targets are 44px minimum

**Accessibility:**
- [ ] `role="radiogroup"` on option group containers
- [ ] `role="radio"` and `aria-selected` on each option
- [ ] `aria-label` on all icon buttons
- [ ] Keyboard navigation works (Arrow keys, Enter, Space)
- [ ] Focus-visible ring on all interactive elements
- [ ] `prefers-reduced-motion` media query included
- [ ] Color swatches have accessible labels (not just color-only indication)

**Code Quality:**
- [ ] No inline styles (everything in the `<style>` block or CSS variables)
- [ ] No `!important` (except in the reduced-motion media query)
- [ ] No unused CSS selectors
- [ ] JavaScript uses `const` and `let`, never `var`
- [ ] No console.log statements in final output
- [ ] HTML is valid and well-indented

### 6.2 Presenting the Output

When you deliver the configurator, include a brief summary. Do not dump code without context.

**Summary format:**

```
Here is the [Product Name] configurator. A few notes:

**Layout:** [Archetype name] — [why this was chosen]
**Design System:** [PDS / Client name] — [brief note on extraction if client mode]
**Option Groups:** [count] groups — [list them briefly]
**Pricing:** [dynamic/static/none]
**Responsive:** Desktop, Tablet, and Mobile supported

**Assumptions I made:**
- [Any defaults or inferences that were not explicitly in the requirement]
- [Any placeholder content that needs to be replaced]

The configurator is in a single HTML file. Open it in a browser to test. Let me know if you want any adjustments.
```

### 6.3 Handling Revision Requests

When the user asks for changes after delivery:

1. **Visual changes (colors, fonts, sizes):** Update the `:root` variables or specific component styles. Do not rewrite the whole file.
2. **Adding/removing options:** Update the HTML and data for the affected option group. Update any dependency logic. Verify price calculation still works.
3. **Layout change:** This may require significant restructuring. Explain the impact before doing it.
4. **Design system swap (PDS to Client or vice versa):** Replace the `:root` block. The rest of the code should not change if CSS variables were used correctly.
5. **Adding a new option group:** Add the HTML, CSS for the selector type, and JS handler. Wire it into the state object and price calculation.

Always preserve existing working functionality when making changes. Do not rewrite unrelated sections.

---

## 7. Common Pitfalls and How to Avoid Them

### 7.1 Generating Code Too Early

**Pitfall:** Starting to write code the moment you see "build a configurator" without fully understanding the requirement.
**Fix:** Complete Phase 1 entirely before opening Phase 3. If you are unsure about anything, ask. A 2-minute clarification saves a 20-minute rewrite.

### 7.2 Inventing Product Data

**Pitfall:** Making up option names, prices, or colors that were not in the requirement.
**Fix:** Use placeholders and flag them: `<!-- PLACEHOLDER: Replace with actual fabric names -->`. Never silently invent data.

### 7.3 Using Raw Values Instead of Tokens

**Pitfall:** Writing `background: #ec4e0b` instead of `background: var(--surface-primary-default)`.
**Fix:** The only place hex values appear is `:root`. Everything else uses variables. No exceptions.

### 7.4 Forgetting Responsive

**Pitfall:** Building a desktop-only configurator.
**Fix:** Always write mobile-first CSS. Always include at minimum the 768px and 1024px breakpoints. Always make the CTA sticky on mobile. Test mentally at each breakpoint.

### 7.5 Ignoring Accessibility

**Pitfall:** Using `div` elements for buttons, missing ARIA roles, no keyboard navigation.
**Fix:** Follow the accessibility checklist in Section 6.1. Use semantic elements (`button`, not `div onclick`). Add ARIA roles and labels. Implement keyboard handlers.

### 7.6 Making the CTA Disappear

**Pitfall:** On long option lists, the CTA scrolls off screen and the user cannot find it.
**Fix:** On mobile, CTA is always sticky. On desktop, use the sticky Visual Zone pattern (Architecture Reference Section 11) so the user scrolls options while the CTA remains reachable at the bottom of the Control Zone.

### 7.7 Broken Selection States

**Pitfall:** Multiple options appear selected, or selection does not visually update.
**Fix:** Always deselect ALL options in the group first, then select the new one. Use the `is-selected` class pattern consistently. Use `aria-selected` for screen readers.

### 7.8 Price Not Updating

**Pitfall:** Price display shows the base price and never changes when options are selected.
**Fix:** Call `updatePrice()` from every `handleOptionSelect()` function. Verify that each option has a `data-price-modifier` attribute. Check that `parseFloat` correctly reads the modifier value.

### 7.9 Client Design System Looks Wrong

**Pitfall:** Extracting values from a screenshot inaccurately, resulting in a configurator that does not match the client's brand.
**Fix:** Always present extracted values to the user for confirmation before generating code. When in doubt, extract conservatively (slightly muted, slightly lighter) rather than oversaturating. Provide the `:root` block as a standalone snippet the user can tweak.

### 7.10 Image Swap Flashes White

**Pitfall:** When switching the preview image, the old image disappears and there is a flash of the empty background before the new image loads.
**Fix:** Use the crossfade pattern from Section 5.4.5. Keep the old image visible at full opacity until the new image has loaded. Only then swap and fade in.

---

## 8. Reference Quick-Links

When generating a configurator, you will need to look up specific details. Here is where to find each:

| Need | Document | Section |
|------|----------|---------|
| Layout proportions | Architecture Reference | 2.x (per archetype) |
| Component states and sizing | Architecture Reference | 3.x |
| Selection states (default, hover, selected, disabled) | Architecture Reference | 3.3.x (per component) |
| Responsive breakpoints | Architecture Reference | 4.1 |
| Responsive layout per archetype | Architecture Reference | 4.2.x |
| Component responsive sizing | Architecture Reference | 4.3.x |
| Touch targets | Architecture Reference | 4.5.1 |
| Spacing values | Architecture Reference | 5.2 |
| Z-index scale | Architecture Reference | 5.4 |
| Transition timing | Architecture Reference | 5.5 |
| CSS variable block (PDS defaults) | Architecture Reference | 5.6 |
| Loading and error states | Architecture Reference | 10 |
| Desktop scroll behavior | Architecture Reference | 11 |
| Design system resolution workflow | Parsing Guide | 3 |
| Client value extraction | Parsing Guide | 3.4 |
| Deriving values from limited input | Parsing Guide | 3.5 |
| Flat variable set template | Parsing Guide | 3.6 |
| Required vs optional fields | Parsing Guide | 4 |
| Extraction patterns from text | Parsing Guide | 5 |
| Question strategy | Parsing Guide | 6 |
| Internal data structures | Parsing Guide | 7 to 10 |
| PDS token details | prism-token-structure.md | (whole doc) |
