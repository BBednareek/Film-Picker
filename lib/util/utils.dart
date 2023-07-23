import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(GlobalKey<ScaffoldMessengerState> globalKey, String message) {
  final snackBar = SnackBar(content: Text(message));
  globalKey.currentState?.hideCurrentSnackBar();
  globalKey.currentState?.showSnackBar(snackBar);
}

String compareCombineIds(String userID1, String userID2) {
  if (userID1.compareTo(userID2) < 0) {
    return userID2 + userID1;
  } else {
    return userID1 + userID2;
  }
}

String epochToDateTime(int epochMs) {
  int dayInMs = 86400000;
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  int currentTimeMs = DateTime.now().millisecondsSinceEpoch;
  if ((currentTimeMs - epochMs) >= dayInMs) {
    return '${DateFormat.yMd().format(date)} ${DateFormat.jm().format(date)}';
  } else {
    return DateFormat.jm().format(date);
  }
}
