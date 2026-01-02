import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// [sl] serveice locater is used for
/// inject the dependency
final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default init
  preferRelativeImports: true, // default true
  asExtension: false,
)

/// [configureDependency] setup the dependency
Future<void> configureDependency() async {
  // [init] generated method
  await init(
    sl,
  );
}
