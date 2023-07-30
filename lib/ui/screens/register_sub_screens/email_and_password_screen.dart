import 'package:filmapp/ui/widgets/bordered_text_field.dart';
import 'package:flutter/material.dart';

class EmailAndPasswordScreen extends StatelessWidget {
  final Function(String) emailOnChanged;
  final Function(String) passwordOnChanged;

  const EmailAndPasswordScreen({
    super.key,
    required this.emailOnChanged,
    required this.passwordOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My e-mail and',
            style: Theme.of(context).textTheme.headlineMedium),
        Text('Password is', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 25),
        BorderedTextField(
            labelText: 'Email',
            onChanged: emailOnChanged,
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 5),
        BorderedTextField(
            labelText: 'Password',
            onChanged: passwordOnChanged,
            obscureText: true)
      ],
    );
  }
}
