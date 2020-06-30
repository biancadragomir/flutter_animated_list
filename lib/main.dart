import 'package:flutter/material.dart';

import 'anchored_overlay.dart';
import 'fab_with_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<int> _list = [];
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedList(
          key: _listKey,
          initialItemCount: _list.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return slidingListItem(context, index, animation);
          },
        ),
        floatingActionButton: _buildFab(context));
  }

  Widget slidingListItem(BuildContext context, int index, animation) {
    int item = _list[index];
    TextStyle textStyle = Theme.of(context).textTheme.headline4;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset(0, 0))
          .animate(animation),
      child: SizedBox(
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Text(
            "Item $item",
            style: textStyle,
          ),
        ),
      ),
    );
  }

  void addItem() {
    _listKey.currentState
        .insertItem(0, duration: const Duration(milliseconds: 500));
    _list = []
      ..add(counter++)
      ..addAll(_list);
  }

  void removeItem() {
    if (_list.isNotEmpty) {
      _listKey.currentState.removeItem(
          0, (context, animation) => slidingListItem(context, 0, animation),
          duration: const Duration(milliseconds: 500));
      // TODO also remove the item from the list itself
    }
  }

  void _selectedFab(int index) {
    if (index == 0) {
      addItem();
    } else {
      removeItem();
    }
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.add, Icons.remove];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(iconsList: icons, onIconTapped: _selectedFab),
        );
      },
      child: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.menu),
      ),
    );
  }
}
