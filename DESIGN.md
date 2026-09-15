---
name: My RecipeBible Culinary Editorial
description: A calm, tactile culinary-journal system for focused recipe authoring.
colors:
  background: "#FAF7F2"
  surface: "#FFFDF9"
  surface-container: "#F3ECE2"
  surface-container-high: "#EAE0D4"
  on-surface: "#1B1B21"
  on-surface-variant: "#59413B"
  outline: "#6F554F"
  primary: "#A83211"
  on-primary: "#FFFFFF"
  primary-soft: "#FFDBD1"
  secondary: "#376847"
  secondary-soft: "#B9EFC5"
  tertiary: "#8B4C00"
  tertiary-soft: "#FFDCC1"
typography:
  stage-headline:
    fontFamily: "PlayfairDisplay, 'Playfair Display', Georgia, serif"
    fontSize: "26px"
    fontWeight: 600
    lineHeight: 1.23
    letterSpacing: "-0.35px"
  sheet-headline:
    fontFamily: "PlayfairDisplay, 'Playfair Display', Georgia, serif"
    fontSize: "24px"
    fontWeight: 600
    lineHeight: 1.23
    letterSpacing: "-0.35px"
  section-headline:
    fontFamily: "PlayfairDisplay, 'Playfair Display', Georgia, serif"
    fontSize: "20px"
    fontWeight: 600
    lineHeight: 1.23
    letterSpacing: "-0.35px"
  card-headline:
    fontFamily: "PlayfairDisplay, 'Playfair Display', Georgia, serif"
    fontSize: "18px"
    fontWeight: 600
    lineHeight: 1.23
    letterSpacing: "-0.35px"
  body:
    fontFamily: "PlusJakartaSans, 'Plus Jakarta Sans', Arial, sans-serif"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.35
  control:
    fontFamily: "PlusJakartaSans, 'Plus Jakarta Sans', Arial, sans-serif"
    fontSize: "14px"
    fontWeight: 700
    lineHeight: 1.35
  overline:
    fontFamily: "PlusJakartaSans, 'Plus Jakarta Sans', Arial, sans-serif"
    fontSize: "11px"
    fontWeight: 700
    lineHeight: 1.35
    letterSpacing: "0.8px"
rounded:
  field: "10px"
  action: "12px"
  module: "14px"
  full: "9999px"
spacing:
  xs: "4px"
  sm: "8px"
  compact: "10px"
  row: "12px"
  module: "14px"
  md: "16px"
  sheet: "20px"
  section: "22px"
  lg: "24px"
  outer: "28px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.control}"
    rounded: "{rounded.action}"
    padding: "0 20px"
    height: "52px"
  button-primary-disabled:
    backgroundColor: "{colors.surface-container-high}"
    textColor: "{colors.on-surface-variant}"
    typography: "{typography.control}"
    rounded: "{rounded.action}"
    padding: "0 20px"
    height: "52px"
  button-tonal:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    typography: "{typography.control}"
    rounded: "{rounded.module}"
    padding: "0 16px"
    height: "52px"
  button-outlined:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    typography: "{typography.control}"
    rounded: "{rounded.module}"
    padding: "0 16px"
    height: "52px"
  input-filled:
    backgroundColor: "{colors.surface-container}"
    textColor: "{colors.on-surface}"
    typography: "{typography.body}"
    rounded: "{rounded.field}"
    padding: "14px 16px"
    height: "52px"
  editorial-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.module}"
    padding: "16px"
  recipe-summary:
    backgroundColor: "{colors.surface-container}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.module}"
    padding: "12px"
  nutrition-row:
    backgroundColor: "{colors.surface-container}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.action}"
    padding: "10px 8px 10px 6px"
---

# Design System: My RecipeBible Culinary Editorial

## Overview

**Creative North Star: "The Calm Culinary Journal"**

