import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      disabledForegroundColor: kAccentColor.withOpacity(.25),
      padding: const EdgeInsets.symmetric(vertical: 14),
      side: const BorderSide(color: kSecondayColor, width: 2),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: elevatedButtonStyle,
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
