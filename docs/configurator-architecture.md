# Configurator Architecture Reference

**Version:** 1.0
**System:** imagine.io Configurator Generation System
**Design Foundation:** Prism Design System (PDS)
**Last Updated:** March 2026

---

## 1. Purpose

This document defines the complete architectural blueprint for product configurators built by Claude Code. It covers layout archetypes, component taxonomy, selection patterns, interaction states, responsive behavior, and PDS token mappings. Claude Code must reference this document whenever generating a configurator from a requirement document.

**Key Principle:** Every configurator is composed of two fundamental zones: a **Visual Zone** (where the product is displayed) and a **Control Zone** (where the user makes selections). The architecture is about how these two zones relate to each other spatially, and what components live inside each.

**Design System Note:** Throughout this document, component specs reference semantic CSS variable names like `--surface-primary-default` and show PDS (Prism Design System) resolved values in parentheses, e.g., "(Papaya/500)". These parenthetical PDS values are the defaults. When building for a client, the variable NAMES stay the same but the VALUES are extracted from the client's visual identity (their website, brand guidelines, Figma file, or whatever reference is provided). The client may not have a design system at all. Claude Code derives the values from whatever visual reference exists. See the Requirement Parsing Guide, Section 3 for the complete design system resolution workflow.

---

## 2. Layout Archetypes

Every configurator uses one of the following layout archetypes. Claude Code must select the appropriate archetype based on the requirement document, or propose the best fit if the requirement does not specify one.

### 2.1 Side-by-Side: Preview Left, Panel Right (SBS-LR)

**When to use:** The most common and safest default. Works for any product category where the preview image is the hero and configuration options are moderate in number (2 to 8 option groups).

**Structure:**
```
┌─────────────────────────────────┬──────────────────────┐
│                                 │  Product Title       │
│                                 │  Subtitle / Price    │
│         Visual Zone             │                      │
│     (preview + thumbnails)      │  [Option Group 1]    │
│                                 │  [Option Group 2]    │
│                                 │  [Option Group 3]    │
│                                 │                      │
│                                 │  [ CTA Button ]      │
├─────────────────────────────────┼──────────────────────┤
│  Thumbnail Strip (optional)     │                      │
└─────────────────────────────────┴──────────────────────┘
```

**Proportions:**
- Visual Zone width: 55% to 65% of total width
- Control Zone width: 35% to 45% of total width
- Minimum Control Zone width: 320px (to prevent option cramping)
- Maximum Control Zone width: 520px (beyond this, options feel sparse)

**Visual Zone internal layout:**
- Main image area fills available height minus thumbnail strip
- Thumbnail strip sits at the bottom of the Visual Zone, horizontally scrollable if needed
- Action icons (expand, AR, share, download) positioned in the top-right or bottom corners of the image area, overlaid on the image

**Control Zone internal layout:**
- Product title block at the top
- Scrollable area for option groups if options exceed viewport height (see Section 11 for scroll behavior)
- CTA button at the bottom of the Control Zone content (scrolls naturally on desktop, sticky on mobile)
- Vertical spacing between option groups: `--s-600` (24px)

**Observed in reference configurators:** 1, 4, 5, 6, 12, 13, 15, 16, 18, 19, 28, 32, 33, 37, 38, 40

---

### 2.2 Side-by-Side: Panel Left, Preview Right (SBS-RL)

**When to use:** When the configuration options are the primary focus and the preview is secondary. Common for products with many customization steps or when the configuration itself tells a story (e.g., step-by-step builders). Also suitable when the panel needs to be wider than 45%.

**Structure:**
```
┌──────────────────────┬─────────────────────────────────┐
│  Product Title       │                                 │
│  Subtitle / Price    │                                 │
│                      │         Visual Zone             │
│  [Option Group 1]    │     (preview + thumbnails)      │
│  [Option Group 2]    │                                 │
│  [Option Group 3]    │                                 │
│                      │                                 │
│  [ CTA Button ]      │                                 │
└──────────────────────┴─────────────────────────────────┘
```

**Proportions:** Same ratios as SBS-LR, mirrored. Control Zone on the left at 35% to 45%.

**Observed in reference configurators:** 3, 17, 23, 26, 27

---

### 2.3 Three-Column Layout (TC)

**When to use:** When product information (specs, description, materials) needs dedicated space separate from both the preview and the configuration options. Common for high-consideration products like rugs, furniture collections, or B2B products where product details and configuration both need visibility simultaneously.

**Structure:**
```
┌─────────────────┬───────────────────────┬──────────────────┐
│  Product Info   │                       │  Configuration   │
│  Title          │     Visual Zone       │                  │
│  Specs          │     (preview)         │  [Option 1]      │
│  Description    │                       │  [Option 2]      │
│  Materials      │                       │  [Option 3]      │
│  Tabs           │                       │                  │
│                 │                       │  [ CTA ]         │
└─────────────────┴───────────────────────┴──────────────────┘
```

**Proportions:**
- Left info column: 25% to 30%
- Center Visual Zone: 40% to 50%
- Right config column: 25% to 30%

**Observed in reference configurators:** 35

---

### 2.4 Full-Width Preview with Bottom Panel (FW-BP)

**When to use:** When the product preview needs maximum visual impact and the configuration options are relatively simple (1 to 3 option groups). Ideal for products where the visual is everything: furniture in a room scene, vehicles, architectural visualizations.

**Structure:**
```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│                    Visual Zone                           │
│                (full-width preview)                      │
│                                                          │
│  Title (overlay, optional)         Action Icons          │
│                                                          │
├──────────────────────────────────────────────────────────┤
│  [Tab 1] [Tab 2] [Tab 3]                          [DL]  │
│                                                          │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐          │
│  │ opt  │ │ opt  │ │ opt  │ │ opt  │ │ opt  │          │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘          │
└──────────────────────────────────────────────────────────┘
```

**Proportions:**
- Visual Zone height: 65% to 75% of total configurator height
- Bottom panel height: 25% to 35% of total configurator height
- Bottom panel max height: 250px
- Options displayed horizontally in a scrollable row

**Bottom panel internal layout:**
- Tab bar at the top of the panel (if multiple option categories exist)
- Options displayed as a horizontal row of selectable items
- Horizontal scrolling when options overflow

**Observed in reference configurators:** 9, 10, 11

---

### 2.5 Full-Width Preview with Overlay Panel (FW-OP)

**When to use:** When you want the preview to remain dominant even while configuring. The options appear as an overlay sheet that slides up from the bottom or slides in from the side. Good for immersive experiences or when the configurator needs to feel more like an interactive viewer than a shopping tool.

