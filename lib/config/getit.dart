import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

import "getit.config.dart";

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: "init",
  preferRelativeImports: true,
  asExtension: true,
)
Future configureDependencies() => getIt.init();
