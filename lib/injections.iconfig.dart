// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:infinite_scroll_list_example/services/item_service.dart';
import 'package:infinite_scroll_list_example/state/home_data_holder.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  //Eager singletons must be registered in the right order
  g.registerSingleton<ItemService>(ItemService());
  g.registerSingleton<HomeDataHolder>(HomeDataHolder(g<ItemService>()));
}
