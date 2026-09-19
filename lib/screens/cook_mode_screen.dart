import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../blocs/cook_mode/cook_mode_cubit.dart';
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../generated/l10n.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../services/cook_mode_completion_effects.dart';
import '../widgets/culinary_editorial_theme.dart';

class CookModeArguments {
  const CookModeArguments({
    required this.recipe,
    required this.effectiveIngredients,
  });

  final Recipe recipe;
  final List<List<Ingredient>> effectiveIngredients;
}

class CookModeScreen extends StatelessWidget {
  const CookModeScreen({
    super.key,
    required this.arguments,
    this.cubit,
    this.completionEffects,
  });

  final CookModeArguments arguments;
  final CookModeCubit? cubit;
  final CookModeCompletionEffects? completionEffects;

  @override
  Widget build(BuildContext context) {
    final content = _CookModeView(
      arguments: arguments,
      completionEffects: completionEffects,
    );
    if (cubit != null) {
      return BlocProvider<CookModeCubit>.value(value: cubit!, child: content);
    }
    return BlocProvider<CookModeCubit>(
      create: (_) => CookModeCubit(
        stepCount: arguments.recipe.steps.length,
        keepAwake: GlobalSettings().standbyDisabled(),
      ),
      child: content,
    );
  }
}

class _CookModeView extends StatefulWidget {
  const _CookModeView({required this.arguments, this.completionEffects});

  final CookModeArguments arguments;
  final CookModeCompletionEffects? completionEffects;

  @override
  State<_CookModeView> createState() => _CookModeViewState();
}

