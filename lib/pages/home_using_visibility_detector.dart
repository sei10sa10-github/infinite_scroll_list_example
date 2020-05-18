import 'package:flutter/material.dart';
import 'package:infinite_scroll_list_example/injections.dart';
import 'package:infinite_scroll_list_example/models/item.dart';
import 'package:infinite_scroll_list_example/state/home_data_holder.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int kLoadTrigger = 10;
  int _triggeredIndex = 0;
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    print('Home is built');
    HomeDataHolder homeDataHolder = getIt<HomeDataHolder>();
    homeDataHolder.loadItems(_pageIndex);

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
    final HomeDataHolder dataHolder = context.watch<HomeDataHolder>();
    final HomeState state = dataHolder.state;
    final List<Item> data = dataHolder.items;

    print('Builder is built with state update to $state');

    if (state == HomeState.loading) {
      if (data.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.separated(
          itemBuilder: (context, index) {
            if (index < data.length) {
              if (data.length - kLoadTrigger - 1 == index) {
                print('VisibilityDetector created');
                return VisibilityDetector(
                  key: Key('Item-$index'),
                  child: ListTile(
                    title: Text(data[index].name),
                    subtitle: Text(data[index].description),
                  ),
                  onVisibilityChanged: (info) {
                    print('VisibilityChnaged: ${info.visibleFraction}');
                    if (info.visibleFraction >= 0.1 && _triggeredIndex < index) {
                      dataHolder.loadItems(++_pageIndex);
                    }
                  },
                );
              }
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
      return _getListView(context, dataHolder);
    } else {
      if (data.isEmpty) {
        return Center(
          child: Text('Something wrong'),
        );
      } else {
        // ToDo: Show error message
        return ListView.separated(
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

  ListView _getListView(BuildContext context, HomeDataHolder dataHolder) {
    final data = dataHolder.items;
    return ListView.separated(
        itemBuilder: (context, index) {
          if (data.length - kLoadTrigger - 1 == index) {
            print('VisibilityDetector created');
            return VisibilityDetector(
              key: Key('Item-$index'),
              child: ListTile(
                title: Text(data[index].name),
                subtitle: Text(data[index].description),
              ),
              onVisibilityChanged: (info) {
                print('VisibilityChnaged: ${info.visibleFraction}');
                if (info.visibleFraction >= 0.1 && _triggeredIndex < index) {
                  dataHolder.loadItems(++_pageIndex);
                }
              },
            );
          }
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
