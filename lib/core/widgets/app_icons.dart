import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The exact icon set from the Claude Design handoff (1.8px stroke, rounded,
/// 24px grid), shipped as SVG assets under `assets/icons/` and rendered with
/// [AppSvgIcon]. Paths are authored with a solid stroke and recolored at render
/// time via [ColorFilter] (`BlendMode.srcIn`).
class AppIcons {
  AppIcons._();

  static const String _base = 'assets/icons';

  static const String history = '$_base/history.svg';
  static const String save = '$_base/save.svg';
  static const String settings = '$_base/settings.svg';
  static const String search = '$_base/search.svg';
  static const String delete = '$_base/delete.svg';
  static const String backspace = '$_base/backspace.svg';

  /// ✓✓ — commit / line-valid.
  static const String commit = '$_base/commit.svg';

  /// ＋ — new line.
  static const String newLine = '$_base/new_line.svg';

  /// Swap arrows — jump from the amount numpad to the comment field.
  static const String commentJump = '$_base/comment_jump.svg';

  /// ⚠ — flagged error line / destructive guard.
  static const String error = '$_base/error.svg';

  static const String chevronDown = '$_base/chevron_down.svg';

  /// Empty-state ledger glyph (lines + plus).
  static const String emptyLedger = '$_base/empty_ledger.svg';
}

/// Renders an [AppIcons] SVG asset at [size], tinted to [color].
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color,
  });

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
