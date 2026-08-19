import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/widgets/app_icons.dart';

void main() {
  testWidgets('all design SVG icons load and render without error', (
    tester,
  ) async {
    const icons = <String>[
      AppIcons.history,
      AppIcons.save,
      AppIcons.share,
      AppIcons.image,
      AppIcons.pdf,
      AppIcons.settings,
      AppIcons.search,
      AppIcons.delete,
      AppIcons.backspace,
      AppIcons.moon,
      AppIcons.sun,
      AppIcons.commit,
      AppIcons.newLine,
      AppIcons.commentJump,
      AppIcons.error,
      AppIcons.chevronDown,
      AppIcons.emptyLedger,
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Wrap(
          children: [
            for (final icon in icons)
              AppSvgIcon(icon, size: 24, color: const Color(0xFF14201D)),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppSvgIcon), findsNWidgets(icons.length));
    expect(tester.takeException(), isNull);
  });
}
