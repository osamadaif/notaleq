import 'package:flutter/material.dart';

import '../style/app_dimens.dart';

/// Shared page transition: a calm scale + fade, matching the design's restrained
/// motion. Every named route is wrapped in a [BaseRoute] from `AppRouter`.
class BaseRoute<T> extends PageRouteBuilder<T> {
  BaseRoute({required this.page, super.settings})
      : super(
          transitionDuration: AppMotion.pageTransition,
          reverseTransitionDuration: AppMotion.pageTransition,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
                child: child,
              ),
            );
          },
        );

  final Widget page;
}
