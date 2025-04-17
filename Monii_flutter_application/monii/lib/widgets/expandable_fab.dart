import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final double distance;
  final List<Widget> children;

  const ExpandableFab({
    Key? key,
    required this.distance,
    required this.children,
  }) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Tappable background when menu is open
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ..._buildExpandingActionButtons(),
        _buildTapToOpenFab(),
      ],
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 60.0;

    for (var i = 0; i < count; i++) {
      final angleInDegrees = 270.0 - (i * step);
      final angleInRadians = angleInDegrees * (3.1415926 / 180.0);
      final offset = Offset.fromDirection(angleInRadians, widget.distance);

      children.add(
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: 16 + offset.dy * _expandAnimation.value,
              right: 16 + offset.dx * _expandAnimation.value,
              child: Opacity(
                opacity: _expandAnimation.value,
                child: Transform.scale(
                  scale: _expandAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: widget.children[i],
        ),
      );
    }

    return children;
  }

  Widget _buildTapToOpenFab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: _toggle,
        backgroundColor: Colors.deepPurple,
        child: AnimatedRotation(
          turns: _isOpen ? 0.125 : 0,
          duration: const Duration(milliseconds: 250),
          child: Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}
