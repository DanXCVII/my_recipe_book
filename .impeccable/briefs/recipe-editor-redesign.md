# Recipe editor redesign

## Direction contract

### THESIS

Turn recipe authoring into a calm culinary-journal workflow: one clear stage at a time, visible progress, generous working surfaces, and durable controls that remain usable with a keyboard open or hands occupied.

### OWN-WORLD

Warm Editorial Minimalism with Tactile Utility. Parchment-toned ground, crisp or tonal paper cards, paprika/oxblood actions, restrained amber and sage accents, Playfair Display editorial headlines, and Plus Jakarta Sans technical copy. The supplied Culinary Editorial screenshots are the authority; the legacy gradient editor is the anti-reference.

### STORY

General establishes the dish and its practical parameters. Ingredients builds the mise en place in named sections. Instructions turns that mise en place into ordered actions with explicit ingredient associations. Nutrition closes the record with optional per-serving facts and the final publication action.

### FIRST VIEWPORT

The app identity and four-part progress are immediately legible, followed by the current recipe context, one decisive stage heading, and the stage's first high-value card. Sticky Back and Continue/Save actions remain available without competing with the editing surface.

### FORM

Seed key: `supplied-reference/culinary-editorial-v1`. Four-stage native Android form using a 20 dp phone margin, a centered maximum-width tablet column, 14–16 dp tonal cards, 10–14 dp input corners, 48 dp minimum targets, and a keyboard-safe sticky action bar. Instruction associations use grouped Material bottom sheets and identity-backed removable chips. Nutrition follows the approved list comp because rows accommodate long localized labels and free-form values more reliably than a metric grid.

- Preserve the established Culinary Editorial language: warm parchment surfaces, oxblood primary actions, amber accents, Playfair Display headings, and Plus Jakarta Sans controls.
- Use one four-stage editor shell for General, Ingredients, Instructions, and Nutrition with a compact recipe summary and keyboard-safe sticky navigation.
- Keep the interface tactile and calm: tonal cards, restrained shadows, rounded rectangular controls, and 48 dp minimum targets.
- Ingredient assignments belong to individual instruction steps, use stable ingredient identity, and may be repeated across multiple steps.
- Nutrition is an optional fourth stage. The approved north-star is `nutrition-list.png`; rows retain the existing free-form value model.
- Unsupported reference concepts—including AI parsing, inventory, timers, video, profiles, and hands-free mode—are intentionally absent.

### FINISH

unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
