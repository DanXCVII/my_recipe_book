---
version: 1
slug: "lib-screens-recipe-calendar-screen-dart"
primary_target: "lib/screens/recipe_calendar_screen.dart"
related_targets: ["lib/widgets/calendar/editorial_weekly_planner.dart", "lib/widgets/calendar/calendar_export_preview.dart", "lib/widgets/recipe_calendar_floating.dart"]
---

# Weekly meal planner

Mode: Operate

Audience: personal-cookbook users planning meals by week on a phone or from the existing wide-screen floating panel. Job: scan a Monday–Sunday plan, add or remove exact recipe occurrences, open recipe detail, and review ingredients before exporting them to the shopping cart. Primary task: make and export a trustworthy weekly meal plan. Constraints: use only real recipe/calendar data; preserve the Material app bar, system Back, ads, localization, themes, safe areas, and floating-panel close behavior; exclude reference-only branding, meal-type taxonomy, completion tracking, flexible slots, autofill, pantry, and insight concepts.

## Direction contract

**THESIS:** A tactile weekly desk planner makes meal planning feel deliberate without turning it into project management. Seven ordered day sections keep the whole week legible, while a compact pinned index and one review-first export dock keep the next action close.

**OWN-WORLD:** Culinary Editorial uses parchment and tonal paper surfaces, paprika actions, sage dietary states, amber effort states, Playfair Display titles, Plus Jakarta Sans utility text, rounded paper modules, and restrained warm elevation. Dark and OLED variants preserve semantic roles and tonal separation.

**STORY:** The user confirms the week, jumps to a day, sees real scheduled recipes and practical metadata, adds or removes an occurrence, then opens a grouped ingredient review where servings and selections can be adjusted before one atomic cart export.

**FIRST VIEWPORT:** The retained Material back bar leads into a pinned week range with previous/next controls, a primary Plan recipe action, and a seven-day strip. The selected day section follows with image-led recipe cards or a compact empty prompt. A fixed Review & export dock sits above the retained ad area.

**FORM:** Precisely specified user-supplied reference, seed key `user-supplied-reference`; `calendar_view/code.html` governs typography, spacing, colors, and component treatment, while `calendar_view/screen.png` governs composition and hierarchy. Signature interaction: day-strip taps scroll to highlighted sections, and export opens a grouped review-and-unselect sheet instead of mutating the cart immediately.

**FINISH:** Native evidence covers populated phone light, phone OLED at 1.3× text, the review sheet, and the 420 dp floating calendar; implementation finishes only after analysis, the full Flutter suite, and a bounded review pass are clear.