class _CookModeViewState extends State<_CookModeView>
    with WidgetsBindingObserver {
  late final CookModeCompletionEffects _completionEffects;
  late final bool _ownsCompletionEffects;
  bool? _previousWakelock;
  bool _allowPop = false;
  bool _completionSignaled = false;

  Recipe get _recipe => widget.arguments.recipe;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ownsCompletionEffects = widget.completionEffects == null;
    _completionEffects =
        widget.completionEffects ?? DeviceCookModeCompletionEffects();
    _captureAndApplyWakelock();
  }

  Future<void> _captureAndApplyWakelock() async {
    try {
      _previousWakelock = await WakelockPlus.enabled;
      if (!mounted) return;
      await WakelockPlus.toggle(
        enable: context.read<CookModeCubit>().state.keepAwake,
      );
    } catch (_) {
      // Wakelock may be unavailable in widget tests or on unsupported hosts.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<CookModeCubit>().syncTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final previous = _previousWakelock;
    if (previous != null) {
      WakelockPlus.toggle(enable: previous);
    }
    if (_ownsCompletionEffects) _completionEffects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: culinaryEditorialTheme(Theme.of(context), palette),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness: dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: BlocConsumer<CookModeCubit, CookModeState>(
          listenWhen: (previous, current) =>
              previous.timerStatus != current.timerStatus ||
              previous.keepAwake != current.keepAwake,
          listener: (context, state) async {
            final shouldSignalCompletion =
                state.timerStatus == CookTimerStatus.completed &&
                !_completionSignaled;
            if (state.timerStatus != CookTimerStatus.completed) {
              _completionSignaled = false;
            } else if (shouldSignalCompletion) {
              _completionSignaled = true;
            }
            try {
              await WakelockPlus.toggle(enable: state.keepAwake);
            } catch (_) {
              // Keep cook mode usable when the platform channel is absent.
            }
            if (shouldSignalCompletion) {
              await _signalTimerCompletion();
            }
          },
          builder: (context, state) {
            final hasSteps = _recipe.steps.isNotEmpty;
            return PopScope<Object?>(
              canPop: _allowPop || !state.hasActiveTimer,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) _requestExit();
              },
              child: Scaffold(
                key: const Key('cook-mode-screen'),
                backgroundColor: palette.background,
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _CookModeHeader(
                        recipe: _recipe,
                        state: state,
                        onClose: _requestExit,
                        onKeepAwakeChanged: (value) =>
                            context.read<CookModeCubit>().setKeepAwake(value),
                      ),
                      Expanded(
                        child: hasSteps
                            ? _CookStepContent(
                                arguments: widget.arguments,
                                state: state,
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    S.of(context).recipe_instructions_empty,
                                    textAlign: TextAlign.center,
                                    style: CulinaryEditorialType.body(
                                      palette,
                                      size: 16,
                                      color: palette.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: hasSteps
                    ? _CookModeDock(
                        state: state,
                        onSetTimer: _showTimerSheet,
                        onFinish: _finishCooking,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _signalTimerCompletion() async {
    try {
      await _completionEffects.signalCompletion();
    } catch (_) {
      // Visual completion feedback remains available if audio cannot play.
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        key: const Key('cook-timer-complete-banner'),
        content: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).cook_mode_timer_complete,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(S.of(context).cook_mode_timer_complete_message),
            ],
          ),
        ),
        action: SnackBarAction(
          label: S.of(context).cook_mode_restart_timer,
          onPressed: context.read<CookModeCubit>().restartTimer,
        ),
        showCloseIcon: true,
      ),
    );
  }

  Future<void> _requestExit() async {
    final cubit = context.read<CookModeCubit>();
    if (cubit.state.hasActiveTimer) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(S.of(dialogContext).cook_mode_exit_title),
          content: Text(S.of(dialogContext).cook_mode_exit_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(S.of(dialogContext).cook_mode_stay),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(S.of(dialogContext).cook_mode_end_session),
            ),
          ],
        ),
      );
      if (shouldExit != true || !mounted) return;
    }
    cubit.cancelTimer();
    _popCookMode();
  }

  Future<void> _finishCooking() async {
    final cubit = context.read<CookModeCubit>();
    final hasTimer = cubit.state.hasActiveTimer;
    final finish = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(dialogContext).cook_mode_finish_title),
        content: Text(
          hasTimer
              ? S.of(dialogContext).cook_mode_finish_timer_message
              : S.of(dialogContext).cook_mode_finish_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(dialogContext).cook_mode_stay),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              hasTimer
                  ? S.of(dialogContext).cook_mode_finish_and_stop
                  : S.of(dialogContext).cook_mode_finish,
            ),
          ),
        ],
      ),
    );
    if (finish != true || !mounted) return;
    cubit.cancelTimer();
    _popCookMode();
  }

  void _popCookMode() {
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _showTimerSheet() async {
    final cubit = context.read<CookModeCubit>();
    final palette = CulinaryEditorialPalette.of(context);
    final sheetTheme = culinaryEditorialTheme(Theme.of(context), palette);
    final duration = await showModalBottomSheet<Duration>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: palette.surface,
      barrierColor: Colors.black.withValues(alpha: .62),
      builder: (context) => Theme(
        data: sheetTheme,
        child: _TimerDurationSheet(
          initialDuration: cubit.state.hasConfiguredTimer
              ? cubit.state.timerDuration
              : const Duration(minutes: 10),
        ),
      ),
    );
    if (duration != null && mounted) cubit.setTimer(duration);
  }
}

class _CookModeHeader extends StatelessWidget {
  const _CookModeHeader({
    required this.recipe,
    required this.state,
    required this.onClose,
    required this.onKeepAwakeChanged,
  });

