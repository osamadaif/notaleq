/// Named-route constants. Add a constant here as the first step when adding a
/// route (then register the Cubit in `injection_container.dart`, then add the
/// `case` in `AppRouter`).
class AppRoutes {
  AppRoutes._();

  /// Calculator (ledger) — the hub / home screen.
  static const String calculator = '/';

  /// History of saved sheets.
  static const String history = '/history';

  /// Read-only detail of a saved sheet (arg: the sheet id as `int`).
  static const String sheetDetail = '/history/detail';

  /// Settings.
  static const String settings = '/settings';
}
