import 'dart:io';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum ImageType { ASSET_IMAGE, FILE_IMAGE, NONE }

class ImagePortrait extends StatelessWidget {
  final double height;
  final String imagePath;
  final ImageType imageType;

  const ImagePortrait({
    super.key,
    required this.imagePath,
    required this.imageType,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height * .65,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kAccentColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: getImage(),
      ),
    );
  }

  Widget getImage() {
    if (imageType == ImageType.FILE_IMAGE) {
      return Image.file(File(imagePath), fit: BoxFit.fill);
    } else if (imageType == ImageType.ASSET_IMAGE) {
      return Image.asset(imagePath, fit: BoxFit.fitHeight);
    } else {
      return Container();
    }
  }
}
