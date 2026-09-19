import 'package:flutter/material.dart';

/// Keeps the recipe image's shared-element flight as the primary motion while
/// the surrounding detail surface fades into place.
class RecipeDetailPageRoute<T> extends PageRouteBuilder<T> {
  RecipeDetailPageRoute({
    required WidgetBuilder builder,
    required bool motionEnabled,
    super.settings,
  }) : super(
         transitionDuration: motionEnabled
             ? const Duration(milliseconds: 400)
             : Duration.zero,
         reverseTransitionDuration: motionEnabled
             ? const Duration(milliseconds: 300)
             : Duration.zero,
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           if (!motionEnabled) return child;

           return FadeTransition(
             opacity: CurvedAnimation(
               parent: animation,
               curve: const Interval(0.18, 0.72, curve: Curves.easeOutCubic),
               reverseCurve: const Interval(0, 0.82, curve: Curves.easeInCubic),
             ),
             child: child,
           );
         },
       );
}
