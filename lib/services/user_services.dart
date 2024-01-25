import 'package:firebase_database/firebase_database.dart';

class UserServices {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  Future<Map<String, dynamic>> getAllUsers(
      Map<String, dynamic> usersMap) async {
    DatabaseEvent databaseEvent =
        await databaseReference.child('projects').once();
    if (databaseEvent.snapshot.value != null) {
      return usersMap = Map.from(databaseEvent.snapshot.value as dynamic);
    }
    return {};
  }
}
