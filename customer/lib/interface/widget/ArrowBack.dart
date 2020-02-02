import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrowBack extends StatefulWidget {
  final bool showArrowBack;
  final Function onArrowBackPressed;

  const ArrowBack({Key key, this.showArrowBack, this.onArrowBackPressed}) : super(key: key);

  @override
  _ArrowBackState createState() => _ArrowBackState();
}

class _ArrowBackState extends State<ArrowBack> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ArrowBack oldWidget) {
    if (oldWidget.showArrowBack && !widget.showArrowBack) {
      _controller.reverse();
    } else if (!oldWidget.showArrowBack && widget.showArrowBack) {
      _controller.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizeTransition(
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.showArrowBack) widget.onArrowBackPressed();
          },
        ),
        sizeFactor: CurvedAnimation(
          curve: Curves.fastOutSlowIn,
          parent: _controller,
        ),
        axisAlignment: -0.5,
        axis: Axis.horizontal,
      ),
    );
  }
}
