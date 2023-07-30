import 'package:filmapp/ui/widgets/bordered_text_field.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  final Function(String) onChanged;
  const NameScreen({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text('My first', style: Theme.of(context).textTheme.displaySmall),
            Text('name is', style: Theme.of(context).textTheme.displaySmall)
          ],
        ),
        const SizedBox(height: 25),
        Expanded(
          child: BorderedTextField(
              labelText: 'Name',
              onChanged: onChanged,
              textCapitalization: TextCapitalization.words),
        )
      ],
    );
  }
}
