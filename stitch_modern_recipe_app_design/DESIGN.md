---
name: Culinary Editorial
colors:
  surface: '#fbf8ff'
  surface-dim: '#dbd9e1'
  surface-bright: '#fbf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f2fb'
  surface-container: '#efecf5'
  surface-container-high: '#eae7ef'
  surface-container-highest: '#e4e1ea'
  on-surface: '#1b1b21'
  on-surface-variant: '#59413b'
  inverse-surface: '#303036'
  inverse-on-surface: '#f2eff8'
  outline: '#8c716a'
  outline-variant: '#e0bfb7'
  surface-tint: '#ab3513'
  primary: '#a83211'
  on-primary: '#ffffff'
  primary-container: '#ca4a28'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb4a1'
  secondary: '#376847'
  on-secondary: '#ffffff'
  secondary-container: '#b6edc2'
  on-secondary-container: '#3b6d4b'
  tertiary: '#8b4c00'
  on-tertiary: '#ffffff'
  tertiary-container: '#ae6100'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd1'
  primary-fixed-dim: '#ffb4a1'
  on-primary-fixed: '#3c0800'
  on-primary-fixed-variant: '#881f00'
  secondary-fixed: '#b9efc5'
  secondary-fixed-dim: '#9dd3aa'
  on-secondary-fixed: '#00210e'
  on-secondary-fixed-variant: '#1e5031'
  tertiary-fixed: '#ffdcc1'
  tertiary-fixed-dim: '#ffb778'
  on-tertiary-fixed: '#2e1500'
  on-tertiary-fixed-variant: '#6c3a00'
  background: '#fbf8ff'
  on-background: '#1b1b21'
  surface-variant: '#e4e1ea'
