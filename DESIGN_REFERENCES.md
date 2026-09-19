# Design reference map

This file identifies which visual references may guide each surface. It is an
index, not a second design system.

## Precedence

When sources disagree, use this order:

1. `PRODUCT.md` for product truth, supported behavior, and scope.
2. `DESIGN.md` for the shared Culinary Editorial system.
3. The matching `.impeccable/surfaces/*.md` brief for surface decisions.
4. The scoped reference below for composition and visual detail.
5. Existing implementation for behavior not replaced by the approved work.

Reference HTML and screenshots contain fictional copy, branding, data, and
features. They are never authority for product capabilities.

## Established surface references

| Surface | Reference | May guide | Must not introduce |
|---|---|---|---|
| Recipe overview | `redesigns/recipe_cards/` and `redesigns/recipe_list/` | Grid/list card composition, density, typography, and component treatment | Simmer branding, cooked history, collections, batch actions, or replacement navigation |
| Recipe editor | `redesigns/recipe_add_screen/` and `redesigns/recipe_edit_add/` | Four-stage editorial hierarchy, field treatment, spacing, and persistent actions | AI parsing, inventory, profiles, video, hands-free control, or a metric nutrition grid |
| Recipe detail | `redesigns/recipe_screen/` | Image-led hierarchy, ingredient checklist, instruction treatment, and typography | Mock author identity, public reviews, guided-cook features, or timers unsupported by My RecipeBible data |
| Weekly planner | `redesigns/calendar_view/` | Weekly composition, day navigation, hierarchy, and export-review presentation | Invented meal taxonomy, completion tracking, autofill, pantry features, or replacement navigation |
| Shopping-list detailed add | `redesigns/add_ingredient/` | Adaptive modal composition, field hierarchy, recipe association, and repeat-entry actions | Smart parsing, pairings, market aisles, profiles, or recipe-step/issue linkage |
| Ingredient search | `redesigns/ingredient_search/` | Pantry-search composition and editorial result treatment | Profiles, invented pantry inventory, or unsupported recipe data |
| Cook Mode | `redesigns/cookmode/` | Focused step layout, assigned ingredients, progress, timer, and dock treatment | Voice guidance, profiles, pantry state, or other mock-only assistant behavior |
| Explore | `redesigns/swyping_cards/` | Stacked-card composition and the approved left/up/right interaction vocabulary | A Deck/Grid switch, downward action, central information action, or invented recipe metadata |
| Bookmarks | `redesigns/bookmarks/` | Saved-recipe hierarchy and card presentation | Profiles, premium claims, pantry shortcuts, or replacement app navigation |
| Introduction | `redesigns/onboarding/` | Editorial feature-showcase composition, hierarchy, and bounded preview interactions | Automatic effort calibration, pantry inventory, aisle sorting, reminder sync, savings or waste claims, notes/photo import, profiles, sign-in, or demo actions that mutate app data |
| Splash screen | `redesigns/splashscreen/` | Warm editorial composition, emblem presentation, typographic hierarchy, ambient color, and loading treatment | The mock tagline, “Parchment, copper & hearth,” simulated progress, edition/volume copy, or a spinning loading icon |

The broader shopping-list implementation is governed by its persisted surface
brief and the shared design system. The dedicated reference above applies only
to its detailed ingredient-add flow.

## Supporting references only

The following directories are retained as visual research and are not approval
to redesign their apparent surface:

- `redesigns/category_overview/`
- `redesigns/recipe_of_the_day_reference/`
- `redesigns/settings/`

Promote one of these to an established reference only through an explicit
surface decision and a corresponding persisted surface brief.

## Archived decisions

Completed review evidence lives under `.impeccable/archive/reviews/`. Archived
files document what was considered; they do not override the current product,
design system, or surface briefs. Rejected concepts are labeled inside their
archive directories.
