import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';

class PhraseServices {
  Future<void> addPhrase(
    String phraseName,
    String projectId,
    List<String> listTasks,
  ) async {
    if (phraseName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide phrase name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DatabaseReference phraseRef =
          FirebaseDatabase.instance.ref().child('phrases');
      String? phraseId = phraseRef.push().key;
      await phraseRef.child(phraseId!).set({
        'phraseId': phraseId,
        'phraseName': phraseName,
        'listTasks': listTasks,
        'projectId': projectId,
      });
      Fluttertoast.showToast(msg: 'New project has been created successfully');
    }
  }

  _add8Phrases() {}
}
