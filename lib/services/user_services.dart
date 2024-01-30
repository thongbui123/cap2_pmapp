import 'dart:io';

import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserServices {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  bool showLocalFile = false;
  File? imageFile;
  String defaultAvatar =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU';

  Future<Map<String, dynamic>> getUserDataMap() async {
    DatabaseEvent databaseEvent = await databaseReference.once();
    if (databaseEvent.snapshot.value != null) {
      return Map.from(databaseEvent.snapshot.value as dynamic);
    }
    return {};
  }

  List<UserModel> getUserDataList(Map<String, dynamic> userMap) {
    List<UserModel> userList = [];
    for (var user in userMap.values) {
      UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(user));
      userList.add(userModel);
    }
    return userList;
  }

  String getNameFromId(Map<String, dynamic> userMap, String id) {
    Map<String, String> mapName = {};
    for (var user in userMap.values) {
      UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(user));
      mapName[userModel.userId] =
          '${userModel.userFirstName} ${userModel.userLastName}';
      if (userModel.userId == id) {
        return mapName[userModel.userId].toString();
      }
    }
    return "";
  }

  String getAvatarFromId(Map<String, dynamic> userMap, String id) {
    Map<String, String> mapAvatar = {};
    for (var user in userMap.values) {
      UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(user));
      mapAvatar[userModel.userId] = userModel.profileImage;
      if (userModel.userId == id) {
        return mapAvatar[userModel.userId].toString();
      }
    }
    return "";
  }

  String getFirstLetter(String myString) => myString.substring(0, 1);
}