The Culinary Editorial world turns structured recipe work into the feeling of composing a trusted kitchen notebook: warm, deliberate, and quietly authoritative. Parchment grounds and tonal paper modules reduce glare, while expressive serif headings give each stage a clear editorial voice. Technical content stays compact and dependable in a geometric sans serif.

The system is tactile without becoming ornamental. Burnt-red actions, restrained sage and amber semantics, generous working surfaces, and persistent navigation support people editing on a phone with divided attention. Material behavior, safe areas, keyboard avoidance, and real recipe data remain the foundation beneath the journal character.

This world is established for participating Culinary Editorial surfaces, led by the four-stage recipe editor. It does not authorize restyling unrelated legacy screens or importing unsupported concepts from visual references.

**Key Characteristics:**

- Warm parchment canvas with paper-like tonal layering.
- Playfair Display editorial hierarchy paired with Plus Jakarta Sans utility text.
- Burnt-red primary actions with sparing sage and amber semantic accents.
- Rounded rectangular controls built around 10, 12, and 14 dp corners.
- A focused, single-column authoring measure with persistent stage progress and actions.

## Colors

The palette is culinary and low-glare: paprika warmth supplies focus, sage confirms positive meaning, amber carries effort or measured emphasis, and brown-tinted neutrals make paper layers feel natural.

### Primary

- **Burnt Paprika** (`primary`): Reserve for the current progress segment, primary buttons, step numerals, focused outlines, and concise brand overlines.
- **Paprika Wash** (`primary-soft`): Use for tonal add actions and selected or supportive emphasis that should not compete with the main action.
- **Ink on Paprika** (`on-primary`): The high-contrast label and icon role on solid primary actions.

### Secondary

- **Garden Sage** (`secondary`): Positive, dietary, completed, or freshness meaning only; it is not a second general-purpose action color.
- **Sage Wash** (`secondary-soft`): A quiet container for positive or selected states.

### Tertiary

- **Toasted Amber** (`tertiary`): Effort scores and measured culinary emphasis.
- **Amber Wash** (`tertiary-soft`): A low-intensity background for tertiary semantics.

### Neutral

- **Warm Parchment** (`background`): The low-glare editor canvas and the color under system navigation areas.
- **Crisp Paper** (`surface`): Primary editable cards and content modules.
- **Flour Wash** (`surface-container`): Filled fields, summary cards, and editable list rows.
- **Pressed Clay** (`surface-container-high`): Inactive progress, disabled actions, and stronger tonal separation.
- **Editorial Ink** (`on-surface`): Headlines, field values, and essential content.
- **Cocoa Annotation** (`on-surface-variant`): Labels, metadata, icons, and secondary controls.
- **Earthen Outline** (`outline`): Restrained boundaries, dividers, and outlined actions, usually softened by opacity.

Light mode uses the frontmatter values. Dark mode remaps the same roles to plum-charcoal surfaces with warm light text; OLED mode gives only the canvas true black while preserving distinct raised surfaces. Exact dark and OLED role mappings live in `.impeccable/design.json`.

### Named Rules

**The Ember Rarity Rule.** Burnt Paprika marks focus and forward motion; do not flood large passive regions with it.

**The Semantic Pantry Rule.** Sage means positive or completed and amber means measured emphasis; neither substitutes for the primary action role.

**The OLED Ground Rule.** Only the OLED background is pure black; editable surfaces keep tonal separation instead of disappearing into the canvas.

## Typography

**Display Font:** Playfair Display (Georgia and serif fallback)

**Body Font:** Plus Jakarta Sans (Arial and sans-serif fallback)

**Character:** The pairing balances cookbook authority with practical kitchen legibility. Serif text establishes place and hierarchy; sans-serif text carries every editable, numeric, and interactive detail.

### Hierarchy

