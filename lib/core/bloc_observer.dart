import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs Cubit lifecycle + state transitions in debug builds only.
///
/// Wire it up in `main()` before `runApp`:
/// ```dart
/// Bloc.observer = AppBlocObserver();
/// ```
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint(
        '${bloc.runtimeType}: ${change.currentState} '
        '→ ${change.nextState}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('${bloc.runtimeType} error: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
