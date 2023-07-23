import 'package:filmapp/util/constants.dart';
import 'package:filmapp/util/utils.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final int epochTimeMs;
  final String text;
  final bool isSenderMyUser;
  final bool includeTime;

  const MessageBubble({
    super.key,
    required this.epochTimeMs,
    required this.text,
    required this.isSenderMyUser,
    required this.includeTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isSenderMyUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          includeTime
              ? Opacity(
                  opacity: .4,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      epochToDateTime(epochTimeMs),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 5,
              color: isSenderMyUser ? kAccentColor : kSecondaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSenderMyUser ? kSecondaryColor : Colors.black,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
