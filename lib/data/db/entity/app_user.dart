import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  late String id;
  late String name;
  late String profilePhotoPath;
  String bio = '';

  AppUser({required this.id, required this.name, profilePhotoPath, bio});

  AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot['id'];
    name = snapshot['name'];
    profilePhotoPath = snapshot['profile_photo_path'];
    bio = snapshot.get('bio') ?? '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profile_photo_path': profilePhotoPath,
      'bio': bio
    };
  }
}
