import 'package:flutter/material.dart';

/// Ergonomic accessors off [BuildContext].
///
/// Note: design-system colors are reached with `context.colors`
/// (see `core/style/app_colors.dart`) and translations with `context.tr(...)`
/// (see `core/language/app_localizations.dart`).
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
