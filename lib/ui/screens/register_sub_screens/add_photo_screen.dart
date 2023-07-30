// ignore_for_file: unnecessary_null_comparison

import 'package:filmapp/ui/widgets/elevated_icon_button.dart';
import 'package:filmapp/ui/widgets/image_portait.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoScreen extends StatefulWidget {
  final Function(String) onPhotoChanged;
  const AddPhotoScreen({super.key, required this.onPhotoChanged});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final picker = ImagePicker();
  late String _imagePath;

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.onPhotoChanged(pickedFile.path);
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Add photo', style: Theme.of(context).textTheme.displaySmall),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Container(
                    child: _imagePath == null
                        ? ImagePortrait(
                            imagePath: _imagePath, imageType: ImageType.NONE)
                        : ImagePortrait(
                            imagePath: _imagePath,
                            imageType: ImageType.FILE_IMAGE),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: _imagePath == null
                          ? RoundedIconButton(
                              onPressed: pickImageFromGallery,
                              iconData: Icons.add,
                              buttonColor: kAccentColor,
                              iconSize: 20)
                          : null,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