**Structure (overlay closed):**
```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│                    Visual Zone                           │
│                (full-width, full-height)                 │
│                                                          │
│  Title                                   Action Icons    │
│                                                          │
│                              ┌─────────────────────────┐ │
│                              │ [Customize] button      │ │
│                              └─────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

**Structure (overlay open):**
```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│                    Visual Zone                           │
│                (dimmed background)                       │
│                                                          │
│  ┌──────────────────────────────────────────────────┐    │
│  │  Configuration Overlay                           │    │
│  │  [Option Group 1]                                │    │
│  │  [Option Group 2]                                │    │
│  │  [ Apply / CTA ]                                 │    │
│  └──────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────┘
```

**NOT directly observed in references but a common pattern in modern configurators.**

---

### 2.6 Builder / Compositor (BUILD)

**When to use:** When the product is assembled from modular pieces. The user drags, selects, or adds components to build a custom product. Think modular sofas, kitchen layouts, shelf systems, or any product where the configuration is spatial assembly.

**Structure:**
```
┌──────────────────────┬─────────────────────────────────┐
│  [Tab: Build]        │                                 │
│  [Tab: Style]        │                                 │
│                      │                                 │
│  [Dropdown 1]        │        Assembly Canvas          │
│  [Dropdown 2]        │       (top-down or 3D)          │
│                      │                                 │
│  ┌──────┐ ┌──────┐  │                                 │
│  │piece │ │piece │  │                                 │
│  └──────┘ └──────┘  │                                 │
│  ┌──────┐ ┌──────┐  │   [Move Left] [Move Right]      │
│  │piece │ │piece │  │   [Duplicate] [Delete]           │
│  └──────┘ └──────┘  │                                 │
│                      │                                 │
│  [Search pieces]     ├─────────────────────────────────┤
│                      │  [Toggle: 3D] [Dims] [AR View]  │
├──────────────────────┼─────────────────────────────────┤
│                      │  [ Add to Cart / CTA ]          │
└──────────────────────┴─────────────────────────────────┘
```

**Proportions:**
- Component catalog panel: 30% to 35% (left)
- Assembly canvas: 65% to 70% (right)

**Unique elements:**
- Tabbed navigation in the panel (Build vs. Style/Fabric)
- Searchable component catalog
- Component cards with thumbnail + label
- Canvas manipulation controls (move, duplicate, delete)
- Toggle controls for view modes (3D view, dimensions, AR)

**Observed in reference configurators:** 7, 8, 30

---

### 2.7 Compact / Embedded Widget (COMPACT)

**When to use:** When the configurator is embedded inside a larger page (e.g., a product detail page on an e-commerce site) and must fit within a constrained space. Total width is typically 300px to 900px.

**Structure (horizontal):**
```
┌───────────────────────────────────────────────┐
│  ┌──────────────┬──────────────────────┐      │
│  │  Visual Zone │  Product Title       │      │
│  │              │  [Options]           │      │
│  │              │  [ CTA ]             │      │
│  └──────────────┴──────────────────────┘      │
└───────────────────────────────────────────────┘
```

**Structure (vertical, mobile-first):**
```
┌────────────────────┐
│  Product Title     │
│  [Options]         │
│                    │
│  ┌──────────────┐  │
│  │ Visual Zone  │  │
│  └──────────────┘  │
│  Thumbnail Strip   │
│                    │
│  [More Options]    │
│  [ CTA ]           │
└────────────────────┘
```

**Proportions (horizontal):**
- Visual Zone: 50% to 60%
- Control Zone: 40% to 50%
- Total height: 400px to 600px

**Observed in reference configurators:** 20, 21, 22, 25, 37, 38, 39, 40

---

### 2.8 Vertical Stack / Mobile (VSTACK)

**When to use:** On viewports below 768px, OR when the configurator is specifically designed for mobile-first experiences. All content stacks vertically.

**Structure:**
```
┌────────────────────┐
│   Action Icons     │
│  ┌──────────────┐  │
│  │ Visual Zone  │  │
│  │              │  │
│  └──────────────┘  │
│  Carousel Dots     │
│  Thumbnail Strip   │
│                    │
│  Product Title     │
│  Description       │
│  SKU / Rating      │
│                    │
│  [Option Group 1]  │
│  [Option Group 2]  │
│  [Option Group 3]  │
│                    │
│  Feature Bullets   │
│                    │
│  [ CTA - sticky ]  │
└────────────────────┘
```

**Rules:**
- Visual Zone height: 40% to 50% of viewport height, or fixed at 250px to 350px
- Options stack vertically with full-width
- CTA should be sticky at the bottom of the viewport
- Thumbnail strip becomes horizontally scrollable
- All option groups collapsed by default (accordion pattern)

**Observed in reference configurators:** 22, 31, 39

---

### 2.9 Split-Screen Immersive (SPLIT)

**When to use:** When the visual and controls should have equal prominence. The screen is divided 50/50 with a clean vertical divide. Good for high-end or luxury products where the UI itself needs to feel premium.

**Structure:**
```
┌─────────────────────────┬─────────────────────────┐
│                         │                         │
│                         │  Product Title          │
│      Visual Zone        │  Description            │
│    (edge-to-edge)       │                         │
│                         │  [Option Group 1]       │
│                         │  [Option Group 2]       │
│                         │                         │
│                         │  Price                  │
│                         │  [ CTA ]                │
└─────────────────────────┴─────────────────────────┘
```

**Proportions:** Strict 50/50 split. No thumbnails in this layout; the visual zone uses a carousel or angle switcher instead.

**NOT directly observed in references but a valid archetype for luxury product configurators.**

---

### 2.10 Guided / Stepped Wizard (WIZARD)

**When to use:** When the product has many configuration steps that should be presented one at a time. The user progresses through steps sequentially. Good for complex products like custom curtains, custom suits, or build-to-order items with 5+ independent configuration categories.

**Structure:**
```
┌──────────────────────────────────────────────────────────┐
│  Step 1 ─── Step 2 ─── Step 3 ─── Step 4 ─── Review    │
├──────────────────────────────────┬───────────────────────┤
│                                  │  Step Title           │
│         Visual Zone              │  Step Description     │
│   (updates per step)             │                       │
│                                  │  [Options for this    │
│                                  │   step only]          │
│                                  │                       │
│                                  │  [Back]  [Next Step]  │
└──────────────────────────────────┴───────────────────────┘
```

**Rules:**
- Progress indicator at the top (stepper component)
- Only one option group visible at a time
- Visual Zone updates as user progresses
- Final step shows a summary of all selections with edit links
- CTA appears only on the final/review step

**Partially observed in reference configurators:** 12 (curtain configurator with many sequential options)

---

## 3. Component Taxonomy

Every configurator is composed of the following component categories. Each component has defined states, sizing, and PDS token mappings.

### 3.1 Visual Zone Components

#### 3.1.1 Main Image / Preview Area

**Purpose:** Displays the product image, 3D render, or scene.

**Properties:**
- Background: `--surface-page` (#ffffff) or `--surface-page-secondary` (#f6f6f6)
- Border radius: `--br-200` (8px) when the preview area is a card; 0px when edge-to-edge
- Overflow: hidden (image should not bleed outside the container)
- Aspect ratios commonly used: 4:3, 16:9, 1:1, or free-form (height fills available space)

**Content inside the preview area:**
- Product image/render (centered, object-fit: contain or cover depending on context)
- Interaction hint text (e.g., "Drag to rotate. Click to zoom.") positioned at the bottom center
  - Font: `caption/Regular` (12px, weight 400, line-height 16px, letter-spacing 2px)
  - Color: `--text-default-caption` (Grey/700)
  - May have a subtle background pill for readability

#### 3.1.2 Action Icons

**Purpose:** Provide utility actions (expand/fullscreen, AR view, share, download).

**Properties:**
- Size: 36px x 36px container with 20px to 24px icon inside
- Shape: circle or rounded square (`--br-200`)
- Background: `--surface-default` (#ffffff) with subtle shadow or border
- Border: `--border-default` (Grey/50)
- Icon color: `--icons-primary-default` (Papaya/500) or neutral dark
- Hover: background shifts to `--surface-default-secondary` (Grey/50)
- Positioning: absolute within the preview area
  - Common positions: top-right corner (horizontal row), left edge (vertical stack), or bottom corners

**Common actions and their icons:**
- Expand / Fullscreen
- AR / View in Room
- Share
- Download
- Rotate / 360 View

#### 3.1.3 Thumbnail Strip

**Purpose:** Allows switching between product views (angles, scenes, silo vs. lifestyle).

**Properties:**
- Thumbnail size: Small: 80px to 90px height. Medium: 100px to 120px height. Large: 120px to 140px height.
- Aspect ratio: typically matches the main image aspect ratio, or uses 4:3 / 1:1
- Border radius: `--br-100` (4px) on each thumbnail
- Gap between thumbnails: `--s-200` (8px) to `--s-300` (12px)
- Orientation: Horizontal (most common, below the main image) or Vertical (to the left or right of the main image)

**States:**
- Default: border `--border-default` (Grey/50), 1px
- Selected/Active: border `--border-primary-default` (Papaya/500), 2px
- Hover: border `--border-default-secondary` (Grey/100)

**Overflow behavior:**
- If thumbnails exceed container width: horizontal scroll with no scrollbar visible (CSS `overflow-x: auto; scrollbar-width: none`)
- Optionally, left/right navigation arrows appear on hover

---

### 3.2 Control Zone Components

#### 3.2.1 Product Title Block

**Purpose:** Displays the product name, optional subtitle/category, optional price, optional SKU, optional rating.

**Structure:**
```
[Category / Collection Label]     ← optional
Product Name                      ← required
[Description / Subtitle]          ← optional
[SKU: 12345]                      ← optional
[★★★★★ 289 reviews]               ← optional
[$360.00]                         ← optional (can also be at bottom near CTA)
```

**Typography mapping:**
- Category/Collection: `small/Medium` (14px, weight 500) or `caption/SemiBold` (12px, weight 600), color `--text-default-caption`, uppercase with letter-spacing
- Product Name: `H4/SemiBold` (32px, weight 600) or `H5/SemiBold` (24px, weight 600) depending on space, color `--text-default-heading`
- Description: `body/Regular` (16px, weight 400), color `--text-default-body`
- SKU: `small/Regular` (14px, weight 400), color `--text-default-caption`
- Price: `H5/Bold` (24px, weight 700) or `body-lg/Bold` (20px, weight 700), color `--text-default-heading`
- Strikethrough original price: `body/Regular` with text-decoration line-through, color `--text-disabled-default`

#### 3.2.2 Option Group

**Purpose:** A labeled container for a set of related selectable options. This is the primary building block of the Control Zone.

**Structure:**
```
┌──────────────────────────────────────────────────┐
│  Option Label          Current Selection    [▼]  │
│                                                  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐            │
│  │    │ │    │ │    │ │    │ │    │            │
│  └────┘ └────┘ └────┘ └────┘ └────┘            │
│  [label] [label] [label] [label] [label]         │
└──────────────────────────────────────────────────┘
```

**Option Group Header:**
- Label: `small/SemiBold` (14px, weight 600), color `--text-default-heading`, uppercase
- Current selection value: `small/Medium` (14px, weight 500), color `--text-default-body`
- Expand/collapse chevron: 12px to 16px, color `--icons-primary-default`
- Separator line below header: `--border-default` (Grey/50), 1px

**Spacing:**
- Padding within the group: `--s-400` (16px) vertical, `--s-400` (16px) horizontal (when the group is a card)
- Gap between option items: `--s-200` (8px) to `--s-300` (12px)
- Gap between option groups: `--s-500` (20px) to `--s-600` (24px)

**Collapsible behavior:**
- When used in an accordion pattern, only the header is visible when collapsed
- A preview of the current selection (swatch or text) shows next to the label when collapsed
- Click anywhere on the header to expand/collapse
- Chevron rotates 180 degrees on toggle
- Animation: height transition, 200ms ease-out

---

### 3.3 Selection Components

These are the individual selectable items within an Option Group. Claude Code must choose the appropriate selection component based on the option type described in the requirement document.

#### 3.3.1 Image Swatch (Rectangular)

**When to use:** When the option is best represented by a product photo or material texture. Used for fabric choices, product variants, scene selection, material previews.

**Sizes (choose based on available space and number of options):**
| Size Name | Dimensions | Use Case |
|-----------|-----------|----------|
| XS | 42px x 42px | Color/finish with texture photo, high count (10+) |
| S | 58px x 58px to 58px x 63px | Fabric swatches in a grid, many options |
| M | 75px x 75px | Material or texture tiles, moderate count |
| L | 90px x 90px to 114px x 90px | Product variant thumbnails |
| XL | 120px x 90px to 150px x 91px | Scene selection, product type cards with labels |

**Properties:**
- Border radius: `--br-100` (4px)
- Object-fit: cover (image fills the container, cropped if needed)
- Optional label below the swatch: `caption/Regular` (12px), color `--text-default-body`, text-align center, max-width matches swatch width, overflow ellipsis for long names

**States:**
- Default: border 1px `--border-default-secondary` (Grey/100)
- Hover: border 1px `--border-primary-default-subtle-hover` (Papaya/200), or subtle shadow
- Selected: border 2px `--border-primary-default` (Papaya/500). Container may shift inward by 1px to accommodate the thicker border without layout jump. Optionally, a small checkmark icon in the top-right corner: background `--surface-primary-default` (Papaya/500), icon `--icons-primary-on-color` (White), 16px to 20px circle.
- Disabled: opacity 0.4, cursor not-allowed

**Grid layout:**
- Options wrap in rows
- Grid gap: `--s-200` (8px) or `--s-300` (12px)
- Rows: auto-fill, items left-aligned

#### 3.3.2 Color Swatch (Circular)

**When to use:** When the option is a solid color (no texture image needed). Used for paint colors, product colors, simple finishes.

**Sizes:**
| Size Name | Diameter | Use Case |
|-----------|----------|----------|
| S | 22px to 24px | Inline color indicator next to a collapsed option row |
| M | 31px to 35px | Standard color picker grid |
| L | 42px to 48px | Prominent color selection |

**Properties:**
- Shape: circle (border-radius: 50%)
- Background: the actual color value
- Border: 1px solid `--border-default-secondary` (Grey/100) for light colors; no visible border for dark colors
- If the color is white or very light: always show border to distinguish from background

**States:**
- Default: no additional treatment
- Hover: scale(1.1) transform, or add a 2px ring with 2px gap (outline-offset)
- Selected: outer ring 2px `--border-primary-default` (Papaya/500) with 2px gap between the ring and the swatch (achieved via outline or a wrapper element with padding). Alternatively, a checkmark icon overlaid on the circle in contrasting color.
- Disabled: opacity 0.4, cursor not-allowed

**Layout:**
- Horizontal row, gap `--s-200` (8px) between circles
- Wrap to next row if needed

#### 3.3.3 Color Swatch (Rounded Square)

**When to use:** Same as circular but when the design language prefers squares, or when a label needs to appear below.

**Properties:**
- Same as circular swatch but with border-radius: `--br-100` (4px)
- Size: 31px to 48px per side
- Label below: `caption/Regular` (12px)

#### 3.3.4 Text Pill / Chip

**When to use:** When the option is a text value with no visual representation needed. Used for sizes (S, M, L or 50ml, 70ml), dimensions (8' x 11'), style names (Pencil Pleat, Rod Pocket).

**Sizes:**
| Size Name | Height | Padding | Use Case |
|-----------|--------|---------|----------|
| S | 26px | 8px horizontal | Short labels, compact space |
| M | 36px to 40px | 12px to 16px horizontal | Standard size selectors |
| L | 44px to 50px | 16px to 24px horizontal | Prominent option buttons |

**Properties:**
- Border radius: `--br-100` (4px) to `--br-200` (8px)
- Background: `--surface-default` (White)
- Border: 1px `--border-default-secondary` (Grey/100)
- Text: `small/Medium` (14px, 500) or `body/Medium` (16px, 500), color `--text-default-body`
- Min-width: auto (pill stretches to content), or equal-width columns when options are similar length

**States:**
- Default: border 1px `--border-default-secondary` (Grey/100), background `--surface-default`
- Hover: border 1px `--border-primary-default-subtle-hover` (Papaya/200), background `--surface-primary-default-subtle` (Papaya/100)
- Selected: border 2px `--border-primary-default` (Papaya/500), background `--surface-default` (White) or `--surface-primary-default-subtle` (Papaya/100), text color `--text-primary-default` (Papaya/500)
- Disabled: background `--surface-disabled-disabled` (Grey/200), border `--border-disabled-disabled` (Grey/200), text `--text-disabled-default` (Grey/400)

**Layout:**
- Horizontal row with wrapping, gap `--s-300` (12px)
- Or equal-width grid columns (2-up or 3-up)

#### 3.3.5 Card Selector

**When to use:** When each option needs multiple pieces of information: an image/icon, a title, a subtitle, and/or a price. Used for product trim levels, package tiers, variant types.

**Sizes:**
| Size Name | Dimensions | Use Case |
|-----------|-----------|----------|
| S | Full-width x 52px | Compact package selector (text only, horizontal layout) |
| M | 150px x 70px to 150px x 91px | Grid card with image and label |
| L | Full-width x 90px to 120px | Detailed card with image, title, subtitle, price |

**Properties:**
- Border radius: `--br-200` (8px)
- Background: `--surface-default` (White)
- Border: 1px `--border-default-secondary` (Grey/100)
- Padding: `--s-300` (12px) to `--s-400` (16px)

**Internal layout (varies by size):**
- Small: Left-aligned text (title) + right-aligned secondary info (price)
- Medium: Image on top, label below, optional price
- Large: Image left or top, title + subtitle + price right or below

**States:**
- Default: border 1px `--border-default-secondary` (Grey/100)
- Hover: border 1px `--border-primary-default-subtle-hover` (Papaya/200), subtle shadow
- Selected: border 2px `--border-primary-default` (Papaya/500), optional checkmark badge in corner
- Disabled: opacity 0.5

**Layout:**
- 2-up grid (most common), or full-width stacked list
- Gap: `--s-300` (12px)

#### 3.3.6 Dropdown Selector

**When to use:** When there are too many options (8+) to display as swatches/pills, or when space is limited. Used for size lists, collection selections, detailed material catalogs.

**Properties:**
- Height: 44px
- Border radius: `--br-100` (4px) to `--br-200` (8px)
- Background: `--surface-default` (White)
- Border: 1px `--border-default-secondary` (Grey/100)
- Padding: `--s-300` (12px) horizontal
- Text: `body/Regular` (16px, 400), color `--text-default-body`
- Chevron icon: right-aligned, color `--icons-primary-default`
- Width: 100% of the Control Zone content width

**States:**
- Default: border `--border-default-secondary`
- Hover: border `--border-primary-default-subtle-hover` (Papaya/200)
- Open/Focus: border `--border-primary-focus` (Papaya/500), 2px
- Disabled: background `--surface-disabled-disabled`, text `--text-disabled-default`

**Dropdown panel (when open):**
- Background: `--surface-default` (White)
- Border: 1px `--border-default-secondary`
- Border radius: `--br-200` (8px)
- Shadow: 0px 4px 16px rgba(0,0,0,0.08)
- Max height: 240px, overflow-y auto
- Each option: 40px height, padding `--s-300` horizontal
- Hover on option: background `--surface-primary-default-subtle` (Papaya/100)
- Selected option: text `--text-primary-default` (Papaya/500), optionally with check icon

**Option with price modifier:**
- Option text left-aligned, price modifier right-aligned
- Price modifier text: `small/Regular` (14px, 400), color `--text-default-caption`
- Example: "Sunbrella Canvas     +$0"

#### 3.3.7 Accordion Row Selector

**When to use:** When option groups are stacked vertically and each group shows a preview of its current selection when collapsed. The user expands one at a time. Good for configurators with many option groups (5+).

**Properties (collapsed):**
- Height: 52px to 60px
- Background: `--surface-default` (White)
- Border bottom: 1px `--border-default` (Grey/50)
- Left side: optional swatch preview (22px to 36px) + label + current value
- Right side: chevron icon

**Label text:** `small/SemiBold` (14px, 600), color `--text-default-heading`
**Value text:** `body/Regular` (16px, 400), color `--text-default-body`

**Properties (expanded):**
- Header matches collapsed state but with chevron rotated
- Options area appears below with a reveal animation (200ms)
- Options area padding: `--s-400` (16px)
- Contains any selection component from 3.3.1 to 3.3.6

**Observed in configurators:** 4, 5, 12

#### 3.3.8 Slider / Range Input

**When to use:** When the option is a continuous value within a range. Used for width, height, weight, quantity, or any numeric dimension.

**Properties:**
- Track height: 4px
- Track color (unfilled): `--border-default-secondary` (Grey/100)
- Track color (filled): `--surface-primary-default` (Papaya/500)
- Thumb: 16px to 20px circle, background `--surface-primary-default` (Papaya/500), border 2px White
- Label: displays current value next to the slider or above it
- Label text: `body/SemiBold` (16px, 600), color `--text-primary-default`

**States:**
- Default: as described above
- Hover: thumb scale(1.2)
- Active/Dragging: thumb scale(1.2), subtle shadow
- Disabled: track and thumb use `--surface-disabled-disabled`

**Observed in configurators:** 18 (sink width slider)

#### 3.3.9 Stepper (Quantity)

**When to use:** For integer quantities. Plus/minus buttons flanking a number display.

**Properties:**
- Container height: 44px to 48px
- Container border: 1px `--border-default-secondary` (Grey/100)
- Container border radius: `--br-200` (8px)
- Minus button: left, 44px width
- Plus button: right, 44px width
- Value display: center, `body/SemiBold` (16px, 600)
- Button icons: 16px to 20px, color `--text-default-body`

**States:**
- Minus disabled at min value: icon color `--text-disabled-default`
- Plus disabled at max value: icon color `--text-disabled-default`

**Observed in configurators:** 19 (quantity stepper)

#### 3.3.10 Tab / Segmented Control

**When to use:** When the user needs to switch between option categories or view modes. Not a selection component per se, but a navigation element within the configuration.

**Properties:**
- Container height: 40px to 50px
- Container background: `--surface-page-secondary` (Grey/50)
- Container border radius: `--br-200` (8px)
- Each tab: equal width, or auto width with padding `--s-400` (16px) horizontal
- Tab text: `small/Medium` (14px, 500)

**States:**
- Default tab: background transparent, text `--text-default-body`
- Selected tab: background `--surface-primary-default` (Papaya/500), text `--text-primary-on-color` (White), border-radius `--br-100` (4px)
- Hover: background `--surface-primary-default-subtle` (Papaya/100)

**Observed in configurators:** 7, 8, 9, 10, 11, 30

---

### 3.4 CTA and Commerce Components

#### 3.4.1 Primary CTA Button

**Purpose:** The main action button. "Add to Cart", "Configure", "Buy Now", "Get Quote".

**Properties:**
- Height: 44px to 56px
- Width: 100% of Control Zone content width
- Background: `--surface-primary-default` (Papaya/500)
- Text: `body/SemiBold` (16px, 600) or `body-lg/SemiBold` (20px, 600), color `--text-primary-on-color` (White)
- Border radius: `--br-100` (4px) to `--br-200` (8px)
- Alignment: center

**States:**
- Default: background `--surface-primary-default` (Papaya/500)
- Hover: background `--surface-primary-default-hover` (Papaya/600)
- Disabled: background `--surface-disabled-disabled` (Grey/200), text `--text-disabled-on-color` (Grey/500)
- Loading: show spinner, maintain button dimensions

#### 3.4.2 Secondary CTA Button

**Purpose:** Secondary action. "Save for Later", "Share Configuration", "Download Spec Sheet".

**Properties:**
- Same dimensions as Primary CTA
- Background: `--surface-default` (White)
- Border: 1px `--border-primary-default` (Papaya/500)
- Text color: `--text-primary-default` (Papaya/500)

**States:**
- Hover: background `--surface-primary-default-subtle` (Papaya/100)

#### 3.4.3 Price Display

**Purpose:** Shows the product price, which may update dynamically as selections change.

**Variants:**
- **Simple price:** Just the total. `H5/Bold` (24px, 700)
- **Price with original:** Strikethrough original + sale price. Original in `body/Regular` with line-through and `--text-disabled-default`, sale in `H5/Bold` and `--text-default-heading`
- **Price with modifier:** Base price + "+$X" for upgrades. Modifier in `small/Regular`, `--text-default-caption`
- **"Total:" label + price:** Label in `body/Regular` `--text-default-body`, price right-aligned in `H5/Bold`

**Positioning:** Either in the Product Title Block (near the top) or directly above the CTA button (near the bottom). If price updates dynamically, it should be near the CTA so the user sees the impact of their choices next to the action.

#### 3.4.4 Trust Badges / Value Props

**Purpose:** Small icon + text blocks that build purchase confidence. "Free Shipping", "30 Day Returns", "Guarantee Safe Checkout".

**Properties:**
- Layout: horizontal row of 2 to 3 items, or stacked vertically
- Each badge: icon (24px to 40px) + text below or beside
- Text: `caption/Regular` (12px) or `small/Regular` (14px), `--text-default-body`
- Icon color: `--icons-primary-default` (Papaya/500) or brand-neutral dark

---

## 4. Responsive Behavior

This section is the definitive guide for how every configurator adapts across screen sizes. Since the Figma references are primarily desktop layouts, the tablet and mobile behaviors defined here are the canonical rules Claude Code must follow.

### 4.1 Breakpoints

Following PDS responsive modes with an additional intermediate breakpoint for configurator-specific needs:

| Breakpoint | Width | CSS Media Query | Label |
|------------|-------|-----------------|-------|
| Desktop Large | 1440px and above | `@media (min-width: 1440px)` | `--bp-desktop-lg` |
| Desktop | 1024px to 1439px | `@media (min-width: 1024px) and (max-width: 1439px)` | `--bp-desktop` |
| Tablet | 768px to 1023px | `@media (min-width: 768px) and (max-width: 1023px)` | `--bp-tablet` |
| Mobile Large | 440px to 767px | `@media (min-width: 440px) and (max-width: 767px)` | `--bp-mobile-lg` |
| Mobile | below 440px | `@media (max-width: 439px)` | `--bp-mobile` |

**CSS implementation approach:** Mobile-first. Write base styles for mobile, then layer up with min-width media queries.

```css
/* Base: mobile */
.configurator { flex-direction: column; }

