import 'package:flutter/material.dart';

import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_buttons.dart';

/// Shows the "Save sheet" bottom sheet (name prefilled). Returns the chosen
/// name, or null if cancelled.
Future<String?> showSaveSheet(BuildContext context, {required String initialName}) {
  return showAppBottomSheet<String>(
    context: context,
    title: context.tr(LangKeys.saveSheet),
    builder: (_) => _SaveSheetForm(initialName: initialName),
  );
}

class _SaveSheetForm extends StatefulWidget {
  const _SaveSheetForm({required this.initialName});
  final String initialName;

  @override
  State<_SaveSheetForm> createState() => _SaveSheetFormState();
}

class _SaveSheetFormState extends State<_SaveSheetForm> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: c.appBg,
            border: Border.all(color: c.hairline),
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            cursorColor: c.accent,
            style: AppTextStyles.body.copyWith(color: c.textPrimary),
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: AppSpacing.md + 1),
              border: InputBorder.none,
              hintText: context.tr(LangKeys.sheetNameHint),
              hintStyle: AppTextStyles.body.copyWith(color: c.textMuted),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: context.tr(LangKeys.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: PrimaryButton(
                label: context.tr(LangKeys.save),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
