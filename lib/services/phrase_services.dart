import 'package:capstone2_project_management_app/models/phrase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          FirebaseDatabase.instance.ref().child('phrases').child(projectId);
      String? phraseId = phraseRef.push().key;
      await phraseRef.child(phraseId!).set({
        'phraseId': phraseId,
        'phraseName': phraseName,
        'listTasks': listTasks,
        'projectId': projectId,
      });
      Fluttertoast.showToast(msg: 'New phrase has been created successfully');
    }
  }

  Future<Map> getPhraseMap(String projectId) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phrases').child(projectId);
    DatabaseEvent databaseEvent = await phraseRef.once();
    Map<dynamic, dynamic> phraseMap = {};
    if (databaseEvent.snapshot.value != null) {
      phraseMap = Map.from(databaseEvent.snapshot.value as dynamic);
    }
//    _getProjectDetails();
    return phraseMap;
  }

  String getNameFromId(Map<String, dynamic> phraseMap, String id) {
    Map<String, String> mapName = {};
    for (var phrase in phraseMap.values) {
      PhraseModel phraseModel =
          PhraseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[phraseModel.prhaseId] = phraseModel.phraseName;
      if (phraseModel.prhaseId == id) {
        return mapName[phraseModel.prhaseId].toString();
      }
    }
    return "";
  }
}