/* Tablet and up */
@media (min-width: 768px) { .configurator { flex-direction: row; } }

/* Desktop and up */
@media (min-width: 1024px) { .configurator { max-width: 1440px; } }
```

### 4.2 Layout Transformations by Archetype

Each archetype has specific rules for how it transforms across breakpoints. These are not suggestions; Claude Code must implement these exactly.

---

#### 4.2.1 SBS-LR (Side-by-Side: Preview Left, Panel Right)

**Desktop Large (1440px+):**
```
┌──────────── 60% ────────────┬────── 40% ──────┐
│      Visual Zone             │  Control Zone    │
│      (preview + thumbs)      │  (scrollable)    │
│                              │                  │
│      min-height: 600px       │  max-width: 520px│
└──────────────────────────────┴──────────────────┘
```
- Gap between zones: `--s-200` (8px)
- Control Zone has internal padding `--s-600` (24px)
- Thumbnails: horizontal strip below preview

**Desktop (1024px to 1439px):**
- Same layout, proportions shift to 58% / 42%
- Control Zone min-width: 360px
- If control zone would go below 360px, switch to 55% / 45%

**Tablet (768px to 1023px):**
```
┌──────── 50% ────────┬────── 50% ──────┐
│   Visual Zone        │  Control Zone    │
│                      │                  │
│   min-height: 400px  │                  │
└──────────────────────┴──────────────────┘
```
- Proportions: 50/50 or 55/45
- Control Zone padding reduces to `--s-400` (16px)
- Thumbnails: horizontal strip, max 4 visible, scroll for rest
- Option swatches: reduce to S or M size if needed
- Product title: if using H4, stays at 32px (same as desktop per PDS)

**Mobile Large (440px to 767px):**
Transforms to VSTACK:
```
┌────────────────────────┐
│     Visual Zone         │
│     height: 300px       │
│     (aspect-ratio: 4/3) │
├────────────────────────┤
│  Thumbnail Strip        │
│  (horizontal scroll)    │
├────────────────────────┤
│  Product Title Block    │
├────────────────────────┤
│  [Option Group 1]       │
│  [Option Group 2]       │
│  [Option Group 3]       │
├────────────────────────┤
│  [ CTA - sticky ]       │
└────────────────────────┘
```
- Visual Zone: fixed height 280px to 320px, or aspect-ratio 4:3 with max-height 350px
- Thumbnails: horizontal scroll strip, thumbnail size reduces to 70px to 80px height
- Content padding: `--s-400` (16px) on sides
- All option groups default to accordion/collapsed state (only header visible)
- CTA button: sticky to viewport bottom with background `--surface-default`, padding `--s-400` (16px), shadow 0 -2px 8px rgba(0,0,0,0.06)

**Mobile (below 440px):**
- Same as Mobile Large but:
- Visual Zone height: 240px to 280px
- Content padding: `--s-300` (12px) on sides
- Swatch sizes reduce by one step (M becomes S, L becomes M)
- Product title: if using H4, drops to 28px per PDS mobile rules
- Card selectors: always full-width stacked, never grid

---

#### 4.2.2 SBS-RL (Side-by-Side: Panel Left, Preview Right)

Same responsive rules as SBS-LR but mirrored. On mobile, the stacking order changes:

**Mobile stack order (top to bottom):**
1. Visual Zone (product image is still hero on mobile, even though panel was left on desktop)
2. Thumbnail Strip
3. Product Title Block
4. Option Groups
5. CTA (sticky)

**Rationale:** On mobile, users need to see the product before configuring it, regardless of desktop panel position. The visual always comes first in vertical stacking.

---

#### 4.2.3 TC (Three-Column Layout)

**Desktop Large (1440px+):**
```
┌──── 25% ────┬──────── 50% ────────┬──── 25% ────┐
│ Product Info │    Visual Zone      │ Config Panel │
└──────────────┴─────────────────────┴──────────────┘
```

**Desktop (1024px to 1439px):**
- Proportions shift to 28% / 44% / 28%
- Info column min-width: 240px

**Tablet (768px to 1023px):**
Collapses to two columns. Product info merges above the config panel:
```
┌──────── 55% ────────┬────── 45% ──────┐
│   Visual Zone        │  Product Info    │
│                      │  (condensed)     │
│                      │  ─────────────   │
│                      │  Config Panel    │
└──────────────────────┴──────────────────┘
```
- Product Info shows as a collapsed section above Config Panel
- Description truncated with "Read more" expand

**Mobile (below 768px):**
Full VSTACK:
1. Visual Zone
2. Product Info (title, price, rating visible; description behind "Read more")
3. Specs table (condensed to 2-column key-value)
4. Option Groups
5. CTA (sticky)

---

#### 4.2.4 FW-BP (Full-Width Preview with Bottom Panel)

**Desktop Large (1440px+):**
```
┌──────────────────────────────────────────────┐
│              Visual Zone (70%)                │
│                                              │
├──────────────────────────────────────────────┤
│  [Tab Bar]                                   │
│  [────] [────] [────] [────] [────] [────]   │
│  Option items in horizontal row (30%)        │
└──────────────────────────────────────────────┘
```
- Bottom panel: fixed height 180px to 250px
- Option items: horizontal row with horizontal scroll
- Tab bar height: 48px

**Desktop (1024px to 1439px):**
- Same layout
- Bottom panel may show fewer items visible (5 to 6 instead of 8 to 9)

**Tablet (768px to 1023px):**
- Same layout
- Bottom panel height: 160px to 200px
- Option item size reduces by one step
- 3 to 4 items visible, rest scroll

**Mobile (below 768px):**
Transforms to vertical with horizontal scrolling options:
```
┌────────────────────────┐
│     Visual Zone         │
│     height: 55vh        │
├────────────────────────┤
│  [Tab 1] [Tab 2] [Tab3]│
├────────────────────────┤
│  ┌────┐ ┌────┐ ┌────┐ → (horizontal scroll)
│  └────┘ └────┘ └────┘  │
├────────────────────────┤
│  [ CTA - sticky ]       │
└────────────────────────┘
```
- Visual Zone: 50% to 60% of viewport height
- Tab bar: horizontally scrollable if tabs exceed width
- Options: single horizontal scroll row, item size M or S
- Swipe gesture hint: slight peek of next item (show ~20px of the next off-screen item)

---

#### 4.2.5 FW-OP (Full-Width Preview with Overlay Panel)

**Desktop (all sizes):**
- Full-screen preview with overlay panel
- Overlay: slides in from right, 400px to 500px wide, 100% height
- Background dim: rgba(0,0,0,0.3) on the preview behind the overlay

**Tablet (768px to 1023px):**
- Overlay width: 360px to 420px
- Same slide-in behavior

**Mobile (below 768px):**
- Overlay becomes a bottom sheet that slides up from the bottom
- Bottom sheet: 70% to 85% of viewport height
- Drag handle at top (40px wide, 4px tall, Grey/300, centered)
- Sheet has border-radius `--br-200` (8px) on top corners only
- Content inside the sheet scrolls vertically
- Background dim on the preview above the sheet

**Bottom sheet behavior:**
- Initial state: collapsed to 40% of viewport (showing first option group header)
- Drag up: expands to 85% of viewport
- Drag down: collapses back
- Snap points: 40%, 70%, 85% of viewport height

---

#### 4.2.6 BUILD (Builder / Compositor)

**Desktop (all sizes):**
```
┌──── 30-35% ────┬─────── 65-70% ───────┐
│  Catalog Panel  │   Assembly Canvas     │
│  (scrollable)   │   (interactive)       │
└─────────────────┴──────────────────────┘
```

**Tablet (768px to 1023px):**
- Catalog panel narrows to 280px fixed
- Canvas takes remaining space
- Component cards in catalog: 1-up column instead of 2-up grid
- Canvas manipulation controls: reduce to icon-only (hide labels)

**Mobile (below 768px):**
Major restructure:
```
┌────────────────────────┐
│    Assembly Canvas      │
│    height: 50vh         │
│    (pinch-zoom enabled) │
├────────────────────────┤
│  [Build] [Style] tabs   │
├────────────────────────┤
│  Component Catalog      │
│  (2-up grid, scroll)    │
│                         │
├────────────────────────┤
│  [ CTA - sticky ]       │
└────────────────────────┘
```
- Canvas on top, catalog below
- Tabs for switching between Build and Style modes
- Component catalog: 2-up grid, scrollable
- Canvas actions (move, duplicate, delete) become a floating toolbar above the canvas: horizontal row of icon buttons, centered, with semi-transparent background
- Piece selection: tap piece in catalog, then tap placement on canvas (instead of drag-and-drop, which is unreliable on mobile)

---

#### 4.2.7 COMPACT (Embedded Widget)

**Desktop / Tablet (768px+):**
Horizontal layout as defined in Section 2.7.

**Mobile (below 768px):**
Switches to vertical stack:
```
┌────────────────────────┐
│  Product Title          │
│  [Compact Options]      │
├────────────────────────┤
│  Visual Zone            │
│  (aspect-ratio: 1/1     │
│   or 4:3, max 300px)    │
├────────────────────────┤
│  [More Options]         │
│  [ CTA ]                │
└────────────────────────┘
```
- Total max-height: 600px on mobile (widget should not dominate the page)
- Padding: `--s-300` (12px)
- CTA: full-width, height 40px (smaller than standalone configurator CTA)

---

#### 4.2.8 VSTACK (Vertical Stack / Mobile Native)

This is the mobile target layout. No transformation needed. However, size adjustments apply:

**Mobile Large (440px to 767px):**
- Content padding: `--s-400` (16px)
- Visual Zone: aspect-ratio 4:3, max-height 350px
- Option groups: full-width, accordion collapsed by default

**Mobile (below 440px):**
- Content padding: `--s-300` (12px)
- Visual Zone: aspect-ratio 4:3, max-height 280px
- Typography: product title uses H5 instead of H4
- Swatches: reduce to S size
- CTA height: 48px (not 56px)

---

#### 4.2.9 SPLIT (Split-Screen Immersive)

**Desktop (all sizes):**
50/50 split as defined.

**Tablet (768px to 1023px):**
- Shifts to 45% visual / 55% control (control needs more room at narrower widths)

**Mobile (below 768px):**
Full VSTACK with the visual zone using a carousel/swipe for angles:
```
┌────────────────────────┐
│     Visual Zone         │
│     (carousel swipe)    │
│     ● ● ● ○ ○          │
├────────────────────────┤
│  Product Title          │
│  Description            │
│  [Option Groups]        │
│  [ CTA - sticky ]       │
└────────────────────────┘
```
- No thumbnail strip; replaced by carousel dots
- Swipe left/right to change angle/view

---

#### 4.2.10 WIZARD (Guided / Stepped)

**Desktop (all sizes):**
```
┌──────────────────────────────────────────────┐
│  ● Step 1 ── ○ Step 2 ── ○ Step 3 ── ○ Done │
├───────────── 60% ───────┬────── 40% ─────────┤
│    Visual Zone           │  Current Step      │
│                          │  Options            │
│                          │  [Back] [Next]      │
└──────────────────────────┴────────────────────┘
```

**Tablet (768px to 1023px):**
- Same layout, 55/45 proportions
- Stepper labels may truncate or show step numbers only

**Mobile (below 768px):**
```
┌────────────────────────┐
│  ● ─ ○ ─ ○ ─ ○ ─ ○    │  ← Compact stepper (dots/numbers only)
├────────────────────────┤
│     Visual Zone         │
│     height: 240px       │
├────────────────────────┤
│  Step Title             │
│  Step Description       │
│                         │
│  [Options for step]     │
│                         │
├────────────────────────┤
│  [Back]      [Next]     │  ← Sticky footer, side-by-side buttons
└────────────────────────┘
```
- Stepper: compact dot or number indicators, no text labels
- Back button: secondary style, 48% width
- Next button: primary style, 48% width
- Both sticky at bottom

---

### 4.3 Component-Level Responsive Rules

These rules apply to individual components regardless of which archetype they sit inside.

#### 4.3.1 Thumbnail Strip

| Breakpoint | Thumbnail Height | Max Visible | Behavior |
|------------|-----------------|-------------|----------|
| Desktop Large | 90px to 120px | 6 to 8 | Show all or scroll |
| Desktop | 80px to 100px | 5 to 7 | Scroll if overflow |
| Tablet | 70px to 90px | 4 to 5 | Scroll |
| Mobile | 60px to 80px | 3 to 4 | Scroll with peek |

**Vertical thumbnails** (used in some SBS layouts):
- Desktop only. On tablet and below, vertical thumbnails convert to horizontal strip below the preview.

#### 4.3.2 Image Swatches

| Breakpoint | XS | S | M | L | XL |
|------------|-----|-----|-----|-----|------|
| Desktop Large | 42px | 58px | 75px | 90px | 120px+ |
| Desktop | 42px | 56px | 72px | 86px | 114px |
| Tablet | 38px | 52px | 68px | 80px | 100px |
| Mobile | 36px | 48px | 60px | 72px | 90px |

**Grid columns per breakpoint (when in Control Zone):**

| Control Zone Width | Swatch Size S | Swatch Size M | Swatch Size L |
|-------------------|--------------|--------------|--------------|
| 480px+ | 6 to 8 per row | 5 to 6 per row | 3 to 4 per row |
| 360px to 479px | 5 to 6 per row | 4 to 5 per row | 3 per row |
| 300px to 359px | 4 to 5 per row | 3 to 4 per row | 2 per row |
| Below 300px | 4 per row | 3 per row | 2 per row |

#### 4.3.3 Color Swatches

| Breakpoint | S | M | L |
|------------|-----|-----|-----|
| Desktop | 22px | 35px | 48px |
| Tablet | 22px | 33px | 44px |
| Mobile | 24px* | 35px* | 44px |

*Mobile sizes have a minimum of 24px visible + padding to achieve 44px tap target

#### 4.3.4 Text Pills

| Breakpoint | Height (S) | Height (M) | Height (L) |
|------------|-----------|-----------|-----------|
| Desktop | 26px | 40px | 50px |
| Tablet | 26px | 36px | 44px |
| Mobile | 32px* | 40px* | 44px |

*Mobile sizes increase minimums to ensure 44px tap targets. A 26px pill gets invisible padding to reach 44px, or the visible size increases.

**Layout shift on mobile:**
- If 3 or fewer pills: display as equal-width row (each pill takes 1/n width)
- If 4 to 6 pills: 2-up or 3-up grid
- If 7+ pills: switch to dropdown selector automatically

#### 4.3.5 Card Selectors

| Breakpoint | Grid Columns | Card Min-Width |
|------------|-------------|----------------|
| Desktop | 2-up or 3-up | 150px |
| Tablet | 2-up | 140px |
| Mobile | 1-up (stacked) or 2-up | Full-width or 140px |

On mobile, if cards contain complex content (image + title + subtitle + price), always use 1-up stacked layout.

#### 4.3.6 Dropdown Selectors

| Breakpoint | Height | Behavior |
|------------|--------|----------|
| Desktop | 44px | Custom styled dropdown panel |
| Tablet | 44px | Custom styled dropdown panel |
| Mobile | 48px | Can use native `<select>` for better UX (configurable per requirement) |

**Mobile native select option:** When using native select on mobile, Claude Code should render a styled container that mimics the dropdown appearance but uses a native `<select>` element underneath for the actual interaction. This gives the user the native OS picker (scroll wheel on iOS, bottom sheet on Android).

#### 4.3.7 Accordion Row Selectors

| Breakpoint | Collapsed Height | Behavior |
|------------|-----------------|----------|
| Desktop | 56px to 60px | Click to expand, multiple can be open |
| Tablet | 52px to 56px | Click to expand, multiple can be open |
| Mobile | 52px | Click to expand, only one open at a time (auto-close others) |

**Mobile auto-close rationale:** On small screens, multiple open accordions would push content far below the fold. Auto-closing keeps the interface manageable.

#### 4.3.8 CTA Button

| Breakpoint | Height | Width | Position |
|------------|--------|-------|----------|
| Desktop | 48px to 56px | 100% of Control Zone | Inline at bottom of Control Zone |
| Tablet | 44px to 52px | 100% of Control Zone | Inline at bottom of Control Zone |
| Mobile | 48px to 52px | 100% minus 2x side padding | Sticky at viewport bottom |

**Sticky CTA on mobile:**
```css
.cta-wrapper--mobile {
  position: sticky;
  bottom: 0;
  left: 0;
  right: 0;
  background: var(--surface-default);
  padding: var(--s-300) var(--s-400);
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.06);
  z-index: 100;
}
```

If price display is tied to the CTA, the sticky footer includes both:
```
┌────────────────────────────────────┐
│  Total: $360.00    [ Add to Cart ] │
└────────────────────────────────────┘
```
- Price: left-aligned, `body/SemiBold`
- CTA: right-aligned, takes ~60% width
- Or: price on top row, CTA full-width on bottom row (when price text is long)

#### 4.3.9 Action Icons

| Breakpoint | Size | Positioning |
|------------|------|-------------|
| Desktop | 36px | Overlaid on preview corners |
| Tablet | 36px | Overlaid on preview corners |
| Mobile | 32px | Top-right horizontal row, or hidden behind a "..." overflow menu |

**Mobile overflow menu:** If there are 4+ action icons, collapse them into a single icon button that opens a small popover with the actions listed vertically.

---

### 4.4 Typography Scaling

Per PDS responsive modes:

| Token | Desktop / Tablet | Mobile (below 440px) |
|-------|-----------------|---------------------|
| H1 | 60px / 72px LH | 48px / 56px LH |
| H2 | 48px / 56px LH | 40px / 48px LH |
| H3 | 40px / 48px LH | 32px / 40px LH |
| H4 | 32px / 40px LH | 28px / 32px LH |
| H5 | 24px / 28px LH | 24px / 28px LH (no change) |
| H6 | 20px / 24px LH | 20px / 24px LH (no change) |
| body-lg | 20px / 24px LH | 20px / 24px LH (no change) |
| body | 16px / 20px LH | 16px / 20px LH (no change) |
| small | 14px / 16px LH | 14px / 16px LH (no change) |
| caption | 12px / 16px LH | 12px / 16px LH (no change) |

**Practical impact on configurators:** Since product titles typically use H4 or H5, and option labels use small or caption, the only significant change is the product title shrinking from 32px to 28px on mobile. Everything else stays the same.

**Recommendation for Claude Code:** Use H5 (24px) for product titles in compact/embedded widgets, and H4 (32px) for standalone/full-page configurators. This minimizes mobile-only typography shifts.

---

### 4.5 Touch Target and Interaction Rules

#### 4.5.1 Minimum Tap Targets

All interactive elements on touch devices (tablet and mobile) must have a minimum tap target of **44px x 44px** per WCAG 2.5.5. This applies even if the visible element is smaller.

**Implementation approach for small elements:**
```css
/* Visible swatch is 24px, tap target is 44px */
.color-swatch {
  width: 24px;
  height: 24px;
  position: relative;
}
.color-swatch::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 44px;
  height: 44px;
}
```

#### 4.5.2 Hover vs. Touch States

- **Desktop:** show hover states on mouseover
- **Touch devices:** no hover states. Use `:active` for press feedback instead.
- Claude Code should use `@media (hover: hover)` to gate hover styles:
```css
@media (hover: hover) {
  .swatch:hover { border-color: var(--border-primary-default-subtle-hover); }
}
.swatch:active { transform: scale(0.96); }
```

#### 4.5.3 Swipe Gestures (Mobile)

- **Thumbnail strip:** horizontal swipe to scroll
- **Carousel/preview area:** horizontal swipe to change angle/view (when no thumbnail strip is present)
- **Bottom sheet overlay:** vertical swipe to expand/collapse
- **Option rows in FW-BP bottom panel:** horizontal swipe to scroll

Claude Code should implement swipe with CSS `scroll-snap` where possible:
```css
.thumbnail-strip {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}
.thumbnail-strip::-webkit-scrollbar { display: none; }
.thumbnail-strip .thumb { scroll-snap-align: start; }
```

#### 4.5.4 Scroll Behavior

- **Control Zone (SBS layouts, desktop):** Independent vertical scroll within the Control Zone. The Visual Zone stays fixed in viewport while Control Zone scrolls. Implement with CSS `position: sticky` on the Visual Zone or `overflow-y: auto` on the Control Zone.
- **VSTACK (mobile):** The entire page scrolls naturally. No independent scroll zones except the sticky CTA.
- **Scroll restoration:** When the user makes a selection that updates options below, do not scroll the user back to the top. Maintain scroll position.

#### 4.5.5 Orientation Handling

- **Portrait (default):** All mobile layouts are designed for portrait
- **Landscape on mobile:** If viewport height drops below 400px (landscape phone), the configurator should:
  - Switch to a compact horizontal layout (preview left 50%, options right 50%)
  - Reduce visual zone to fit available height
  - CTA becomes inline instead of sticky (not enough vertical space for sticky)
- **Landscape on tablet:** Treat as desktop layout

---

### 4.6 Responsive Spacing Adjustments

| Token | Desktop | Tablet | Mobile |
|-------|---------|--------|--------|
| Configurator outer padding | `--s-600` (24px) to `--s-1000` (40px) | `--s-400` (16px) to `--s-600` (24px) | `--s-300` (12px) to `--s-400` (16px) |
| Zone gap (between Visual and Control) | `--s-200` (8px) to `--s-400` (16px) | `--s-200` (8px) | 0px (zones stack with no gap) |
| Control Zone internal padding | `--s-600` (24px) | `--s-400` (16px) | `--s-400` (16px) |
| Between option groups | `--s-600` (24px) | `--s-500` (20px) | `--s-500` (20px) |
| Between option items | `--s-300` (12px) | `--s-200` (8px) | `--s-200` (8px) |
| CTA margin top | `--s-800` (32px) | `--s-600` (24px) | N/A (sticky, has own padding) |

---

### 4.7 Image Handling Across Breakpoints

#### 4.7.1 Image Sizing Strategy

Claude Code should use `<picture>` elements or `srcset` when actual product images are provided, to serve appropriately sized images per breakpoint.

| Breakpoint | Recommended Max Image Width | Quality |
|------------|---------------------------|---------|
| Desktop Large | 1200px | High |
| Desktop | 900px | High |
| Tablet | 700px | Medium |
| Mobile | 500px | Medium |

If only a single image URL is provided in the requirement, use it at all sizes with CSS `object-fit: contain` and `max-width: 100%`.

#### 4.7.2 Placeholder Images

When no images are provided, Claude Code generates placeholder containers:
```css
.preview-placeholder {
  background: var(--surface-page-secondary);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-default-placeholder);
  font: var(--body-regular); /* 16px, 400 */
}
```
Content: "Product Image" or the product name centered.

#### 4.7.3 Image Transition on Selection Change

When a user selection triggers an image swap:
- Crossfade transition: 200ms to 300ms ease-in-out
- During loading: show a subtle pulse animation on the placeholder or maintain the previous image until the new one is loaded
- On mobile with slower connections: show a thin loading bar at the top of the Visual Zone (Papaya/500 color, 3px height)

---

## 5. Spacing, Z-Index, and Transition Reference

### 5.1 Outer Container

- Configurator outer padding: See Section 4.6 for responsive values
- When embedded: padding may be reduced to `--s-200` (8px) or eliminated entirely
- Max width: depends on archetype, but typically 1440px for full-page configurators
- Background: `--surface-page` (White) or `--surface-page-secondary` (Grey/50) for contrast against a white page

### 5.2 Internal Spacing Reference (Desktop Defaults)

These are the base desktop values. For tablet and mobile adjustments, see Section 4.6.

| Context | Token | Value |
|---------|-------|-------|
| Gap between Visual Zone and Control Zone | `--s-200` (8px) to `--s-400` (16px) | Clean separation |
| Control Zone internal padding | `--s-600` (24px) | Breathing room |
| Between product title and first option group | `--s-600` (24px) to `--s-800` (32px) | Clear hierarchy break |
| Between option groups | `--s-600` (24px) | Distinct sections |
| Between option group header and options | `--s-300` (12px) to `--s-400` (16px) | Related content |
| Between individual option items | `--s-200` (8px) to `--s-300` (12px) | Tight grouping |
| CTA button margin top | `--s-600` (24px) to `--s-800` (32px) | Visual importance |

### 5.3 Border and Divider Reference

| Context | Style |
|---------|-------|
| Between option groups | 1px solid `--border-default` (Grey/50) |
| Control Zone outer border (if card-style) | 1px solid `--border-default` (Grey/50), radius `--br-200` |
| Preview area border | 1px solid `--border-default` (Grey/50), radius `--br-200` |
| Selected state border | 2px solid `--border-primary-default` (Papaya/500) |
| Focus state border/ring | 2px solid `--border-primary-focus` (Papaya/500) |

### 5.4 Z-Index Hierarchy

Claude Code must use this z-index scale consistently across all configurators. No arbitrary z-index values allowed.

| Layer | Z-Index | Usage |
|-------|---------|-------|
| Base content | 0 | Visual Zone, Control Zone, option groups |
| Action icons overlay | 10 | Expand, AR, share, download buttons on preview |
| Thumbnail navigation arrows | 15 | Left/right scroll arrows on thumbnail strip |
| Dropdown panel | 50 | Custom dropdown option list when open |
| Floating toolbar (BUILD mobile) | 60 | Canvas manipulation controls on mobile |
| Sticky CTA | 100 | Mobile sticky footer with CTA button |
| Overlay backdrop | 200 | Background dim for FW-OP and modal overlays |
| Overlay panel / bottom sheet | 210 | The configuration overlay or bottom sheet itself |
| Fullscreen preview | 300 | When user clicks expand/fullscreen on preview |

```css
:root {
  --z-base: 0;
  --z-action-icons: 10;
  --z-thumb-nav: 15;
  --z-dropdown: 50;
  --z-floating-toolbar: 60;
  --z-sticky-cta: 100;
  --z-overlay-backdrop: 200;
  --z-overlay-panel: 210;
  --z-fullscreen: 300;
}
```

### 5.5 Transition and Animation Reference

All transitions must be consistent across the configurator. Claude Code must use these values, not ad hoc timing.

| Transition | Duration | Easing | CSS |
|-----------|----------|--------|-----|
| Hover state (border, background) | 150ms | ease-out | `transition: border-color 150ms ease-out, background-color 150ms ease-out` |
| Selection state change | 150ms | ease-out | `transition: border-color 150ms ease-out` |
| Image crossfade | 250ms | ease-in-out | `transition: opacity 250ms ease-in-out` |
| Accordion expand/collapse | 200ms | ease-out | `transition: height 200ms ease-out, opacity 200ms ease-out` |
| Overlay slide-in (desktop) | 300ms | cubic-bezier(0.32, 0.72, 0, 1) | `transition: transform 300ms cubic-bezier(0.32, 0.72, 0, 1)` |
| Bottom sheet (mobile) | 300ms | cubic-bezier(0.32, 0.72, 0, 1) | `transition: transform 300ms cubic-bezier(0.32, 0.72, 0, 1)` |
| Swatch hover scale | 150ms | ease-out | `transition: transform 150ms ease-out` |
| Chevron rotation | 200ms | ease-out | `transition: transform 200ms ease-out` |
| Dropdown panel appear | 150ms | ease-out | `transition: opacity 150ms ease-out, transform 150ms ease-out` |

**Reduced motion:** All transitions must be wrapped or disabled when the user prefers reduced motion:
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }
}
```

