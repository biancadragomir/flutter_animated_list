import 'package:flutter/material.dart';

class FabWithIcons extends StatefulWidget {
  final List<IconData> iconsList;
  final ValueChanged<int> onIconTapped;

  FabWithIcons({this.iconsList, this.onIconTapped});

  @override
  _FabWithIconsState createState() => _FabWithIconsState();
}

class _FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.iconsList.length, (index) {
          return _buildFabSubItem(index);
        }).toList()
          ..add(_buildMainFab()));
  }

  Widget _buildMainFab() {
    return FloatingActionButton(
      child: Icon(Icons.menu),
      onPressed: () {
        if (_animationController.isDismissed) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
    );
  }

  Widget _buildFabSubItem(int index) {
    return Container(
        height: 70,
        width: 56,
        alignment: FractionalOffset.topCenter,
        child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    0.0, 1.0 - index / widget.iconsList.length / 2.0,
                    curve: Curves.easeOut)),
            child: FloatingActionButton(
              mini: true,
              onPressed: () => _onIconTapped(index),
              child: Icon(widget.iconsList[index]),
            )));
  }

  void _onIconTapped(int index) {
    _animationController.reverse();
    widget.onIconTapped(index);
  }
}
