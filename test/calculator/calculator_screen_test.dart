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
import 'package:notaleq/features/calculator/data/repos/calculator_repository.dart';
import 'package:notaleq/features/calculator/presentation/cubit/calculator_cubit.dart';
import 'package:notaleq/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:notaleq/features/calculator/presentation/widgets/numpad_key.dart';
import 'package:notaleq/features/settings/data/repos/settings_repository.dart';
import 'package:notaleq/features/settings/presentation/cubit/settings_cubit.dart';
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
          builder: (_, __) => MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light,
            home: const CalculatorScreen(),
          ),
        ),
      );

  testWidgets('renders the ledger, numpad and total; typing updates the total',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Numpad keys present.
    expect(find.text('7'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
    // Total label.
    expect(find.text('الإجمالي'), findsWidgets);

    // Type 250 via the numpad keys → the active line shows the grouped amount.
    await tester.tap(find.widgetWithText(NumpadKey, '2'));
    await tester.tap(find.widgetWithText(NumpadKey, '5'));
    await tester.tap(find.widgetWithText(NumpadKey, '0'));
    await tester.pumpAndSettle();
    // The live total bar reflects the typed amount (the active line shows it too,
    // via a RichText caret span, which find.text doesn't traverse).
    expect(find.text('250'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
