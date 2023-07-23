import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final double iconSize;
  // ignore: prefer_typing_uninitialized_variables
  final paddingReduce;
  final Color buttonColor;

  const RoundedIconButton(
      {super.key,
      required this.onPressed,
      required this.iconData,
      this.iconSize = 30,
      required this.buttonColor,
      this.paddingReduce = 0});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      elevation: 5,
      onPressed: onPressed,
      padding: EdgeInsets.all((iconSize / 2) - paddingReduce),
      shape: const CircleBorder(),
      child: Icon(iconData, size: iconSize),
    );
  }
}
