import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_list_example/injections.iconfig.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.I;

@injectableInit
void configureInjection() {
  $initGetIt(getIt);
}