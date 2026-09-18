---
version: 1
slug: "lib-screens-intro-screen-dart"
primary_target: "lib/screens/intro_screen.dart"
related_targets: ["lib/widgets/onboarding/editorial_onboarding.dart", "lib/l10n/intl_en.arb", "lib/l10n/intl_de_DE.arb"]
---

# Introduction

Mode: Persuade

Audience: mixed-experience personal-cookbook users seeing My RecipeBible for the first time or replaying the introduction from Settings. Job: understand the app's most useful, actually implemented discovery and cooking workflows quickly enough to enter the cookbook with confidence.

## Direction contract

**THESIS:** A concise four-page culinary-journal preview makes the app's real value tangible through safe local demos, without turning first launch into setup or advertising capabilities the product does not provide.

**OWN-WORLD:** Culinary Editorial uses parchment surfaces, paprika actions, sage confirmation, amber effort, Playfair Display headings, Plus Jakarta Sans utility text, restrained warm elevation, and light, dark, and OLED role mappings.

**FIRST VIEWPORT:** A compact My RecipeBible header and Skip action frame one focused story at a time. The body scrolls independently, while four-step progress and Back/Continue actions remain reachable above system insets.

**SIGNATURE INTERACTION:** Each page contains one bounded, preview-only interaction: choose an effort score, operate a sample timer, toggle pantry/list items, or swipe a sample Explore card. Demos never read or mutate recipe data.

**BOUNDARIES:** Preserve first-launch presentation, Settings replay, route name, localization, system Back, text scaling, and reduced motion. Ingredient search is labeled Pro. Exclude automatic effort calibration, pantry inventory, missing-item generation, aisle sorting, reminder sync, savings or waste claims, notes/photo import, profiles, sign-in, and navigation or mutations from demo controls.

**AUTHORITY:** `redesigns/onboarding/` governs editorial composition and feature-showcase treatment. `redesigns/swyping_cards/` guides only the Explore card silhouette and approved left/up/right vocabulary. PRODUCT.md, DESIGN.md, real app behavior, and Material interaction rules override mock copy and controls.
