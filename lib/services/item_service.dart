import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:infinite_scroll_list_example/models/item.dart';
import 'package:injectable/injectable.dart';

@singleton
class ItemService {

  Future<List<Item>> getItems(int pageIndex) async {
    print('getItems page index: $pageIndex');
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final String text = await rootBundle.loadString('assets/json/items_${pageIndex % 3 + 1}.json');
      final List<dynamic> root = json.decode(text);
      return root.map((element) => Item.fromJson(element)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}