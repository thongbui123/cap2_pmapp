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
        'phraseDescription': phraseName
      });
      Fluttertoast.showToast(msg: 'New phrase has been created successfully');
    }
  }

  Future<void> updatePhraseName(
      String projectId, String phraseId, String currentPhrase) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phrases');
    phraseRef.child(projectId).child(phraseId).update({
      'phraseName': currentPhrase,
    });
    Fluttertoast.showToast(msg: 'Phrase name has been changed successfully');
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
      mapName[phraseModel.phraseId] = phraseModel.phraseName;
      if (phraseModel.phraseId == id) {
        return mapName[phraseModel.phraseId].toString();
      }
    }
    return "";
  }

  int getPhraseIndex(Map<dynamic, dynamic> phraseMap, String phraseName) {
    Map<String, int> mapName = {};
    int num = 0;
    for (var phrase in phraseMap.values) {
      PhraseModel phraseModel =
          PhraseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[phraseModel.phraseName] = num;
      if (phraseModel.phraseName == phraseName) {
        return num;
      }
      num++;
    }
    return 0;
  }

  Map<int, String> getMapPhraseIndex(Map<dynamic, dynamic> phraseMap) {
    Map<int, String> mapName = {};
    int num = 0;
    for (var phrase in phraseMap.values) {
      PhraseModel phraseModel =
          PhraseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[num] = phraseModel.phraseName;
      num++;
    }
    return mapName;
  }
}
