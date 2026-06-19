import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app/app.dart';
import 'core/bloc_observer.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await setUpInjector();
  runApp(const NotaleqApp());
}
