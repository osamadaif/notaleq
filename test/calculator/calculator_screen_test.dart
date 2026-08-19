import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';
import 'package:notaleq/core/di/injection_container.dart';
import 'package:notaleq/core/language/app_localizations.dart';
import 'package:notaleq/core/style/app_theme.dart';
import 'package:notaleq/core/widgets/app_icons.dart';
import 'package:notaleq/features/calculator/data/repos/calculator_repository.dart';
import 'package:notaleq/features/calculator/presentation/cubit/calculator_cubit.dart';
import 'package:notaleq/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:notaleq/features/calculator/presentation/widgets/numpad.dart';
import 'package:notaleq/features/calculator/presentation/widgets/numpad_key.dart';
import 'package:notaleq/features/calculator/presentation/widgets/total_bar.dart';
import 'package:notaleq/features/settings/data/repos/settings_repository.dart';
import 'package:notaleq/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:notaleq/features/settings/presentation/cubit/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await getIt.reset();
    getIt.registerFactory<CalculatorCubit>(
      () => CalculatorCubit(CalculatorRepository(db, prefs)),
    );
  });

  tearDown(() async {
    await getIt.reset();
    await db.close();
  });

  Widget app() => BlocProvider<SettingsCubit>(
    create: (_) => SettingsCubit(SettingsRepository(prefs)),
    child: ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) => BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) => MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: const CalculatorScreen(),
        ),
      ),
    ),
  );

  testWidgets('revised calculator controls render and work', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('7'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
    expect(find.text('00'), findsOneWidget);
    expect(find.text('الإجمالي'), findsWidgets);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.share,
      ),
      findsOneWidget,
    );

    final commentJump = find.byWidgetPredicate(
      (widget) => widget is AppSvgIcon && widget.asset == AppIcons.commentJump,
    );
    final numpad = find.byType(Numpad);
    expect(commentJump, findsOneWidget);
    expect(find.descendant(of: numpad, matching: commentJump), findsNothing);
    expect(
      tester.getCenter(commentJump).dy,
      closeTo(tester.getCenter(find.byType(TotalBar)).dy, 0.1),
    );

    final ac = find.widgetWithText(NumpadKey, 'AC');
    final openParen = find.widgetWithText(NumpadKey, '(');
    final doubleZero = find.widgetWithText(NumpadKey, '00');
    final zero = find.widgetWithText(NumpadKey, '0');
    expect(
      tester.getCenter(ac).dy,
      closeTo(tester.getCenter(openParen).dy, 0.1),
    );
    expect(
      tester.getCenter(doubleZero).dy,
      closeTo(tester.getCenter(zero).dy, 0.1),
    );

    final screenContext = tester.element(find.byType(CalculatorScreen));
    final settingsCubit = screenContext.read<SettingsCubit>();
    expect(settingsCubit.state.themeMode, ThemeMode.system);
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.moon,
      ),
    );
    await tester.pumpAndSettle();
    expect(settingsCubit.state.themeMode, ThemeMode.dark);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.sun,
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.sun,
      ),
    );
    await tester.pumpAndSettle();
    expect(settingsCubit.state.themeMode, ThemeMode.light);

    await tester.tap(find.widgetWithText(NumpadKey, '2'));
    await tester.tap(find.widgetWithText(NumpadKey, '5'));
    await tester.tap(find.widgetWithText(NumpadKey, '00'));
    await tester.pumpAndSettle();
    expect(find.text('2,500'), findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.share,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('مشاركة الورقة'), findsOneWidget);
    expect(find.text('صورة'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.image,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppIcons.pdf,
      ),
      findsOneWidget,
    );
    Navigator.of(screenContext).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NumpadKey, '='));
    await tester.pumpAndSettle();
    expect(find.text('المجموع الفرعي'), findsOneWidget);

    await tester.tap(find.widgetWithText(NumpadKey, '+'));
    await tester.pump();
    await tester.tap(find.widgetWithText(NumpadKey, '5'));
    await tester.tap(find.widgetWithText(NumpadKey, '0'));
    await tester.pumpAndSettle();
    expect(find.text('2,550'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
