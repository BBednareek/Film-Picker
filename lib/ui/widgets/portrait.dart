import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class Portrait extends StatelessWidget {
  final String imageUrl;
  final double height;

  const Portrait({
    super.key,
    required this.imageUrl,
    this.height = 225,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height * .65,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: kAccentColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.fitHeight,
              )
            : null,
      ),
    );
  }
}