- **Stage Headline** (600, 26 sp, 1.23 line height): The single decisive title for General, Ingredients, Instructions, or Nutrition.
- **Sheet Headline** (600, 24 sp, 1.23 line height): Modal and bottom-sheet task titles.
- **Section Headline** (600, 20 sp, 1.23 line height): Named ingredient sections and major card subdivisions.
- **Card Headline** (600, 18 sp, 1.23 line height): Recipe names and compact editorial summaries.
- **Body** (400, 13 sp, 1.35 line height): Metadata, instructions, helper copy, and supporting content.
- **Control** (700, 14 sp, 1.35 line height): Primary action labels and high-emphasis controls.
- **Overline** (700, 11 sp, 0.8 sp tracking): Short uppercase identity labels and compact progress metadata.

### Named Rules

**The Two-Voice Rule.** Playfair Display speaks hierarchy; Plus Jakarta Sans does the work. Never use the serif for field values, measurements, or controls.

**The Scaling Rule.** Treat Flutter sizes as scalable text roles and allow wrapping or ellipsis where implemented; do not lock text into decorative fixed-height compositions.

## Layout

The editor is a native, vertically scrolling single-column workflow. Each stage uses a 20 dp horizontal margin, 16 dp initial top space, and 28 dp trailing scroll space inside a centered content column capped at 760 dp. Summary-to-heading separation is 22 dp; stage cards and repeated editable modules generally step in a 14–16 dp cadence.

The header keeps app identity and a four-segment, 5 dp-high progress indicator visible before the working content. The bottom action bar is safe-area aware and remains persistent; the body resizes for the IME and dismisses the keyboard on drag. Back retains a readable 92 by 52 dp footprint and the forward or save action expands into the remaining width.

At narrow row widths below 420 dp, ingredient content reflows from one dense horizontal row into a name row followed by paired amount and unit fields. Wider screens keep a compact horizontal ingredient row, but the editor itself remains centered at the 760 dp reading measure rather than stretching into a dashboard. Insets protect status, navigation, cutout, and keyboard areas.

**The One-Stage Rule.** Present one authoring stage at a time and keep the shared progress, summary, and navigation shell stable across all four stages.

**The Kitchen Reach Rule.** Interactive targets are at least 48 dp; principal controls are 52 dp high and remain reachable above system and keyboard insets.

## Elevation & Depth

Depth is a hybrid of tonal layering and restrained warm shadow. The parchment canvas, Flour Wash editable areas, and Crisp Paper cards do most of the structural work; shadows are reserved for the header, persistent action bar, and editorial cards. Light mode uses a brown-tinted ambient shadow, while dark and OLED modes strengthen a neutral-black shadow to maintain separation.

### Shadow Vocabulary

- **Editorial Card:** A soft 16 dp blur offset 4 dp downward; it lifts primary working modules without making each row float independently.
- **Anchored Header:** A shallow 10 dp blur offset 1 dp downward; it separates persistent progress from scrolling content.
- **Sticky Action Bar:** An 18 dp blur offset 4 dp upward; it marks the fixed action region above the document.

### Named Rules

**The Paper Before Shadow Rule.** Establish hierarchy with surface tone first; add elevation only to persistent chrome and complete card modules.

## Shapes

The system uses friendly rounded rectangles rather than pills for its working controls. Filled fields, thumbnails, and image actions use a compact 10 dp radius. Primary actions and nutrition rows use 12 dp. Editorial cards, recipe summaries, tonal add buttons, and section actions use 14 dp. Full rounding is reserved for the thin stage-progress segments and naturally pill-shaped chips.

Borders are quiet and contextual: filled fields are borderless at rest and gain a 1.5 dp primary focus stroke; nutrition rows use a faint outline; outlined add actions carry the more visible Earthen Outline role. Images clip to the same compact geometry as fields so media remains part of the system rather than a separate visual language.

**The Three-Corner Rule.** Default to 10 dp for fields, 12 dp for actions and rows, and 14 dp for modules; introduce another radius only for a specific native affordance.

## Components

### Buttons

