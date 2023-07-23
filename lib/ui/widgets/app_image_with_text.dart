import 'package:flutter/material.dart';

class AppIconTitle extends StatelessWidget {
  const AppIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Image.asset('images/tinder_icon.png'),
        ),
        const SizedBox(width: 5),
        Text(
          'Film Picker',
          style: Theme.of(context).textTheme.displayMedium,
        )
      ],
    );
  }
}
