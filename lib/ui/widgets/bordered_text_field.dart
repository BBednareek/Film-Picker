import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  // ignore: prefer_typing_uninitialized_variables
  final textController;

  const BorderedTextField(
      {super.key,
      required this.labelText,
      required this.onChanged,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.autoFocus = false,
      this.textCapitalization = TextCapitalization.none,
      this.textController});

  @override
  Widget build(BuildContext context) {
    Color color = kSecondayColor;
    return TextField(
      controller: textController,
      onChanged: onChanged,
      obscureText: obscureText,
      autofocus: autoFocus,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(color: color),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: kSecondayColor.withOpacity(.5)),
        border: const UnderlineInputBorder(),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }
}