  final Recipe recipe;
  final CookModeState state;
  final VoidCallback onClose;
  final ValueChanged<bool> onKeepAwakeChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final total = recipe.steps.length;
    final step = total == 0 ? 0 : state.currentStep + 1;
    final percent = total == 0 ? 0 : ((step / total) * 100).round();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 58),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('cook-mode-close'),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).cook_mode_title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CulinaryEditorialType.headline(
                            palette,
                            size: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: palette.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                S.of(context).cook_mode_assistant.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: palette.onSurfaceVariant,
                                  letterSpacing: .8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    key: const Key('cook-mode-keep-awake'),
                    tooltip: state.keepAwake
                        ? S.of(context).cook_mode_allow_sleep
                        : S.of(context).cook_mode_keep_awake,
                    onPressed: () => onKeepAwakeChanged(!state.keepAwake),
                    icon: Icon(
                      state.keepAwake
                          ? Icons.light_mode_rounded
                          : Icons.bedtime_outlined,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: state.keepAwake
                          ? palette.primarySoft
                          : palette.surfaceContainer,
                      foregroundColor: state.keepAwake
                          ? palette.primary
                          : palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).cook_mode_step_progress(step, total),
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w700,
                      color: palette.onSurfaceVariant,
                      letterSpacing: .45,
                    ),
                  ),
                ),
                Text(
                  S.of(context).cook_mode_percent_complete(percent),
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 12,
                    weight: FontWeight.w700,
                    color: palette.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Semantics(
              key: const Key('cook-mode-step-progress'),
              label: S.of(context).cook_mode_step_progress(step, total),
              value: S.of(context).cook_mode_percent_complete(percent),
              child: ExcludeSemantics(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (total == 0) return const SizedBox(height: 5);
                    final gap = total > 12 ? 2.0 : 5.0;
                    return Row(
                      children: List.generate(
                        total,
                        (index) => Expanded(
                          child: AnimatedContainer(
                            key: Key('cook-mode-step-segment-$index'),
                            duration: GlobalSettings().animationsEnabled()
                                ? const Duration(milliseconds: 180)
                                : Duration.zero,
                            curve: Curves.easeOutCubic,
                            height: 5,
                            margin: EdgeInsets.only(
                              right: index == total - 1 ? 0 : gap,
                            ),
                            decoration: BoxDecoration(
                              color: index < step
                                  ? palette.primary
                                  : palette.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CookStepContent extends StatelessWidget {
  const _CookStepContent({required this.arguments, required this.state});

  final CookModeArguments arguments;
  final CookModeState state;

  @override
  Widget build(BuildContext context) {
    final recipe = arguments.recipe;
    final index = state.currentStep.clamp(0, recipe.steps.length - 1);
    final title =
        index < (recipe.stepTitles?.length ?? 0) &&
            recipe.stepTitles![index].trim().isNotEmpty
        ? recipe.stepTitles![index].trim()
        : S.of(context).cook_mode_step_fallback(index + 1);
    final ingredients = _ingredientsForStep(arguments, index);
    final stepImages = index < recipe.stepImages.length
        ? recipe.stepImages[index]
        : const <String>[];
    final wide = MediaQuery.sizeOf(context).width >= 600;
    final media = _StepMedia(paths: stepImages, fallbackPath: recipe.imagePath);
    final ingredientPanel = _StepIngredients(
      ingredients: ingredients,
      preparedIds: state.preparedIngredientIds,
    );
    final instructions = _StepInstructions(description: recipe.steps[index]);
    return KeyedSubtree(
      key: ValueKey('cook-mode-step-content-$index'),
      child: SingleChildScrollView(
        key: const Key('cook-mode-scroll-view'),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StepHeading(recipe: recipe, title: title),
                const SizedBox(height: 20),
                if (!wide)
                  Column(
                    key: const Key('cook-mode-compact-layout'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      media,
                      const SizedBox(height: 26),
                      ingredientPanel,
                      const SizedBox(height: 30),
                      instructions,
                    ],
                  )
                else
                  Row(
                    key: const Key('cook-mode-wide-layout'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            media,
                            const SizedBox(height: 24),
                            ingredientPanel,
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(flex: 5, child: instructions),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.recipe, required this.title});

  final Recipe recipe;
  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: palette.secondarySoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            S.of(context).cook_mode_active_phase(recipe.name).toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CulinaryEditorialType.body(
              palette,
              size: 10,
              weight: FontWeight.w700,
              color: palette.secondary,
              letterSpacing: .55,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: CulinaryEditorialType.headline(
            palette,
            size: 29,
            weight: FontWeight.w600,
            height: 1.16,
          ),
        ),
      ],
    );
  }
}

class _StepMedia extends StatefulWidget {
  const _StepMedia({required this.paths, required this.fallbackPath});

  final List<String> paths;
  final String fallbackPath;

  @override
  State<_StepMedia> createState() => _StepMediaState();
}

class _StepMediaState extends State<_StepMedia> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final paths = widget.paths.isEmpty ? [widget.fallbackPath] : widget.paths;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ColoredBox(
              color: palette.surfaceContainer,
              child: PageView.builder(
                key: const Key('cook-mode-step-images'),
                itemCount: paths.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) => _CookImage(path: paths[index]),
              ),
            ),
          ),
        ),
        if (paths.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              paths.length,
              (index) => AnimatedContainer(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                width: index == _page ? 22 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == _page
                      ? palette.primary
                      : palette.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CookImage extends StatelessWidget {
  const _CookImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      constants.noRecipeImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
    if (path.startsWith('images/') || path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => fallback,
      );
    }
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _CookIngredient {
  const _CookIngredient({required this.id, required this.value});

  final String id;
  final Ingredient value;
}

List<_CookIngredient> _ingredientsForStep(
  CookModeArguments arguments,
  int stepIndex,
) {
  final recipe = arguments.recipe;
  if (stepIndex >= recipe.stepIngredientIds.length) return const [];
  final assigned = recipe.stepIngredientIds[stepIndex].toSet();
  if (assigned.isEmpty) return const [];
  final result = <_CookIngredient>[];
  for (var section = 0; section < recipe.ingredients.length; section++) {
    for (var index = 0; index < recipe.ingredients[section].length; index++) {
      final original = recipe.ingredients[section][index];
      final id = original.id;
      if (id == null || !assigned.contains(id)) continue;
      final effective =
          section < arguments.effectiveIngredients.length &&
              index < arguments.effectiveIngredients[section].length
          ? arguments.effectiveIngredients[section][index]
          : original;
      result.add(_CookIngredient(id: id, value: effective));
    }
  }
  return result;
}

class _StepIngredients extends StatelessWidget {
  const _StepIngredients({
    required this.ingredients,
    required this.preparedIds,
  });

  final List<_CookIngredient> ingredients;
  final Set<String> preparedIds;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S
              .of(context)
              .cook_mode_required_ingredients(ingredients.length)
              .toUpperCase(),
          style: CulinaryEditorialType.body(
            palette,
            size: 11,
            weight: FontWeight.w700,
            color: palette.onSurfaceVariant,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 10),
        if (ingredients.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              S.of(context).cook_mode_no_assigned_ingredients,
              style: CulinaryEditorialType.body(
                palette,
                size: 14,
                color: palette.onSurfaceVariant,
              ),
            ),
          )
        else
          ...ingredients.map((ingredient) {
            final prepared = preparedIds.contains(ingredient.id);
            final label = _ingredientLabel(ingredient.value);
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Semantics(
                checked: prepared,
                button: true,
                label: label,
                child: Material(
                  color: prepared ? palette.secondarySoft : palette.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    key: Key('cook-ingredient-${ingredient.id}'),
                    onTap: () => context.read<CookModeCubit>().toggleIngredient(
                      ingredient.id,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 56),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? Duration.zero
                                  : const Duration(milliseconds: 180),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: prepared
                                    ? palette.secondary
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: prepared
                                    ? null
                                    : Border.all(
                                        color: palette.outline,
                                        width: 2,
                                      ),
                              ),
                              child: prepared
                                  ? Icon(
                                      Icons.check,
                                      size: 17,
                                      color: palette.background,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label,
                                style:
                                    CulinaryEditorialType.body(
                                      palette,
                                      size: 14,
                                      weight: FontWeight.w600,
                                    ).copyWith(
                                      decoration: prepared
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: prepared
                                          ? palette.onSurfaceVariant
                                          : palette.onSurface,
                                    ),
                              ),
                            ),
                            if (prepared) ...[
                              const SizedBox(width: 8),
                              Text(
                                S.of(context).cook_mode_prepared,
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
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

String _ingredientLabel(Ingredient ingredient) {
  final amount = ingredient.amount == null
      ? ''
      : ingredient.amount! % 1 == 0
      ? ingredient.amount!.toInt().toString()
      : ingredient.amount!
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
  return [amount, ingredient.unit, ingredient.name]
      .where((part) => part != null && part.toString().trim().isNotEmpty)
      .join(' ');
}

class _StepInstructions extends StatelessWidget {
  const _StepInstructions({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.format_list_numbered, color: palette.primary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                S.of(context).cook_mode_step_instructions,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 19,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            description,
            style: CulinaryEditorialType.body(palette, size: 16, height: 1.58),
          ),
        ),
      ],
    );
  }
}

class _CookModeDock extends StatelessWidget {
  const _CookModeDock({
    required this.state,
    required this.onSetTimer,
    required this.onFinish,
  });

  final CookModeState state;
  final VoidCallback onSetTimer;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final cubit = context.read<CookModeCubit>();
    final lastStep = state.currentStep >= cubit.stepCount - 1;
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.background,
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 22,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CookTimerCard(state: state, onSetTimer: onSetTimer),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('cook-mode-previous'),
                          onPressed: state.currentStep == 0
                              ? null
                              : cubit.previousStep,
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: Text(S.of(context).cook_mode_previous),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            foregroundColor: palette.onSurface,
                            side: BorderSide(
                              color: palette.outline.withValues(alpha: .45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          key: const Key('cook-mode-next'),
                          onPressed: lastStep ? onFinish : cubit.nextStep,
                          iconAlignment: IconAlignment.end,
                          icon: Icon(
                            lastStep
                                ? Icons.flag_outlined
                                : Icons.arrow_forward,
                            size: 18,
                          ),
                          label: Text(
                            lastStep
                                ? S.of(context).cook_mode_finish
                                : S.of(context).cook_mode_next,
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            backgroundColor: palette.primary,
                            foregroundColor: palette.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _CookTimerCard extends StatefulWidget {
  const _CookTimerCard({required this.state, required this.onSetTimer});

  final CookModeState state;
  final VoidCallback onSetTimer;

  @override
  State<_CookTimerCard> createState() => _CookTimerCardState();
}

class _CookTimerCardState extends State<_CookTimerCard> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final state = widget.state;
    return Material(
      key: const Key('cook-mode-timer-card'),
      color: palette.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: palette.shadow,
      child: AnimatedSize(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: _collapsed
              ? const EdgeInsets.fromLTRB(12, 4, 4, 4)
              : const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: _collapsed
              ? _CollapsedTimer(
                  state: state,
                  onExpand: () => setState(() => _collapsed = false),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ExpandedTimerHeader(
                      onSetTimer: widget.onSetTimer,
                      onCollapse: () => setState(() => _collapsed = true),
                    ),
                    _ExpandedTimer(state: state),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ExpandedTimerHeader extends StatelessWidget {
  const _ExpandedTimerHeader({
    required this.onSetTimer,
    required this.onCollapse,
  });

  final VoidCallback onSetTimer;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 19, color: palette.primary),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            S.of(context).cook_mode_timer.toUpperCase(),
            style: CulinaryEditorialType.body(
              palette,
              size: 11,
              weight: FontWeight.w700,
              letterSpacing: .55,
            ),
          ),
        ),
        TextButton.icon(
          key: const Key('cook-mode-set-timer'),
          onPressed: onSetTimer,
          icon: const Icon(Icons.edit_outlined, size: 17),
          label: Text(S.of(context).cook_mode_set_timer),
        ),
        IconButton(
          key: const Key('cook-mode-collapse-timer'),
          tooltip: S.of(context).cook_mode_collapse_timer,
          onPressed: onCollapse,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }
}

class _CollapsedTimer extends StatelessWidget {
  const _CollapsedTimer({required this.state, required this.onExpand});

  final CookModeState state;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 19, color: palette.primary),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            S.of(context).cook_mode_timer.toUpperCase(),
            style: CulinaryEditorialType.body(
              palette,
              size: 11,
              weight: FontWeight.w700,
              letterSpacing: .55,
            ),
          ),
        ),
        Semantics(
          label: S.of(context).cook_mode_timer,
          value: _formatDuration(state.remaining),
          excludeSemantics: true,
          child: Text(
            state.hasConfiguredTimer
                ? _formatDuration(state.remaining)
                : '--:--',
            key: const Key('cook-mode-timer-display-collapsed'),
            style: CulinaryEditorialType.body(
              palette,
              size: 20,
              weight: FontWeight.w700,
            ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ),
        const SizedBox(width: 4),
        _TimerPrimaryButton(state: state),
        IconButton(
          key: const Key('cook-mode-collapse-timer'),
          tooltip: S.of(context).cook_mode_expand_timer,
          onPressed: onExpand,
          icon: const Icon(Icons.keyboard_arrow_up),
        ),
      ],
    );
  }
}

class _ExpandedTimer extends StatelessWidget {
  const _ExpandedTimer({required this.state});

  final CookModeState state;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final cubit = context.read<CookModeCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, color: palette.surfaceContainerHigh),
        const SizedBox(height: 9),
        Row(
          children: [
            SizedBox.square(
              dimension: 46,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    key: const Key('cook-mode-timer-progress'),
                    value: state.hasConfiguredTimer ? state.timerProgress : 0,
                    strokeWidth: 4,
                    backgroundColor: palette.surfaceContainerHigh,
                    color: state.timerStatus == CookTimerStatus.completed
                        ? palette.secondary
                        : palette.primary,
                  ),
                  Icon(
                    state.timerStatus == CookTimerStatus.completed
                        ? Icons.check
                        : Icons.schedule,
                    size: 19,
                    color: state.timerStatus == CookTimerStatus.completed
                        ? palette.secondary
                        : palette.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: S.of(context).cook_mode_timer,
                value: _formatDuration(state.remaining),
                excludeSemantics: true,
                child: Text(
                  state.hasConfiguredTimer
                      ? _formatDuration(state.remaining)
                      : '--:--',
                  key: const Key('cook-mode-timer-display'),
                  style:
                      CulinaryEditorialType.body(
                        palette,
                        size: 24,
                        weight: FontWeight.w700,
                      ).copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
            ),
            if (state.hasConfiguredTimer) ...[
              TextButton(
                key: const Key('cook-mode-add-minute'),
                onPressed: cubit.addMinute,
                child: Text(S.of(context).cook_mode_add_minute_compact),
              ),
              IconButton(
                key: const Key('cook-mode-reset-timer'),
                tooltip: S.of(context).cook_mode_reset_timer,
                onPressed: cubit.resetTimer,
                icon: const Icon(Icons.replay),
              ),
              IconButton(
                key: const Key('cook-mode-cancel-timer'),
                tooltip: S.of(context).cook_mode_cancel_timer,
                onPressed: cubit.cancelTimer,
                icon: const Icon(Icons.close),
              ),
            ],
            _TimerPrimaryButton(state: state),
          ],
        ),
      ],
    );
  }
}

class _TimerPrimaryButton extends StatelessWidget {
  const _TimerPrimaryButton({required this.state});

  final CookModeState state;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final cubit = context.read<CookModeCubit>();
    final (icon, tooltip, callback) = switch (state.timerStatus) {
      CookTimerStatus.running => (
        Icons.pause,
        S.of(context).cook_mode_pause_timer,
        cubit.pauseTimer,
      ),
      CookTimerStatus.paused => (
        Icons.play_arrow,
        S.of(context).cook_mode_resume_timer,
        cubit.resumeTimer,
      ),
      CookTimerStatus.completed => (
        Icons.replay,
        S.of(context).cook_mode_restart_timer,
        cubit.restartTimer,
      ),
      CookTimerStatus.idle => (
        Icons.play_arrow,
        S.of(context).cook_mode_start_timer,
        cubit.startTimer,
      ),
    };
    return IconButton.filled(
      key: const Key('cook-mode-toggle-timer'),
      tooltip: tooltip,
      onPressed: state.hasConfiguredTimer ? callback : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size.square(48),
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        disabledBackgroundColor: palette.surfaceContainerHigh,
        disabledForegroundColor: palette.onSurfaceVariant,
      ),
    );
  }
}

class _TimerDurationSheet extends StatefulWidget {
  const _TimerDurationSheet({required this.initialDuration});

  final Duration initialDuration;

  @override
  State<_TimerDurationSheet> createState() => _TimerDurationSheetState();
}

class _TimerDurationSheetState extends State<_TimerDurationSheet> {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController(
      text: widget.initialDuration.inHours.toString(),
    );
    _minutesController = TextEditingController(
      text: (widget.initialDuration.inMinutes % 60).toString(),
    );
    _secondsController = TextEditingController(
      text: (widget.initialDuration.inSeconds % 60).toString(),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                S.of(context).cook_mode_timer_sheet_title,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 24,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('cook-timer-hours'),
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: S.of(context).cook_mode_timer_hours,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('cook-timer-minutes'),
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: S.of(context).cook_mode_timer_minutes,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('cook-timer-seconds'),
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: S.of(context).cook_mode_timer_seconds,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('cook-timer-save'),
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(S.of(context).cook_mode_timer_save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
    if (duration <= Duration.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).cook_mode_timer_invalid)),
      );
      return;
    }
    Navigator.pop(context, duration);
  }
}

String _formatDuration(Duration duration) {
  final seconds = ((duration.inMilliseconds + 999) ~/ 1000).clamp(0, 359999);
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainder = seconds % 60;
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainder.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:'
      '${remainder.toString().padLeft(2, '0')}';
}
