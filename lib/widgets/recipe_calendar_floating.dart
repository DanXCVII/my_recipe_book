import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/app/app_bloc.dart';
import '../screens/recipe_calendar_screen.dart';
import 'culinary_editorial_theme.dart';

class RecipeCalendarFloating extends StatelessWidget {
  const RecipeCalendarFloating({required this.initialPosition, super.key});

  final Offset initialPosition;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Positioned(
      left: initialPosition.dx,
      top: initialPosition.dy,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          final visible = state is LoadedState && state.recipeCalendarOpen;
          return Material(
            color: Colors.transparent,
            child: AnimatedSize(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: visible
                  ? _FloatingCalendarPanel(palette: palette)
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}

class _FloatingCalendarPanel extends StatelessWidget {
  const _FloatingCalendarPanel({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final panelHeight = MediaQuery.sizeOf(context).height > 800
        ? 720.0
        : MediaQuery.sizeOf(context).height - 80;
    return SizedBox(
      width: 420,
      height: panelHeight + 28,
      child: Stack(
        children: [
          Positioned.fill(
            top: 20,
            right: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: ColoredBox(
                color: palette.background,
                child: const RecipeCalendarContent(embedded: true),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Material(
              color: palette.surface,
              elevation: 5,
              shadowColor: palette.shadow,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                style: IconButton.styleFrom(
                  foregroundColor: palette.onSurfaceVariant,
                ),
                onPressed: () => context.read<AppBloc>().add(
                  const ChangeRecipeCalendarView(false),
                ),
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
