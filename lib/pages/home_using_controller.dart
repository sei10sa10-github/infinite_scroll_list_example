import 'package:flutter/material.dart';
import 'package:infinite_scroll_list_example/injections.dart';
import 'package:infinite_scroll_list_example/models/item.dart';
import 'package:infinite_scroll_list_example/state/home_data_holder.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController _controller;
  int _pageIndex = 1;
  double _lastBottomPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      double bottom = _controller.position.maxScrollExtent;
      double current = _controller.position.pixels;
      
      if (bottom - 20 <= current && _lastBottomPosition < bottom) {
        HomeDataHolder holder = getIt<HomeDataHolder>();
        if (holder.state != HomeState.loading) {
          _lastBottomPosition = bottom;
          holder.loadItems(++_pageIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Home is built');
    HomeDataHolder homeDataHolder = getIt<HomeDataHolder>();
    homeDataHolder.loadItems(1);
    
    return ChangeNotifierProvider(
      create: (_) => homeDataHolder,
      builder: (context, widget) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Infinite Scroll Test'),
          ),
          body: _getWidgetByState(context),
        );
      },
    );
  }

  Widget _getWidgetByState(BuildContext context) {
    final HomeDataHolder items = context.watch<HomeDataHolder>();
    final HomeState state = items.state;
    final List<Item> data = items.items;

    print('Builder is built with state update to $state');

    if (state == HomeState.loading) {
      if (data.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.separated(
          controller: _controller,
          itemBuilder: (context, index) {
            if (index < data.length) {
              return ListTile(
                title: Text(data[index].name),
                subtitle: Text(data[index].description),
              );
            } else {
              return Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
          },
          separatorBuilder: (_, __) => Divider(),
          itemCount: data.length,
        );
      }
    } else if (state == HomeState.finished) {
      return ListView.separated(
        controller: _controller,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index].name),
            subtitle: Text(data[index].description),
          );
        },
        separatorBuilder: (_, __) => Divider(),
        itemCount: data.length,
      );
    } else {
      if (data.isEmpty) {
        return Center(
          child: Text('Something wrong'),
        );
      } else {
        // ToDo: Show error message
        return ListView.separated(
          controller: _controller,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index].name),
              subtitle: Text(data[index].description),
            );
          },
          separatorBuilder: (_, __) => Divider(),
          itemCount: data.length,
        );
      }
    }
  }
}
