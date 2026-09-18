const String noRecipeImage = "images/randomFood.jpg";
const String noCategory = "no category";
const String editRecipeLocalPathString = "edit";
const String newRecipeLocalPathString = "tmp";
const String allCategories = "all categories";
const String summary = "summary";
const String enableAnimations = "enableAnimations";
const String disableStandby = "disableStandby";
const String showDecimal = "showDecimal";

const double homeNavigationRailBreakpoint = 900;

bool usesHomeNavigationRail(double width) =>
    width > homeNavigationRailBreakpoint;