### 5.6 CSS Root Variable Block

Claude Code must include a `:root` block at the top of every configurator's CSS. This block defines the flat set of semantic CSS variables that the configurator code references. The variable NAMES are always the same. The VALUES come from the resolved design system (see Requirement Parsing Guide, Section 3).

**When using PDS (Mode A):** Use the PDS values shown below.
**When using a client's visual identity (Mode B):** Replace values with those extracted from the client reference material. The spacing scale, z-index scale, and border width tokens always stay at PDS defaults unless the client explicitly provides alternatives.

**Important:** PDS internally uses a three-tier architecture (Brand primitives > Alias tokens > Components). This is specific to PDS. When building for a client, there are no tiers. Claude Code just populates this flat variable block directly with the extracted values. The `var()` references to primitive names (like `var(--papaya-500)`) are a PDS convenience. In client mode, just use the hex values directly.

**PDS Default Values:**

```css
:root {
  /* ===== PRIMARY ===== */
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

  /* ===== SURFACES ===== */
  --surface-default: #ffffff;
  --surface-page: #ffffff;
  --surface-page-secondary: #f6f6f6;
  --surface-default-secondary: #f6f6f6;
  --surface-disabled-disabled: #cccccc;

  /* ===== TEXT ===== */
  --text-default-heading: #1a1a1a;
  --text-default-body: #4d4d4d;
  --text-default-caption: #4d4d4d;
  --text-default-placeholder: #7f7f7f;
  --text-on-color-heading: #ffffff;
  --text-on-color-body: #ffffff;
  --text-on-color-caption: #f6f6f6;
  --text-disabled-default: #999999;
  --text-disabled-on-color: #7f7f7f;

  /* ===== BORDERS ===== */
  --border-default: #f6f6f6;
  --border-default-secondary: #e5e5e5;
  --border-disabled-disabled: #cccccc;

  /* ===== ICONS ===== */
  --icons-disabled-default: #999999;
  --icons-disabled-on-color: #7f7f7f;

  /* ===== STATUS COLORS ===== */
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

  /* ===== BORDER RADIUS ===== */
  --br-100: 4px;
  --br-200: 8px;

  /* ===== BORDER WIDTH ===== */
  --bw-25: 1px;
  --bw-100: 4px;

  /* ===== SPACING (always PDS unless client overrides) ===== */
  --s-100: 4px;
  --s-200: 8px;
  --s-300: 12px;
  --s-400: 16px;
  --s-500: 20px;
  --s-600: 24px;
  --s-700: 28px;
  --s-800: 32px;
  --s-900: 36px;
  --s-1000: 40px;
  --s-1100: 48px;
  --s-1200: 56px;
  --s-1300: 64px;
  --s-1400: 72px;

  /* ===== Z-INDEX (always PDS) ===== */
  --z-base: 0;
  --z-action-icons: 10;
  --z-thumb-nav: 15;
  --z-dropdown: 50;
  --z-floating-toolbar: 60;
  --z-sticky-cta: 100;
  --z-overlay-backdrop: 200;
  --z-overlay-panel: 210;
  --z-fullscreen: 300;

  /* ===== TYPOGRAPHY ===== */
  --font-primary: 'PP Neue Montreal', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

**In Client Mode (Mode B), this same block would look like:**

```css
:root {
  /* Values extracted from client's website/brand */
  --surface-primary-default: #2b5c8a;          /* from their button color */
  --surface-primary-default-hover: #1e4a73;    /* derived: 12% darker */
  --surface-primary-default-subtle: #e8f0f8;   /* derived: HSL lightness 95% */
  --surface-primary-default-subtle-hover: #d1e1f0; /* derived: HSL lightness 88% */
  --text-primary-default: #2b5c8a;
  /* ... all other variables populated with extracted/derived values ... */
  /* Spacing, z-index, border-width remain identical to PDS */
}
```

See the Requirement Parsing Guide, Section 3 for the complete design system extraction and derivation workflow.

---

## 6. State Management Principles

These are behavioral rules Claude Code must follow when generating configurator logic.

### 6.1 Selection State

- Every option group must have a default selected value (the first option, or specified in the requirement)
- Only one option can be selected per group at a time (single-select by default)
- Multi-select is an exception and must be explicitly stated in the requirement
- Selection must be visually immediate (no loading delay for the UI state change)
- Product preview should update after selection (may involve image swap or rerender)

### 6.2 Price Calculation

- If options have price modifiers, the total price must update in real-time
- Base price + sum of all selected option modifiers = total displayed price
- Price modifiers can be absolute (+$29.00) or descriptive ("Included")
- Format: locale-appropriate currency with two decimal places

### 6.3 Dependent Options

- Some options may depend on others (e.g., available fabrics change based on selected product type)
- When a parent option changes, dependent option groups must reset to their default or show only valid children
- If a previously selected child option is no longer valid, auto-select the first valid option and indicate the change

### 6.4 Image/Preview Updates

- Each unique combination of selections should map to a preview image or image set
- If exact combinations are not available, fall back to the closest matching image
- Image swap should use a crossfade transition (200ms to 300ms) not an abrupt replacement
- Thumbnails in the strip should also update if they are combination-dependent

---

## 7. Accessibility Requirements

- All interactive elements must be keyboard navigable (Tab, Arrow keys, Enter, Space)
- Swatch selections must have aria-label describing the option (e.g., "Select Walnut finish")
- Selected state must use aria-selected="true"
- Color swatches must not rely on color alone; use labels, patterns, or icons to distinguish
- Contrast ratio for text on backgrounds must meet WCAG 2.1 AA (4.5:1 for normal text, 3:1 for large text)
- Focus indicators must be visible: 2px `--border-primary-focus` (Papaya/500) ring
- Dropdown selectors must be operable with keyboard
- Reduced motion preference: skip transitions when prefers-reduced-motion is set

---

## 8. Technology and Output Format

- **Output:** Single-file HTML + CSS + JavaScript (default), or React JSX component if specified
- **CSS approach:** CSS custom properties (variables) mapped from PDS tokens
- **No external CSS frameworks.** All styling must use PDS tokens via custom properties
- **Font:** PP Neue Montreal. Fall back to system sans-serif if the font is not available. Claude Code should include a font import or assume the font is available in the host environment
- **Images:** Placeholder images using grey rectangles with dimensions labeled, or actual image URLs if provided in the requirement document
- **Interactivity:** Vanilla JavaScript for option selection, price updates, image swaps. No jQuery or heavy frameworks unless the requirement specifies React

---

## 9. Decision Tree for Claude Code

When Claude Code receives a requirement, it should follow this decision process:

```
1. Read the requirement document

