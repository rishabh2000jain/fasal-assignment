import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_config.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => $initGetIt(getIt);