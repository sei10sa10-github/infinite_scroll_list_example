import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_list_example/models/item.dart';
import 'package:infinite_scroll_list_example/services/item_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class HomeDataHolder with ChangeNotifier {

  HomeState _state = HomeState.finished;
  HomeState get state => _state;

  List<Item> _items = [];
  List<Item> get items => []..addAll(_items);

  int _loadedPageIndex = 0;
  int get loadedPageIndex => _loadedPageIndex;

  ItemService _service;

  HomeDataHolder(ItemService service) : _service = service;

  void loadItems(int pageIndex) async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      final items = await _service.getItems(pageIndex);
      _items.addAll(items);
      _state = HomeState.finished;
      _loadedPageIndex = pageIndex;
      notifyListeners();
    } catch (e) {
      _state = HomeState.error;
      notifyListeners();
    }
  }

}

enum HomeState {
  loading, finished, error
}