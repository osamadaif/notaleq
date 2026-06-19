import 'package:flutter/material.dart';

import '../../features/calculator/presentation/screens/calculator_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/history/presentation/screens/sheet_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';
import 'base_route.dart';

/// Central route table. Each route returns a [BaseRoute] (scale+fade transition).
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.history:
        return BaseRoute(page: const HistoryScreen(), settings: settings);
      case AppRoutes.sheetDetail:
        return BaseRoute(
          page: SheetDetailScreen(calculationId: settings.arguments! as int),
          settings: settings,
        );
      case AppRoutes.settings:
        return BaseRoute(page: const SettingsScreen(), settings: settings);
      case AppRoutes.calculator:
      default:
        return BaseRoute(page: const CalculatorScreen(), settings: settings);
    }
  }
}
