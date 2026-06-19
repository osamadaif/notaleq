import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/format/currencies.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/segmented_control.dart';
import '../../../../core/widgets/stepper_row.dart';
import '../../../../core/widgets/toggle_row.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// Supported languages, shown in their own native name. `null` = follow device.
  static const Map<String, String> _languageNames = {
    'ar': 'العربية',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'zh': '中文',
    'hi': 'हिन्दी',
  };

  String _languageLabel(BuildContext context, String? code) =>
      code == null ? context.tr(LangKeys.themeSystem) : _languageNames[code]!;

  Future<void> _pickLanguage(
      BuildContext context, SettingsCubit cubit, String? current) {
    final c = context.colors;
    final codes = <String?>[null, ..._languageNames.keys];
    return showAppBottomSheet<void>(
      context: context,
      title: context.tr(LangKeys.language),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final code in codes)
            InkWell(
              onTap: () {
                cubit.setLanguageCode(code);
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _languageLabel(context, code),
                        style: AppTextStyles.body.copyWith(
                          color: code == current ? c.accent : c.textPrimary,
                          fontWeight:
                              code == current ? FontWeight.w600 : null,
                        ),
                      ),
                    ),
                    if (code == current)
                      AppSvgIcon(AppIcons.commit, size: 18, color: c.accent),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _currencyLabel(BuildContext context, String? code) => code == null
      ? context.tr(LangKeys.currencyNone)
      : context.tr(Currencies.nameKey(code));

  Future<void> _pickCurrency(
      BuildContext context, SettingsCubit cubit, String? current) {
    final c = context.colors;
    final codes = <String?>[null, ...Currencies.codes];
    return showAppBottomSheet<void>(
      context: context,
      title: context.tr(LangKeys.currency),
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.5,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final code in codes)
                InkWell(
                  onTap: () {
                    cubit.setCurrencyCode(code);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _currencyLabel(context, code),
                            style: AppTextStyles.body.copyWith(
                              color:
                                  code == current ? c.accent : c.textPrimary,
                              fontWeight:
                                  code == current ? FontWeight.w600 : null,
                            ),
                          ),
                        ),
                        if (code != null) ...[
                          Text(
                            context.tr(Currencies.symbolKey(code)),
                            style: AppTextStyles.body
                                .copyWith(color: c.textMuted),
                          ),
                          SizedBox(width: AppSpacing.md),
                        ],
                        if (code == current)
                          AppSvgIcon(AppIcons.commit,
                              size: 18, color: c.accent),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final cubit = context.read<SettingsCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.appBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.tr(LangKeys.settings),
          style: AppTextStyles.title.copyWith(color: c.textPrimary),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            children: [
              InkWell(
                onTap: () =>
                    _pickLanguage(context, cubit, state.languageCode),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr(LangKeys.language),
                          style: AppTextStyles.body
                              .copyWith(color: c.textPrimary),
                        ),
                      ),
                      Text(
                        _languageLabel(context, state.languageCode),
                        style: AppTextStyles.body.copyWith(color: c.textMuted),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      AppSvgIcon(AppIcons.chevronDown,
                          size: 16, color: c.textMuted),
                    ],
                  ),
                ),
              ),
              _divider(c),
              ToggleRow(
                label: context.tr(LangKeys.clickSound),
                value: state.soundEnabled,
                onChanged: cubit.setSoundEnabled,
              ),
              _divider(c),
              ToggleRow(
                label: context.tr(LangKeys.haptics),
                value: state.hapticEnabled,
                onChanged: cubit.setHapticEnabled,
              ),
              _divider(c),
              StepperRow(
                label: context.tr(LangKeys.decimalPlaces),
                value: state.decimalPlaces,
                onChanged: cubit.setDecimalPlaces,
              ),
              _divider(c),
              InkWell(
                onTap: () =>
                    _pickCurrency(context, cubit, state.currencyCode),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr(LangKeys.currency),
                          style: AppTextStyles.body
                              .copyWith(color: c.textPrimary),
                        ),
                      ),
                      Text(
                        _currencyLabel(context, state.currencyCode),
                        style: AppTextStyles.body.copyWith(color: c.textMuted),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      AppSvgIcon(AppIcons.chevronDown,
                          size: 16, color: c.textMuted),
                    ],
                  ),
                ),
              ),
              _divider(c),
              _section(c, context.tr(LangKeys.themeMode)),
              SegmentedControl<ThemeMode>(
                value: state.themeMode,
                onChanged: cubit.setThemeMode,
                segments: [
                  SegmentOption(
                      label: context.tr(LangKeys.themeLight),
                      value: ThemeMode.light),
                  SegmentOption(
                      label: context.tr(LangKeys.themeDark),
                      value: ThemeMode.dark),
                  SegmentOption(
                      label: context.tr(LangKeys.themeSystem),
                      value: ThemeMode.system),
                ],
              ),
              _divider(c),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      context.tr(LangKeys.about),
                      style: AppTextStyles.body.copyWith(color: c.textPrimary),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      state.appVersion.isEmpty
                          ? context.tr(LangKeys.appName)
                          : '${context.tr(LangKeys.appName)} · ${state.appVersion}',
                      style: AppTextStyles.comment.copyWith(color: c.textMuted),
                    ),
                    /// developed by
                    SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${context.tr(LangKeys.developedBy)}: ',
                          style: AppTextStyles.body.copyWith(color: c.textMuted),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          context.tr(LangKeys.developerName),
                          style: AppTextStyles.body.copyWith(color: c.accent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(AppColors c, String label) => Padding(
        padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
        child: Text(
          label,
          style: AppTextStyles.sectionHeader.copyWith(color: c.textMuted),
        ),
      );

  Widget _divider(AppColors c) => Divider(color: c.hairline, height: 1);
}
