import 'package:filmapp/ui/widgets/bordered_text_field.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String labelText;
  final Function(String) onSavePressed;
  final String startInputText;

  @override
  State<InputDialog> createState() => _InputDialogState();
  const InputDialog({
    super.key,
    required this.labelText,
    required this.onSavePressed,
    this.startInputText = '',
  });
}

class _InputDialogState extends State<InputDialog> {
  String inputText = '';
  final textController = TextEditingController();
  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  void initState() {
    textController.text = widget.startInputText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBackgroundColor,
      contentPadding: const EdgeInsets.all(16),
      content: BorderedTextField(
        textCapitalization: TextCapitalization.sentences,
        labelText: widget.labelText,
        autoFocus: true,
        keyboardType: TextInputType.text,
        onChanged: (value) => {inputText = value},
        textController: textController,
      ),
      actions: <Widget>[
        TextButton(
          style: textButtonStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSavePressed(inputText);
            Navigator.pop(context);
          },
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ],
    );
  }
}