2. Check for explicit layout or context constraints FIRST:
   ├── Requirement says "embed" or "widget" or "PDP integration" → COMPACT
   ├── Requirement says "mobile only" or "mobile app" → VSTACK
   ├── Product is modular / assembled from pieces → BUILD
   ├── Requirement says "luxury", "immersive", or "premium feel" → SPLIT
   ├── Requirement says "step-by-step" or has 8+ sequential categories → WIZARD
   └── None of the above → Continue to step 3

3. Count the number of option groups:
   ├── 1-3 option groups:
   │   ├── Visual impact is priority → FW-BP (full-width preview, options below)
   │   ├── Overlay/minimal UI requested → FW-OP
   │   └── Standard → SBS-LR (default)
   ├── 3-6 option groups:
   │   ├── Product info / specs / description is extensive → TC (three-column)
   │   ├── Config options are the star, not the image → SBS-RL
   │   └── Standard → SBS-LR (default)
   ├── 6-10 option groups:
   │   ├── Options are independent / parallel → SBS-LR with accordion selectors
   │   └── Options are sequential / dependent → WIZARD
   └── 10+ option groups → WIZARD (strongly recommended)

4. For each option group, determine the selector type:
   ├── Solid colors (hex values, no texture) → Color Swatch (circle or rounded square)
   ├── Materials / fabrics with texture images → Image Swatch (rectangular)
   ├── Sizes / dimensions (discrete values) → Text Pill
   ├── Product variants with photos → Card Selector or Image Swatch (L/XL)
   ├── Long option lists (8+ items) → Dropdown Selector
   ├── Continuous numeric range → Slider
   ├── Quantity (integer) → Stepper
   └── Multiple categories of sub-options → Tabs + sub-selectors

