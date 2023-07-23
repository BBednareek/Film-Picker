import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/ui/widgets/elevated_icon_button.dart';
import 'package:filmapp/util/constants.dart';
import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final AppUser person;
  const SwipeCard({super.key, required this.person});

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: height * .725,
          width: width * .85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              widget.person.profilePhotoPath,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: showInfo
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: getUserContent(context),
              ),
              showInfo ? getBottomInfo() : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget getUserContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: widget.person.name,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        RoundedIconButton(
          onPressed: () {
            showInfo = !showInfo;
          },
          iconData: showInfo ? Icons.arrow_downward : Icons.person,
          buttonColor: kColorPrimaryVariant,
          iconSize: 16,
        )
      ],
    );
  }

  Widget getBottomInfo() {
    return Column(
      children: [
        const Divider(
          color: kAccentColor,
          thickness: 1.5,
          height: 0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            color: Colors.black.withOpacity(.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                child: Opacity(
                  opacity: .8,
                  child: Text(
                    widget.person.bio.isNotEmpty
                        ? widget.person.bio
                        : "No bio :(",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
