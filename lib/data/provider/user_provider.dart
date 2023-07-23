import 'package:filmapp/data/db/entity/app_user.dart';
import 'package:filmapp/data/db/entity/chat.dart';
import 'package:filmapp/data/db/entity/match.dart';
import 'package:filmapp/data/db/remote/firebase_auth_source.dart';
import 'package:filmapp/data/db/remote/firebase_database_source.dart';
import 'package:filmapp/data/db/remote/firebase_storage_source.dart';
import 'package:filmapp/data/db/remote/response.dart';
import 'package:filmapp/data/model/chat_with_user.dart';
import 'package:filmapp/data/model/user_registration.dart';
import 'package:filmapp/util/shared_preferences_utils.dart';
import 'package:filmapp/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuthSource _authSource = FirebaseAuthSource();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  late AppUser _user;

  Future<AppUser> get user => _getUser();

  Future<Response> loginUser(String email, String password,
      GlobalKey<ScaffoldMessengerState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signIn(email, password);
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      SharedPreferencesUtil.setUserId(id);
    }
    if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    return response;
  }

  Future<Response> registerUser(UserRegistration userRegistration,
      GlobalKey<ScaffoldMessengerState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.register(
        userRegistration.email, userRegistration.password);
    if (response is Success<UserCredential>) {
      String id = (response).value.user!.uid;
      response = await _storageSource.uploadUserProfilePhoto(
          userRegistration.localProfilePhotoPath, id);

      if (response is Success<String>) {
        String profilePhotoUrl = response.value;
        AppUser user = AppUser(
            id: id,
            name: userRegistration.name,
            profilePhotoPath: profilePhotoUrl);
        _databaseSource.addUser(user);
        SharedPreferencesUtil.setUserId(id);
        _user = user;
        return Response.success(user);
      }
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<AppUser> _getUser() async {
    String id = await SharedPreferencesUtil.getUserId();
    _user = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    return _user;
  }

  void updateUserProfilePhoto(String localFilePath,
      GlobalKey<ScaffoldMessengerState> errorScaffoldKey) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response =
        await _storageSource.uploadUserProfilePhoto(localFilePath, _user.id);
    isLoading = false;
    if (response is Success<String>) {
      _user.profilePhotoPath = response.value;
      _databaseSource.updateUser(_user);
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    notifyListeners();
  }

  void updateUserBio(String newBio) {
    _user.bio = newBio;
    _databaseSource.updateUser(_user);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await SharedPreferencesUtil.removeUserId();
  }

  Future<List<ChatWithUser>> getChatsWithUser(String userId) async {
    var matches = await _databaseSource.getMatches(userId);
    List<ChatWithUser> chatWithUserList = [];

    for (var i = 0; i < matches.size; i++) {
      Match match = Match.fromSnapshot(matches.docs[i]);
      AppUser matchedUser =
          AppUser.fromSnapshot(await _databaseSource.getUser(match.id));
      String chatId = compareCombineIds(match.id, userId);
      Chat chat = Chat.fromSnapshot(await _databaseSource.getChat(chatId));
      ChatWithUser chatWithUser = ChatWithUser(chat, matchedUser);
      chatWithUserList.add(chatWithUser);
    }
    return chatWithUserList;
  }
}
