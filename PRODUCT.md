# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

People who keep a personal recipe collection on their phone and need to find, compare, and open recipes quickly while planning meals or cooking.

## Product Purpose

My RecipeBible is a personal digital cookbook for saving, organizing, searching, sharing, and cooking from recipes. Success means a user can reliably keep their collection with them and reach the right recipe without the clutter and pricing patterns they dislike in competing apps.

## Positioning

An offline-first, user-owned recipe library combining structured recipe storage with category, dietary, tag, ingredient, and random-recipe discovery, without a subscription.

## Operating Context

The product is primarily used on Android phones, including in bright kitchen conditions and while the user may have limited attention or messy hands. Recipe data and images are stored locally, with optional sharing, export, Google Drive synchronization, meal planning, and shopping-list workflows.

## Capabilities and Constraints

- Flutter application using Bloc state management and local Drift storage.
- Recipe overviews are opened for a category, dietary type, or tag.
- Recipes expose name, image, total time, effort, dietary type, tags, favorite state, and ingredients.
- English and German localization are supported.
- Light, dark, and OLED themes must remain supported.
- The Culinary Editorial redesign covers the pushed recipe overview, recipe detail, recipe editor, weekly planner, and phone shopping-list surfaces; the home shell, wide-screen floating containers, and unrelated screens retain their current behavior.

## Brand Commitments

- Preserve the product name My RecipeBible.
- The recipe overview adopts the user-supplied Culinary Editorial reference.
- `stitch_modern_recipe_app_design/code.html` is authoritative for typography, weights, component styling, spacing, and interaction details.
- `stitch_modern_recipe_app_design/screen.png` is authoritative for composition, density, hierarchy, and overall appearance except where its font rendering conflicts with the HTML.
- The recipe detail adopts the user-supplied `recipe_screen/` reference while preserving My RecipeBible data and actions; mock-only author, public-review, guided-cook, and timer concepts are excluded.
- The shopping-list adaptation preserves My RecipeBible navigation and real cart data; aisle, pantry-inventory, store-ordering, and Simmer-specific concepts from the reference are intentionally excluded.
- The weekly planner adapts the user-supplied `calendar_view/` reference while preserving My RecipeBible navigation, ads, real calendar data, and the existing add, remove, recipe-detail, and cart workflows.

## Evidence on Hand

- Existing local recipe data and user-selected recipe imagery.
- A complete HTML reference, screenshot, and design-token document in `stitch_modern_recipe_app_design/`.
- No cooked-history field or collection model exists; the overview must not fabricate those statistics.

## Product Principles

- Keep user recipe data local, durable, and portable.
- Make finding a recipe fast across categories, diets, tags, and names.
- Preserve existing navigation and domain behavior while improving presentation.
- Keep core controls readable and touchable in real kitchen conditions.

## Accessibility & Inclusion

Support system text scaling, semantic labels, keyboard focus where available, reduced motion, 48 dp touch targets, and sufficient contrast across light, dark, and OLED themes.
