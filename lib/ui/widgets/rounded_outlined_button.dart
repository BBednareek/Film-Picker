import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  RoundedOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kAccentColor,
    side: const BorderSide(color: kSecondaryColor, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: outlinedButtonStyle,
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