typography:
  display-lg:
    fontFamily: Playfair Display
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Playfair Display
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 38px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Playfair Display
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Playfair Display
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  headline-sm:
    fontFamily: Playfair Display
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.06em
  metric-display:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  gutter-lg: 1.5rem
  margin: 1.25rem
  margin-sm: 1rem
  margin-lg: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system channels the warmth, tactility, and intentional craft of high-end food periodicals (such as *Cook's Illustrated*, *Cereal*, and modern independent culinary journals) translated into an agile, glanceable mobile-first product. The design targets passionate home cooks, weekend gourmands, and mindful eaters who seek an antidote to utilitarian, ad-dense recipe blogs.

The aesthetic blends **Warm Editorial Minimalism** with **Tactile Utility**. Crisp card containers sit atop a grounded parchment canvas, pairing expressive, high-contrast serif typography with structured geometric sans-serif micro-copy. Visual interactions emphasize physical culinary metaphors: simmering embers, calibrated flame scales, and clean pantry checklists. The UI prioritizes visual breathing room, deliberate hierarchy, and uncompromised legibility under direct kitchen task lighting.

## Colors

The palette establishes an appetizing, organic environment without sacrificing digital clarity:

- **Primary (`#E05A36` - Paprika / Terracotta):** Represents heat, flavor, and focused action. Used for primary CTA buttons, active state toggles, interactive step progress, and high-priority indicators.
- **Secondary (`#4A7C59` - Fresh Sage):** Evokes fresh produce, herbs, and balance. Used for completed cooking steps, dietary and freshness badges, and positive validation states.
- **Tertiary (`#E58A2B` - Amber Flame):** Serves as the dynamic catalyst for culinary metrics, specifically power levels, timers, and the mid-to-high tier spectrum on the 1–10 Effort Gauge.
- **Neutral Surface Canvas (`#FAF7F2` - Warm Parchment):** Provides an organic, low-glare paper substrate that reduces eye fatigue in bright cooking environments.
- **Surface Elevation (`#FFFFFF` - Crisp White):** Distinct, bright surfaces reserved for recipe cards, action panels, and interactive components to establish layered depth.
- **Neutral Text / Charcoal (`#1E1E24`):** Softened carbon black ensuring WCAG AAA legibility for editorial titling and technical measurements without the harshness of pure black.
- **Subdued Neutral (`#787672`):** Used strictly for secondary metadata, units of measurement, and subtle border framing.

## Typography

The typographic hierarchy establishes a clear tension between editorial literary warmth and utilitarian precision:

- **Playfair Display (Display & Headlines):** Infuses titles, dish names, and narrative headnotes with culinary authority, evoking vintage cookbooks and gourmet publications. Ligatures and italic styles are deployed selectively in hero titles and chef anecdotes.
- **Plus Jakarta Sans (Body, Labels, & Numerical Values):** Provides hyper-legible, geometric stability for technical cooking execution. Numbers, ingredient quantities, timing metrics, and step-by-step methodologies rely on this face to remain clear at a distance on a countertop.
- **Metric Display:** Applied to countdown timers, portion counters, and the 1–10 effort score to ensure maximum legibility while cooking.

## Layout & Spacing

The layout is built on a 4-column fluid mobile grid scaling to an 8-column layout on tablet devices, bound by a persistent 8pt base grid rhythm:

- **Mobile Viewport (up to 599px):** Uses 4 columns with `gutter-sm` (12px) and an outer margin of `margin` (20px). Content maintains vertical stacking with comfortable touch targets (minimum 48px height) to accommodate wet or messy fingers.
- **Tablet / Expanded Kitchen Display (600px–1023px):** Shifts to an 8-column grid with `gutter` (16px) and `margin-lg` (32px). Splits the screen dynamically into dual columns: persistent ingredient checklist on the left, active step timeline and active timer widgets on the right.
- **Vertical Spacing Cadence:** Micro-separations between label and input or metric use `space-xs` (4px) or `space-sm` (8px). Sibling component cards are spaced by `space-md` (16px), while major recipe sections (Story, Ingredients, Preparation Steps) use `space-xl` (40px) to mirror editorial magazine spreads.

## Elevation & Depth

This design system avoids synthetic, dark drop shadows in favor of **Tonal Warmth and Tactile Layers**:

- **Ground Level (Base Canvas):** Set to `#FAF7F2` (Parchment). All structural content lives directly on this warm plane.
- **Layer 1 (Card & Content Blocks):** Set to `#FFFFFF` (Crisp White). Elevated solely through a subtle, warm-tinted ambient border: `1px solid rgba(30, 30, 36, 0.06)` combined with a soft, natural diffuse shadow: `0 4px 16px -2px rgba(84, 62, 45, 0.05)`.
- **Layer 2 (Floating & Interactive Controls):** Floating Bottom Navigation, Active Kitchen Timers, and Ingredient Portion Drawers employ high-diffusion elevation: `0 8px 30px -4px rgba(30, 30, 36, 0.12)`, overlaid on a semi-translucent crisp white background with a frosted lens blur (`backdrop-filter: blur(12px)` at 92% opacity).
- **Pressed & Active Feedback:** Interactive physical elements (portion steppers, checkboxes, timeline cards) eliminate their shadow and translate 1px downward with an inner tint to simulate physical depression.

## Shapes

A medium roundedness level of `2` provides an organic, approachable feel that prevents rigid clinical geometry while maintaining structural order:

- **Standard Containers (`0.5rem` / 8px):** Ingredient list rows, step card callouts, and compact parameter inputs.
- **Large Cards & Modules (`1rem` / 16px):** Primary recipe card carousels, nutrition sheets, and media containers.
- **Sheet Drawers & Timers (`1.5rem` / 24px):** Bottom modal sheets, floating notification bubbles, and cooking mode overlays.
- **Full Radius (Pill / Circular):** Category tags, Effort Gauge indicators, preparation chips, and floating navigation pills retain complete circular caps (`border-radius: 9999px`) to invite touch.

## Components

### Buttons
- **Primary Action:** Solid `#E05A36` (Paprika) fill with `#FFFFFF` text. Pill-shaped or `rounded-lg` with minimum 48px height for cooking accessibility. Bold sans-serif typography.
- **Secondary Action:** Transparent background with a `1.5px` border in `#4A7C59` (Sage) or `#1E1E24`, styled with matching colored label text.
- **Ghost Action:** No border, `#1E1E24` text with subtle hover/pressed tint using `rgba(224, 90, 54, 0.08)`.

### Chips & Metadata Tags
- **Category Pill Tags:** Pill-shaped, subtle fill `rgba(30, 30, 36, 0.04)` with `#1E1E24` text.
- **Time Breakdown Chips:** Dual-segmented pills separating Prep Time and Cook Time. A subtle divider line partitions the two, pairing icons (knife for prep, flame for cook) with concise numerical units (e.g., `15m` / `45m`).

### Effort Level Gauge (1–10 Spectrum)
- **Visual Scale:** A 10-segment segmented horizontal bar or rounded badge.
- **Tier 1–3 ("Gentle"):** Tinted in `#4A7C59` (Sage Green). Denotes pantry-friendly, minimal-technique dishes.
- **Tier 4–7 ("Moderate"):** Tinted in `#E58A2B` (Amber Flame). Denotes active pan work, multiple vessels, or medium attention.
- **Tier 8–10 ("Ambitious"):** Tinted in `#E05A36` (Deep Paprika). Denotes advanced techniques, precise timing, and multiple simultaneous components.
- Segments feature rounded pills with inactive segments filled with `rgba(30, 30, 36, 0.08)`.

### Checklist Ingredients & Portion Stepper
- **Portion Stepper:** A compact pill housing a minus icon button, dynamic serving count (e.g., "4 Servings"), and a plus icon button. Modifying this counter updates all ingredient metrics dynamically.
- **Ingredient Row:** A crisp white row card featuring an interactive custom checkbox. When tapped, the quantity and ingredient adopt a strikethrough style with opacity faded to 40%, giving clear visual feedback of gathered items.

### Instruction Timeline Cards
- **Step-by-Step Card:** Sequenced cards featuring a large, low-contrast serif numeral (e.g., "01", "02") anchored to the top-left.
- Cards feature bold technical instructions followed by expanded culinary guidance in `body-md`. Embedded timing triggers (e.g., "Simmer for 8 mins") are rendered as inline interactive pill buttons that launch the timer with a single tap.
- An organic vertical connector thread runs down the active edge, turning from light parchment tone to `#4A7C59` as steps are marked complete.

### Timer Widgets
- Floating dockable banner or card anchored at the lower viewport displaying an animated circular progress ring filled with `#E58A2B` (Flame).
- Accompanied by prominent, monospace-spaced sans-serif numerals, step attribution ("Step 3: Reducing Sauce"), and pause/cancel touch controls.

### Floating Bottom Navigation
- Suspended `margin` distance from the screen bottom, floating over the content plane.
- Composed of a frosted white pill (`backdrop-filter: blur(16px)`, `rgba(255, 255, 255, 0.92)`) with thin ambient outline and diffused drop shadow.
- Houses streamlined iconography with micro-labels, using `#E05A36` for the active culinary channel.