- **Shape:** Confident rounded rectangles; primary and sticky actions use 12 dp corners, while full-width add actions use 14 dp.
- **Primary:** Solid Burnt Paprika with Ink on Paprika content, bold sans-serif labeling, end-aligned forward or book icon where relevant, and a 52 dp minimum height.
- **Pressed / Focus:** Use native Material feedback; keyboard focus remains visibly distinguishable, and focused fields use the primary stroke.
- **Disabled:** Replace the primary fill with Pressed Clay and retain legible muted content; busy actions may swap their icon for a compact progress indicator.
- **Tonal / Outlined:** Paprika Wash supports in-module creation. Outlined actions announce adding a whole section, step, or nutrition item without challenging the sticky primary action.

### Chips

- **Style:** Ingredient associations use compact Material chips with an ingredient icon, readable label, and removable affordance. The adjacent action chip uses a plus icon.
- **State:** Chips represent stable ingredient identity, not copied text. A single ingredient may be assigned to multiple steps and removed independently from each one.

### Cards / Containers

- **Corner Style:** Editorial cards and summaries use 14 dp corners.
- **Background:** Crisp Paper holds major working modules; Flour Wash holds recipe summaries and editable rows.
- **Shadow Strategy:** Complete editorial cards receive the low ambient lift; internal rows rely on tone and faint boundaries.
- **Internal Padding:** Standard cards use 16 dp; denser ingredient and instruction cards use 14 dp; compact summaries use 12 dp.

### Inputs / Fields

- **Style:** Flour Wash fill, Editorial Ink value, Cocoa Annotation label or hint, no resting border, and 10 dp corners.
- **Focus:** A 1.5 dp Burnt Paprika outline replaces the borderless rest state.
- **Error / Disabled:** Preserve Material validation, disabled, and semantic behavior; messages must remain localized and must not depend on color alone.

### Navigation

The editor header pairs the existing app mark with a short uppercase studio label, a serif editor title, and four progress segments. System Back and the visible Back action preserve native navigation. The sticky bottom region offers exactly one forward or save action; stage four changes its icon and label to publication rather than implying a fifth stage.

### Recipe Summary

A compact 14 dp tonal card carries a 58 dp rounded thumbnail, a two-line recipe name, ingredient and time metadata, and an optional amber effort value. General omits the summary until enough recipe identity exists; later stages update it from the current draft rather than stale saved data.

### Editable Ingredient and Step Modules

Ingredient sections and ordered instruction cards combine drag affordances, 48 dp destructive controls, structured filled fields, and full-width add actions. Instruction numerals use the editorial face in primary color; ingredient assignment opens a grouped, scrollable Material bottom sheet and returns identity-backed removable chips.

### Nutrition List

Nutrition is an optional reorderable list, not a metric grid. Each 12 dp tonal row preserves a long localized label, a free-form per-serving value field, a drag handle, rename behavior, and a delete action. The layout stays a single centered list on tablet because line length and editability matter more than filling width.

## Do's and Don'ts

### Do:

- **Do** preserve the four-stage General, Ingredients, Instructions, and Nutrition story with visible progress and stable sticky actions.
- **Do** use role-based light, dark, and OLED mappings so contrast and surface hierarchy survive every theme.
- **Do** keep real recipe content, stable ingredient identity, free-form nutrition values, localization, and native Material behavior intact.
- **Do** cap authoring content at 760 dp and reflow dense ingredient rows below 420 dp.
- **Do** maintain 48 dp minimum touch targets, scalable text, semantic labels, keyboard-safe layout, and reduced-motion compatibility.

### Don't:

- **Don't** revive the legacy gradient editor, glassmorphism, or ad-dense recipe-blog styling inside this world.
- **Don't** add AI parsing, inventory, timers, video, profiles, hands-free mode, or other unsupported reference concepts.
- **Don't** turn the editor into a wide multi-column dashboard; tablet layouts preserve the focused authoring measure.
- **Don't** use Paprika, Sage, and Amber interchangeably or rely on any accent as the sole carrier of meaning.
- **Don't** replace the approved nutrition list with a metric grid or force values into a unit model the product does not store.
