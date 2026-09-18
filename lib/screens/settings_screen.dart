import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/g_drive/g_drive_sign_in/g_drive_sign_in_bloc.dart';
import '../blocs/g_drive/g_drive_sync/g_drive_bloc.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/brand_assets.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../local_storage/storage_migration.dart';
import '../models/import_candidate.dart';
import '../services/import_file_stager.dart';
import '../theming.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import 'export_recipes_screen.dart';
import 'import_from_website.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    this.adManagerBloc,
    this.driveSignInBloc,
    this.driveSyncBloc,
  });

  @visibleForTesting
  final Bloc<AdManagerEvent, AdManagerState>? adManagerBloc;

  @visibleForTesting
  final Bloc<GDriveSignInEvent, GDriveSignInState>? driveSignInBloc;

  @visibleForTesting
  final Bloc<GDriveSyncEvent, GDriveSyncState>? driveSyncBloc;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const double _wideBreakpoint = 760;
  static const double _maxContentWidth = 1040;

  MyThemeKeys _selectedTheme = MyThemeKeys.DARK;
  late bool _keepScreenAwake;
  late bool _showDecimals;
  late bool _animationsEnabled;
  String? _packageVersion;
  int _recipeCount = 0;
  int _nutritionCount = 0;
  int _ingredientCount = 0;
  int _tagCount = 0;
  int _categoryCount = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _keepScreenAwake = GlobalSettings().standbyDisabled();
    _showDecimals = GlobalSettings().showDecimal();
    _animationsEnabled = GlobalSettings().animationsEnabled();
    _loadPreferencesAndVersion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _refreshCatalogCounts();
  }

  Future<void> _loadPreferencesAndVersion() async {
    final preferences = await SharedPreferences.getInstance();
    final keepScreenAwake =
        preferences.getBool(Constants.disableStandby) ??
        GlobalSettings().standbyDisabled();
    final showDecimals =
        preferences.getBool(Constants.showDecimal) ??
        GlobalSettings().showDecimal();
    final animationsEnabled =
        preferences.getBool(Constants.enableAnimations) ??
        GlobalSettings().animationsEnabled();
    if (!mounted) return;
    GlobalSettings().disableStandby(keepScreenAwake);
    GlobalSettings().shouldShowDecimal(showDecimals);
    GlobalSettings().enableAnimations(animationsEnabled);
    setState(() {
      _selectedTheme = _themeFromPreference(preferences.getInt('theme') ?? 2);
      _keepScreenAwake = keepScreenAwake;
      _showDecimals = showDecimals;
      _animationsEnabled = animationsEnabled;
    });

    try {
      final packageVersion = (await PackageInfo.fromPlatform()).version;
      if (mounted) setState(() => _packageVersion = packageVersion);
    } catch (_) {
      // Package metadata can be unavailable in widget tests.
    }
  }

  MyThemeKeys _themeFromPreference(int value) {
    switch (value) {
      case 0:
        return MyThemeKeys.AUTOMATIC;
      case 1:
        return MyThemeKeys.LIGHT;
      case 3:
        return MyThemeKeys.OLEDBLACK;
      case 2:
      default:
        return MyThemeKeys.DARK;
    }
  }

  void _refreshCatalogCounts() {
    final repository = context.read<LocalRepository>();
    if (!mounted) return;
    setState(() {
      _recipeCount = repository.getRecipeNames().length;
      _nutritionCount = repository.getNutritions().length;
      _ingredientCount = repository.getIngredientNames().length;
      _tagCount = repository.getRecipeTags().length;
      _categoryCount = repository
          .getCategoryNames()
          .where((category) => category != noCategoryName)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);
    final adManagerBloc = widget.adManagerBloc ?? context.read<AdManagerBloc>();
    final driveSignInBloc =
        widget.driveSignInBloc ?? context.read<GDriveSignInBloc>();
    final driveSyncBloc =
        widget.driveSyncBloc ?? context.read<GDriveSyncBloc>();

    return Theme(
      data: editorialTheme,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Bloc<AdManagerEvent, AdManagerState>>.value(
            value: adManagerBloc,
          ),
          BlocProvider<Bloc<GDriveSignInEvent, GDriveSignInState>>.value(
            value: driveSignInBloc,
          ),
          BlocProvider<Bloc<GDriveSyncEvent, GDriveSyncState>>.value(
            value: driveSyncBloc,
          ),
        ],
        child: ColoredBox(
          color: palette.background,
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= _wideBreakpoint;
                return SingleChildScrollView(
                  key: const Key('settings-scroll-view'),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(bottom: wide ? 40 : 116),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          wide ? 28 : 20,
                          8,
                          wide ? 28 : 20,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _SettingsPageHeading(),
                            const SizedBox(height: 18),
                            const _MigrationRecoveryNotice(),
                            if (wide)
                              _buildWideLayout()
                            else
                              _buildCompactLayout(),
                            const SizedBox(height: 30),
                            _SettingsFooter(version: _packageVersion),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DriveAccountCard(recipeCount: _recipeCount),
        const SizedBox(height: 24),
        _AdSettingsSection(onError: _showInfoFlushBar),
        const SizedBox(height: 24),
        _buildDataSection(),
        const SizedBox(height: 24),
        _buildAppearanceSection(),
        const SizedBox(height: 24),
        _buildCatalogSection(),
        const SizedBox(height: 24),
        _buildHelpSection(),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DriveAccountCard(recipeCount: _recipeCount),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _AdSettingsSection(onError: _showInfoFlushBar),
                  const SizedBox(height: 24),
                  _buildAppearanceSection(),
                  const SizedBox(height: 24),
                  _buildHelpSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildDataSection(),
                  const SizedBox(height: 24),
                  _buildCatalogSection(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _SettingsSection(
      title: S.of(context).settings_data_sync,
      child:
          BlocBuilder<
            Bloc<GDriveSignInEvent, GDriveSignInState>,
            GDriveSignInState
          >(
            builder: (context, driveState) {
              return _SettingsCard(
                children: [
                  if (driveState is GDriveSignedIn) const _DriveSyncRow(),
                  _SettingsRow(
                    icon: Icons.ios_share_rounded,
                    title: S.of(context).settings_backup_title,
                    description: S.of(context).settings_backup_desc,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExportRecipes(),
                        ),
                      );
                      _refreshCatalogCounts();
                    },
                    trailing: _helpAndChevron(
                      onHelp: () => showDialog(
                        context: context,
                        builder: (context) => InfoDialog(
                          title: S.of(context).information,
                          body: S.of(context).info_export_description,
                        ),
                      ),
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.file_open_rounded,
                    title: S.of(context).settings_import_local_title,
                    description: S.of(context).settings_import_local_desc,
                    onTap: () => _importSingleRecipe(context),
                    trailing: _helpAndChevron(
                      onHelp: () => showDialog(
                        context: context,
                        builder: (context) => InfoDialog(
                          title: S.of(context).info,
                          body: S.of(context).import_recipe_description,
                        ),
                      ),
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    title: S.of(context).settings_import_website_title,
                    description: S.of(context).settings_import_website_desc,
                    onTap: _openWebsiteImport,
                  ),
                  _SettingsRow(
                    icon: Icons.computer_rounded,
                    title: S.of(context).settings_import_pc_title,
                    description: S.of(context).settings_import_pc_desc,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.computerImportInfo,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildAppearanceSection() {
    return _SettingsSection(
      title: S.of(context).settings_appearance_display,
      child: _SettingsCard(
        children: [
          _ChoiceSetting<MyThemeKeys>(
            icon: Icons.palette_outlined,
            title: S.of(context).settings_theme_title,
            value: _selectedTheme,
            choices: [
              _SettingChoice(
                value: MyThemeKeys.AUTOMATIC,
                label: S.of(context).settings_theme_auto,
              ),
              _SettingChoice(
                value: MyThemeKeys.LIGHT,
                label: S.of(context).settings_theme_light,
              ),
              _SettingChoice(
                value: MyThemeKeys.DARK,
                label: S.of(context).settings_theme_dark,
              ),
              _SettingChoice(
                value: MyThemeKeys.OLEDBLACK,
                label: S.of(context).settings_theme_oled,
              ),
            ],
            onChanged: _changeTheme,
          ),
          _SettingsSwitchRow(
            icon: Icons.screen_lock_portrait_rounded,
            title: S.of(context).settings_awake_title,
            description: S.of(context).settings_awake_desc,
            value: _keepScreenAwake,
            onChanged: _setKeepScreenAwake,
          ),
          _ChoiceSetting<bool>(
            icon: Icons.calculate_outlined,
            title: S.of(context).settings_quantity_title,
            description: S.of(context).settings_quantity_desc,
            value: _showDecimals,
            choices: [
              _SettingChoice(
                value: false,
                label: '½  ${S.of(context).settings_fractions}',
              ),
              _SettingChoice(
                value: true,
                label: '.50  ${S.of(context).settings_decimals}',
              ),
            ],
            onChanged: _setShowDecimals,
          ),
          _SettingsSwitchRow(
            icon: Icons.animation_rounded,
            title: S.of(context).settings_animations_title,
            description: S.of(context).settings_animations_desc,
            value: _animationsEnabled,
            onChanged: _setAnimationsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogSection() {
    return _SettingsSection(
      title: S.of(context).settings_recipe_catalog,
      child: _SettingsCard(
        children: [
          _SettingsRow(
            icon: Icons.monitor_weight_outlined,
            title: S.of(context).settings_nutrition_title,
            description: S.of(context).settings_nutrition_desc,
            badge: S.of(context).settings_item_count(_nutritionCount),
            onTap: () => _openManager(RouteNames.manageNutritions),
          ),
          _SettingsRow(
            icon: Icons.kitchen_outlined,
            title: S.of(context).settings_ingredients_title,
            description: S.of(context).settings_ingredients_desc,
            badge: S.of(context).settings_item_count(_ingredientCount),
            onTap: () => _openManager(RouteNames.manageIngredients),
          ),
          _SettingsRow(
            icon: Icons.tag_rounded,
            title: S.of(context).settings_tags_title,
            description: S.of(context).settings_tags_desc,
            badge: S.of(context).settings_item_count(_tagCount),
            onTap: () => _openManager(RouteNames.manageRecipeTags),
          ),
          _SettingsRow(
            icon: Icons.folder_special_outlined,
            title: S.of(context).settings_categories_title,
            description: S.of(context).settings_categories_desc,
            badge: S.of(context).settings_item_count(_categoryCount),
            onTap: () => _openManager(RouteNames.manageCategories),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return _SettingsSection(
      title: S.of(context).settings_help_about,
      child: _SettingsCard(
        children: [
          _SettingsRow(
            icon: Icons.auto_stories_outlined,
            title: S.of(context).settings_intro_title,
            description: S.of(context).settings_intro_desc,
            onTap: () => Navigator.of(context).pushNamed(RouteNames.intro),
          ),
          _SettingsRow(
            icon: Icons.star_outline_rounded,
            title: S.of(context).settings_rate_title,
            description: S.of(context).settings_rate_desc,
            onTap: () => launchUrl(
              Uri.parse(
                'http://play.google.com/store/apps/details?id=com.release.my_recipe_book',
              ),
            ),
          ),
          _SettingsRow(
            icon: Icons.info_outline_rounded,
            title: S.of(context).settings_about_title,
            description: S.of(context).settings_about_desc,
            onTap: () => Navigator.pushNamed(context, RouteNames.aboutMe),
          ),
        ],
      ),
    );
  }

  Widget _helpAndChevron({required VoidCallback onHelp}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: S.of(context).information,
          onPressed: onHelp,
          icon: const Icon(Icons.help_outline_rounded),
        ),
        const Icon(Icons.chevron_right_rounded),
      ],
    );
  }

  Future<void> _openManager(String routeName) async {
    await Navigator.pushNamed(context, routeName);
    Ads.hideBottomBannerAd();
    _refreshCatalogCounts();
  }

  Future<void> _openWebsiteImport() async {
    final adManagerBloc = context.read<AdManagerBloc>()..add(LoadVideo());
    await Navigator.pushNamed(
      context,
      RouteNames.importFromWebsite,
      arguments: ImportFromWebsiteArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        adManagerBloc,
      ),
    );
    Ads.hideBottomBannerAd();
    _refreshCatalogCounts();
  }

  Future<void> _changeTheme(MyThemeKeys key) async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _selectedTheme = key);

    switch (key) {
      case MyThemeKeys.AUTOMATIC:
        final brightness = MediaQuery.platformBrightnessOf(context);
        CustomTheme.instanceOf(context)!.changeTheme(
          brightness == Brightness.dark ? MyThemeKeys.DARK : MyThemeKeys.LIGHT,
        );
        await preferences.setInt('theme', 0);
        break;
      case MyThemeKeys.LIGHT:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.LIGHT);
        await preferences.setInt('theme', 1);
        break;
      case MyThemeKeys.DARK:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.DARK);
        await preferences.setInt('theme', 2);
        break;
      case MyThemeKeys.OLEDBLACK:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.OLEDBLACK);
        await preferences.setInt('theme', 3);
        break;
    }
  }

  Future<void> _setKeepScreenAwake(bool value) async {
    setState(() => _keepScreenAwake = value);
    GlobalSettings().disableStandby(value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.disableStandby, value);
  }

  Future<void> _setShowDecimals(bool value) async {
    setState(() => _showDecimals = value);
    GlobalSettings().shouldShowDecimal(value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.showDecimal, value);
  }

  Future<void> _setAnimationsEnabled(bool value) async {
    setState(() => _animationsEnabled = value);
    GlobalSettings().enableAnimations(value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.enableAnimations, value);
  }

  void _showInfoFlushBar(String title, String body, BuildContext context) {
    late Flushbar<bool> flush;
    flush = Flushbar<bool>(
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: Ads.shouldShowBannerAds() ? Ads.adHeight ?? 0 : 0,
      ),
      borderRadius: BorderRadius.circular(14),
      animationDuration: const Duration(milliseconds: 250),
      leftBarIndicatorColor: CulinaryEditorialPalette.of(context).primary,
      title: title,
      message: body,
      icon: Icon(
        Icons.info_outline_rounded,
        color: CulinaryEditorialPalette.of(context).primary,
      ),
      mainButton: TextButton(
        onPressed: () => flush.dismiss(true),
        child: const Text('OK'),
      ),
    )..show(context);
  }

  Future<void> _importSingleRecipe(BuildContext context) async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['zip', 'mcb', 'json'],
    );
    final path = result?.path;
    if (path == null || !context.mounted) return;

    late final ImportCandidate candidate;
    try {
      candidate = await ImportFileStager().stage(
        sourcePath: path,
        originalFileName: result!.name,
        source: ImportSource.filePicker,
      );
    } catch (_) {
      if (context.mounted) {
        _showInfoFlushBar(
          S.of(context).failed_import,
          S.of(context).no_valid_import_file,
          context,
        );
      }
      return;
    }
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider<ImportRecipeBloc>.value(
        value: context.read<ImportRecipeBloc>()
          ..add(
            StartImportRecipes(
              candidate,
              delay: const Duration(milliseconds: 1000),
            ),
          ),
        child: ImportDialog(),
      ),
    );
    _refreshCatalogCounts();
  }
}

class _SettingsPageHeading extends StatelessWidget {
  const _SettingsPageHeading();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Text(
      S.of(context).settings_title,
      style: CulinaryEditorialType.headline(
        palette,
        size: 30,
        weight: FontWeight.w600,
        height: 1.08,
      ),
    );
  }
}

class _DriveAccountCard extends StatelessWidget {
  const _DriveAccountCard({required this.recipeCount});

  final int recipeCount;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return BlocBuilder<
      Bloc<GDriveSignInEvent, GDriveSignInState>,
      GDriveSignInState
    >(
      builder: (context, state) {
        Widget avatar;
        String title;
        String description;
        Widget trailing;

        if (state is GDriveSignedIn) {
          avatar = state.imageUrl == null
              ? _AccountFallbackAvatar(palette: palette)
              : ClipOval(
                  child: Image.network(
                    state.imageUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _AccountFallbackAvatar(palette: palette),
                  ),
                );
          title = state.signedInName;
          description = state.signedInEmail;
          trailing = IconButton(
            tooltip: S.of(context).settings_drive_sign_out,
            onPressed: () => context
                .read<Bloc<GDriveSignInEvent, GDriveSignInState>>()
                .add(GDriveSignOut()),
            icon: const Icon(Icons.logout_rounded),
          );
        } else {
          avatar = Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.surfaceContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset('images/google_logo.png'),
          );
          title = S.of(context).settings_drive_title;
          if (state is GDriveSigningIn) {
            description = S.of(context).settings_drive_signing_in;
            trailing = const _SmallProgressIndicator();
          } else if (state is GDriveSigningOut) {
            description = S.of(context).settings_drive_signing_out;
            trailing = const _SmallProgressIndicator();
          } else if (state is GDriveNoInternet) {
            description = S.of(context).settings_drive_offline_desc;
            trailing = FilledButton.tonal(
              onPressed: () => context
                  .read<Bloc<GDriveSignInEvent, GDriveSignInState>>()
                  .add(GDriveSignIn()),
              child: Text(S.of(context).retry),
            );
          } else {
            description = S.of(context).settings_drive_signed_out_desc;
            trailing = FilledButton.tonal(
              onPressed: () => context
                  .read<Bloc<GDriveSignInEvent, GDriveSignInState>>()
                  .add(GDriveSignIn()),
              child: Text(S.of(context).settings_drive_sign_in),
            );
          }
        }

        return Container(
          constraints: const BoxConstraints(minHeight: 84),
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(palette),
          child: Row(
            children: [
              avatar,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 12,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                    if (state is GDriveSignedIn) ...[
                      const SizedBox(height: 5),
                      Text(
                        S.of(context).settings_recipe_count(recipeCount),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w700,
                          color: palette.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        );
      },
    );
  }
}

class _AccountFallbackAvatar extends StatelessWidget {
  const _AccountFallbackAvatar({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: palette.secondarySoft,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_rounded, color: palette.secondary, size: 28),
    );
  }
}

class _AdSettingsSection extends StatelessWidget {
  const _AdSettingsSection({required this.onError});

  final void Function(String title, String body, BuildContext context) onError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<Bloc<AdManagerEvent, AdManagerState>, AdManagerState>(
      listener: (context, state) {
        if (state is NotConnected) {
          onError(
            S.of(context).no_internet_connection,
            S.of(context).no_internet_connection_desc,
            context,
          );
        } else if (state is FailedLoadingRewardedVideo) {
          onError(
            S.of(context).failed_loading_ad,
            S.of(context).failed_loading_ad_desc,
            context,
          );
        }
      },
      child: BlocBuilder<Bloc<AdManagerEvent, AdManagerState>, AdManagerState>(
        builder: (context, state) {
          final children = <Widget>[];
          if (state is IsPurchased) {
            children.add(
              _SettingsCard(
                children: [
                  _SettingsRow(
                    icon: Icons.workspace_premium_rounded,
                    title: S.of(context).settings_pro_active,
                    description: S.of(context).settings_pro_active_desc,
                    iconTone: _IconTone.success,
                  ),
                ],
              ),
            );
          } else {
            children.addAll([
              _ProCard(
                onUpgrade: () => context
                    .read<Bloc<AdManagerEvent, AdManagerState>>()
                    .add(PurchaseProVersion()),
              ),
              const SizedBox(height: 10),
              _SettingsCard(
                children: [
                  _SettingsRow(
                    icon: Icons.smart_display_outlined,
                    title: S.of(context).settings_reward_title,
                    description: S.of(context).settings_reward_desc,
                    onTap: state is LoadingVideo
                        ? null
                        : () => _showRewardedVideoDialog(context),
                    trailing: _rewardTrailing(context, state),
                    iconTone: _IconTone.success,
                  ),
                  _SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    title: S.of(context).settings_ad_preferences_title,
                    description: S.of(context).settings_ad_preferences_desc,
                    onTap: () {
                      Ads.initialize(Ads.shouldShowAds(), personalized: false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            S.of(context).settings_non_personalized_enabled,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ]);
          }
          return _SettingsSection(
            title: S.of(context).settings_account_ads,
            child: Column(children: children),
          );
        },
      ),
    );
  }

  static Widget _rewardTrailing(BuildContext context, AdManagerState state) {
    if (state is LoadingVideo) return const _SmallProgressIndicator();
    if (state is FailedLoadingRewardedVideo) {
      return Icon(
        Icons.error_outline_rounded,
        color: Theme.of(context).colorScheme.error,
      );
    }
    if (state is NotConnected) {
      return Tooltip(
        message: S.of(context).no_internet_connection,
        child: Icon(
          Icons.wifi_off_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }
    if (state is AdFreeUntil) {
      final formatted = MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(state.time),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );
      return _StatusBadge(label: '${S.of(context).ad_free_until} $formatted');
    }
    return FilledButton.tonal(
      onPressed: () => _showRewardedVideoDialog(context),
      child: Text(S.of(context).settings_watch),
    );
  }

  static void _showRewardedVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => InfoDialog(
        title: S.of(context).video_to_remove_ads,
        body: S.of(context).video_to_remove_ads_desc,
        onPressedOk: () {
          context.read<Bloc<AdManagerEvent, AdManagerState>>().add(
            StartWatchingVideo(DateTime.now(), true, true),
          );
        },
        okText: S.of(context).watch,
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: palette.onPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${S.of(context).recipe_bible} Pro',
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 18,
                    weight: FontWeight.w700,
                    height: 1.2,
                  ).copyWith(color: palette.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            S.of(context).settings_pro_desc,
            style: CulinaryEditorialType.body(
              palette,
              size: 13,
              color: palette.onPrimary.withValues(alpha: .88),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: palette.surface,
                foregroundColor: palette.primary,
              ),
              onPressed: onUpgrade,
              child: Text(S.of(context).settings_upgrade),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriveSyncRow extends StatelessWidget {
  const _DriveSyncRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<GDriveSyncEvent, GDriveSyncState>, GDriveSyncState>(
      builder: (context, state) {
        final palette = CulinaryEditorialPalette.of(context);
        String title = S.of(context).settings_drive_sync_title;
        String description = S.of(context).settings_drive_sync_desc;
        Widget? trailing;
        VoidCallback? onTap;
        double? progress;

        if (state is GDriveIdle) {
          onTap = () => _startSync(context);
        } else if (state is GDriveSyncing) {
          description = S.of(context).settings_drive_syncing_desc;
          trailing = _cancelButton(context);
        } else if (state is GDriveImporting) {
          description = S.of(context).importing_recipe_drive(state.recipeName);
          trailing = _cancelButton(context);
          progress = _safeProgress(
            state.importingRecipeNumber,
            state.totalImporting,
          );
        } else if (state is GDriveUploading) {
          description = S.of(context).uploading_recipe_drive(state.recipeName);
          trailing = _cancelButton(context);
          progress = _safeProgress(
            state.uploadingRecipeNumber,
            state.totalUploading,
          );
        } else if (state is GDriveCloudDeleting) {
          description = S.of(context).deleting_recipe_drive(state.recipeName);
          trailing = _cancelButton(context);
          progress = _safeProgress(
            state.deletingRecipeNumber,
            state.totalDeleting,
          );
        } else if (state is GDriveLocalDeleting) {
          description = S.of(context).deleting_recipe_local(state.recipeName);
          trailing = _cancelButton(context);
          progress = _safeProgress(
            state.deletingRecipeNumber,
            state.totalDeleting,
          );
        } else if (state is GDriveCancellingSync) {
          description = S.of(context).cancelling_sync;
          trailing = const _SmallProgressIndicator();
        } else if (state is GDriveSuccessfullySynced) {
          description = S.of(context).successfully_synced_drive;
          trailing = Icon(Icons.cloud_done_rounded, color: palette.secondary);
          onTap = () => _startSync(context);
        } else if (state is GDriveErrorSyncing) {
          title = S.of(context).settings_drive_retry;
          description = S.of(context).failed_syncing;
          trailing = Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
          );
          onTap = () => _startSync(context);
        }

        return _SettingsRow(
          icon: Icons.cloud_sync_outlined,
          title: title,
          description: description,
          onTap: onTap,
          trailing: trailing,
          iconTone: _IconTone.success,
          footer: state is GDriveSyncing || progress != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LinearProgressIndicator(
                    value: state is GDriveSyncing ? null : progress,
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
              : null,
        );
      },
    );
  }

  static double? _safeProgress(int current, int total) {
    if (total <= 0) return null;
    return (current / total).clamp(0, 1);
  }

  static Widget _cancelButton(BuildContext context) {
    return IconButton(
      tooltip: S.of(context).settings_drive_cancel,
      onPressed: () => context
          .read<Bloc<GDriveSyncEvent, GDriveSyncState>>()
          .add(GDriveCancelSync()),
      icon: const Icon(Icons.close_rounded),
    );
  }

  static void _startSync(BuildContext context) {
    context.read<Bloc<GDriveSyncEvent, GDriveSyncState>>().add(
      GDriveStartSync(DateTime.now()),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: CulinaryEditorialType.body(
              palette,
              size: 10,
              weight: FontWeight.w700,
              color: palette.outline,
              letterSpacing: 1,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      decoration: _cardDecoration(palette),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1) const _SettingsDivider(),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.trailing,
    this.badge,
    this.footer,
    this.iconTone = _IconTone.neutral,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? badge;
  final Widget? footer;
  final _IconTone iconTone;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final enabled = onTap != null;
    final resolvedTrailing =
        trailing ??
        (enabled
            ? Icon(Icons.chevron_right_rounded, color: palette.outline)
            : null);

    return Semantics(
      button: enabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SettingIcon(icon: icon, tone: iconTone),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 14,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                        if (footer != null) footer!,
                      ],
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    _StatusBadge(label: badge!),
                  ],
                  if (resolvedTrailing != null) ...[
                    const SizedBox(width: 6),
                    Align(alignment: Alignment.center, child: resolvedTrailing),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      toggled: value,
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _SettingIcon(icon: icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 14,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ExcludeSemantics(
                    child: Switch(value: value, onChanged: onChanged),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceSetting<T> extends StatelessWidget {
  const _ChoiceSetting({
    required this.icon,
    required this.title,
    required this.value,
    required this.choices,
    required this.onChanged,
    this.description,
  });

  final IconData icon;
  final String title;
  final String? description;
  final T value;
  final List<_SettingChoice<T>> choices;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SettingIcon(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 14,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        description!,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 12,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _EditorialSegmentedControl<T>(
            value: value,
            choices: choices,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _EditorialSegmentedControl<T> extends StatelessWidget {
  const _EditorialSegmentedControl({
    required this.value,
    required this.choices,
    required this.onChanged,
  });

  final T value;
  final List<_SettingChoice<T>> choices;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: choices.map((choice) {
          final selected = choice.value == value;
          return Expanded(
            child: Semantics(
              button: true,
              selected: selected,
              label: choice.label,
              child: Material(
                color: selected ? palette.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => onChanged(choice.value),
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          choice.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 11,
                            weight: selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: selected
                                ? palette.primary
                                : palette.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SettingChoice<T> {
  const _SettingChoice({required this.value, required this.label});

  final T value;
  final String label;
}

enum _IconTone { neutral, success }

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, this.tone = _IconTone.neutral});

  final IconData icon;
  final _IconTone tone;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final success = tone == _IconTone.success;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: success ? palette.secondarySoft : palette.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 20,
        color: success ? palette.secondary : palette.onSurfaceVariant,
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 66, right: 14),
      child: Divider(height: 1, thickness: 1, color: palette.surfaceContainer),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 104),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: CulinaryEditorialType.body(
          palette,
          size: 10,
          weight: FontWeight.w700,
          color: palette.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SmallProgressIndicator extends StatelessWidget {
  const _SmallProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 22,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _SettingsFooter extends StatelessWidget {
  const _SettingsFooter({required this.version});

  final String? version;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: palette.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Image.asset(BrandAssets.simplifiedLogo),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).recipe_bible,
          style: CulinaryEditorialType.headline(
            palette,
            size: 16,
            weight: FontWeight.w600,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
        if (version != null) ...[
          const SizedBox(height: 3),
          Text(
            S.of(context).settings_footer(version!),
            textAlign: TextAlign.center,
            style: CulinaryEditorialType.body(
              palette,
              size: 11,
              color: palette.outline,
            ),
          ),
        ],
      ],
    );
  }
}

class _MigrationRecoveryNotice extends StatefulWidget {
  const _MigrationRecoveryNotice();

  @override
  State<_MigrationRecoveryNotice> createState() =>
      _MigrationRecoveryNoticeState();
}

class _MigrationRecoveryNoticeState extends State<_MigrationRecoveryNotice> {
  late Future<List<MigrationIssueSummary>> _issues;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _issues = context.read<LocalRepository>().migrationIssues();
  }

  void _reload() {
    setState(() {
      _issues = context.read<LocalRepository>().migrationIssues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MigrationIssueSummary>>(
      future: _issues,
      builder: (context, snapshot) {
        final issues = snapshot.data ?? const <MigrationIssueSummary>[];
        if (issues.isEmpty) return const SizedBox.shrink();
        final palette = CulinaryEditorialPalette.of(context);
        final errorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: errorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: errorScheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).settings_migration_title,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w700,
                          color: errorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.of(context).settings_migration_desc(issues.length),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 12,
                          color: errorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: _retrying ? null : _retry,
                            icon: _retrying
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.refresh_rounded),
                            label: Text(S.of(context).settings_migration_retry),
                          ),
                          TextButton.icon(
                            onPressed: () => _shareReport(issues),
                            icon: const Icon(Icons.share_outlined),
                            label: Text(S.of(context).settings_migration_share),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await context.read<StorageMigrationCoordinator>().retrySkippedRecipes();
    if (!mounted) return;
    setState(() => _retrying = false);
    _reload();
  }

  void _shareReport(List<MigrationIssueSummary> issues) {
    final report = [
      'My RecipeBible storage migration report',
      ...issues.map((issue) => '${issue.errorCode}: ${issue.legacyKey}'),
    ].join('\n');
    SharePlus.instance.share(ShareParams(text: report));
  }
}

BoxDecoration _cardDecoration(CulinaryEditorialPalette palette) {
  return BoxDecoration(
    color: palette.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: palette.shadow,
        blurRadius: 16,
        spreadRadius: -2,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

//////////////// test code for extraction of recipes from websites ////////////////

String extractText(dom.Element element) {
  StringBuffer buffer = StringBuffer();

  void extractTextRecursively(dom.Element element) {
    for (dom.Node node in element.nodes) {
      if (node is dom.Text) {
        final text = node.text.trim();
        if (text.isNotEmpty) {
          buffer.write(' ');
          buffer.write(text);
        }
      } else if (node is dom.Element) {
        if (!['style', 'script'].contains(node.localName)) {
          extractTextRecursively(node);
        }
      }
    }
  }

  extractTextRecursively(element);

  return buffer.toString().trim();
}

Future<String> fetchHtml(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load HTML from $url');
  }
}

String extractJsonLdText(dom.Document htmlDocument) {
  StringBuffer buffer = StringBuffer();
  final elements = htmlDocument.querySelectorAll(
    'script[type="application/ld+json"]',
  );

  for (var element in elements) {
    final jsonLdText = element.text.trim();
    if (jsonLdText.isNotEmpty) {
      if (buffer.isNotEmpty) {
        buffer.write('\n');
      }
      buffer.write(jsonLdText);
    }
  }

  return buffer.toString();
}
