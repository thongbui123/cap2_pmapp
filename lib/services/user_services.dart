import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserServices {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');

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
}
