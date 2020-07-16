library awesome_speed_dial;

import 'package:flutter/material.dart';

class AwesomeSpeedDial extends StatefulWidget {
  const AwesomeSpeedDial(
      {Key key,
      this.fabButtons,
      this.colorStartAnimation,
      this.colorEndAnimation,
      this.animatedIconData})
      : assert(fabButtons.length == 3),
        super(key: key);
  final List<Widget> fabButtons;
  final Color colorStartAnimation;
  final Color colorEndAnimation;
  final AnimatedIconData animatedIconData;

  @override
  _AwesomeSpeedDialState createState() => _AwesomeSpeedDialState();
}

class _AwesomeSpeedDialState extends State<AwesomeSpeedDial>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.colorStartAnimation,
      end: widget.colorEndAnimation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
      ),
    ));
    _translateButton = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _curve,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: widget.animatedIconData,
        progress: _animateIcon,
      ),
    );
  }

  List<Widget> _setFabButtons() {
    final List<Widget> processButtons = <Widget>[];
    for (int i = 0; i < widget.fabButtons.length; i++) {
      processButtons.add(TransformFloatButton(
        fabHeight: _fabHeight,
        index: i,
        floatButton: widget.fabButtons[i],
        translateValue: _translateButton.value,
      ));
    }
    processButtons.add(toggle());
    return processButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _setFabButtons(),
    );
  }
}

class TransformFloatButton extends StatelessWidget {
  TransformFloatButton({
    @required this.floatButton,
    @required this.translateValue,
    @required this.index,
    @required this.fabHeight,
  }) : super(key: ObjectKey(floatButton));
  final Widget floatButton;
  final double translateValue;
  final int index;
  final double fabHeight;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Transform.translate(
          offset: Offset(
            translateValue * -1 * fabHeight,
            translateValue * -1 * fabHeight * 0.6,
          ),
          child: floatButton,
        );

      case 1:
        return Transform.translate(
          offset: Offset(0, -1 * fabHeight * 1.25 * translateValue),
          child: floatButton,
        );

      case 2:
        return Transform.translate(
          offset: Offset(
            translateValue * fabHeight,
            translateValue * -1 * fabHeight * 0.6,
          ),
          child: floatButton,
        );

      default:
        throw Exception(
            'this should never happen in AnimatedFloatingActionButton: index should be >= 2. index was $index');
    }
  }
}
