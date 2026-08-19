import 'package:drift/drift.dart' show Value;
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
import 'package:notaleq/features/history/data/repos/history_repository.dart';
import 'package:notaleq/features/export/presentation/cubit/export_gate_cubit.dart';
import 'package:notaleq/features/history/presentation/cubit/sheet_detail_cubit.dart';
import 'package:notaleq/features/history/presentation/screens/sheet_detail_screen.dart';
import 'package:notaleq/features/settings/data/repos/settings_repository.dart';
import 'package:notaleq/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../export/export_gate_fakes.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await getIt.reset();
    getIt.registerFactory<SheetDetailCubit>(
      () =>
          SheetDetailCubit(HistoryRepository(db.calculationsDao, db.linesDao)),
    );
    getIt.registerFactory<ExportGateCubit>(
      () => ExportGateCubit(FakeExportNetworkStatus(), FakeRewardedAdManager()),
    );
  });

  tearDown(() async {
    await getIt.reset();
    await db.close();
  });

  Future<int> savedSheet() async {
    final id = await db.calculationsDao.createDraft();
    await db.linesDao.insertLine(
      LinesCompanion.insert(
        calculationId: id,
        position: 0,
        rawExpression: const Value('1250'),
        computedValue: const Value('1250'),
        comment: const Value('إيجار'),
      ),
    );
    await db.calculationsDao.updateCachedTotal(id, '1250');
    await db.calculationsDao.saveAs(id, 'مصاريف الشهر');
    return id;
  }

  Widget app(int calculationId) => BlocProvider<SettingsCubit>(
    create: (_) => SettingsCubit(SettingsRepository(prefs)),
    child: ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light,
        home: SheetDetailScreen(calculationId: calculationId),
      ),
    ),
  );

  testWidgets('saved sheet shows direct image and PDF export actions', (
    tester,
  ) async {
    final calculationId = await savedSheet();
    await tester.pumpWidget(app(calculationId));
    await tester.pumpAndSettle();

    expect(find.text('مصاريف الشهر'), findsOneWidget);
    expect(find.text('1,250'), findsWidgets);
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
    expect(tester.takeException(), isNull);
  });
}