5. Determine thumbnail behavior:
   ├── Multiple angle views or scene images provided → Thumbnail strip
   ├── Single product view only → No thumbnails
   └── Scene (lifestyle) + silo (product-only) views → Thumbnail strip with view type labels

6. Determine commerce elements:
   ├── Price provided in requirement → Price display + CTA button
   ├── No price information → CTA only ("Get Quote", "Share", "Save Configuration")
   ├── Price with per-option modifiers → Dynamic price calculation near CTA
   └── Multiple CTAs needed → Primary + Secondary CTA buttons

7. Generate the configurator code following:
   a. This architecture document for layout and components
   b. The PDS token document for all color, typography, and spacing values
   c. The requirement document for product-specific content and data
```

---

## 10. Loading and Error States

### 10.1 Initial Loading State

When the configurator first loads, Claude Code should implement a skeleton loading pattern rather than a blank screen or spinner.

**Skeleton layout:**
- Visual Zone: solid `--surface-page-secondary` (Grey/50) rectangle matching the preview area dimensions, with a subtle pulse animation
- Control Zone: 3 to 4 grey rounded rectangles (skeleton lines) matching where the product title and option groups will appear
- Skeleton line color: `--surface-default-secondary` (Grey/50) with pulse to `--border-default-secondary` (Grey/100)

```css
@keyframes skeleton-pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
.skeleton-block {
  background: var(--surface-default-secondary);
  border-radius: var(--br-100);
  animation: skeleton-pulse 1.5s ease-in-out infinite;
}
```

**Loading duration target:** Skeleton should display for no more than 2 seconds. If product data loads faster, transition immediately.

### 10.2 Image Loading and Failure

**While an image is loading (after a selection change):**
- Keep the previous image visible at full opacity
- Show a thin progress bar at the top of the Visual Zone: height 3px, background `--surface-primary-default` (Papaya/500), animating width from 0% to 90% over 2 seconds

**If an image fails to load:**
- Display a placeholder container with `--surface-page-secondary` background
- Show a broken-image icon (24px, `--icons-disabled-default` Grey/400) centered
- Below the icon: "Image unavailable" in `small/Regular` (14px), `--text-default-placeholder`
- Do NOT block the user from continuing to configure. The rest of the UI remains functional.

### 10.3 Empty Option Groups

If an option group has zero valid options (e.g., due to dependency filtering):
- Show the option group header with label
- Below it: "No options available for this selection" in `small/Regular`, `--text-default-placeholder`
- The group is not collapsible when empty

### 10.4 Network/Data Error

If the configurator fails to load product data entirely:
- Show a centered error state within the configurator container
- Icon: warning/error icon, 48px, `--icons-error-default` (Red/500)
- Title: "Unable to load configurator" in `H6/SemiBold`, `--text-default-heading`
- Subtitle: "Please check your connection and try again" in `body/Regular`, `--text-default-body`
- Retry button: Secondary CTA style, "Try Again"

---

## 11. Desktop Control Zone Scroll Behavior

This section clarifies how the Control Zone handles content overflow on desktop, which was underspecified in the archetype definitions.

**When the Control Zone content exceeds the viewport height (desktop/tablet only):**

**Option A: Sticky Visual Zone (recommended for SBS-LR and SBS-RL)**
The Visual Zone uses `position: sticky; top: 24px` so it stays in view while the user scrolls through options in the Control Zone. The page itself scrolls, and the Visual Zone pins in place.

```css
.visual-zone {
  position: sticky;
  top: var(--s-600); /* 24px offset from top */
  align-self: flex-start;
  height: fit-content;
}
.control-zone {
  /* Natural scroll with the page, no internal scroll */
}
```

**Option B: Internal scroll (for COMPACT and when the configurator has a fixed container height)**
The Control Zone gets `overflow-y: auto` with a faded edge indicator at the bottom to hint at scrollable content.

```css
.control-zone--scrollable {
  overflow-y: auto;
  max-height: calc(100vh - 48px); /* or the fixed container height */
  scrollbar-width: thin;
  scrollbar-color: var(--border-default-secondary) transparent;
}
```

**CTA button behavior on desktop when Control Zone scrolls:**
- The CTA button should be the last element in the Control Zone, scrolling naturally with the content.
- It should NOT be sticky on desktop. Desktop users can scroll easily, and a sticky CTA reduces space for options.
- Exception: if the requirement explicitly requests a sticky CTA on desktop, Claude Code should implement it with `position: sticky; bottom: 0` within the Control Zone container.
