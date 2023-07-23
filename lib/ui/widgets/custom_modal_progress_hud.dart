import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class CustomModalProgressHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset offset;
  final bool dismissible;
  final Widget child;

  const CustomModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = .3,
    this.color = Colors.transparent,
    this.progressIndicator = const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
    required this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      // ignore: unnecessary_null_comparison
      if (offset == null) {
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          left: offset.dx,
          top: offset.dy,
          child: progressIndicator,
        );
        final modal = [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(
              dismissible: dismissible,
              color: color,
            ),
          ),
          layOutProgressIndicator
        ];
        widgetList += modal;
      }
    }
    return Stack(children: widgetList);
  }
}
