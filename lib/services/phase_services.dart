import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhaseServices {
  Future<void> addPhrase(
    String phraseName,
    String projectId,
    List<String> listTasks,
    String phraseDescription,
  ) async {
    if (phraseName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide phrase name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference phraseRef =
          FirebaseDatabase.instance.ref().child('phrases').child(projectId);
      String? phraseId = phraseRef.push().key;
      await phraseRef.child(phraseId!).set({
        'phraseId': phraseId,
        'phraseName': phraseName,
        'listTasks': listTasks,
        'projectId': projectId,
        'phraseDescription': phraseDescription,
        'timestamp': ServerValue.timestamp
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

  Future<void> updatePhraseTaskList(
      String projectId, String phraseId, List<String> listTasks) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phrases');
    phraseRef.child(projectId).child(phraseId).update({
      'listTasks': listTasks,
    });
    Fluttertoast.showToast(
        msg: 'Phrase task list has been updated successfully');
  }

  Future<Map> getPhraseMap(String projectId) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phrases').child(projectId);
    DatabaseEvent databaseEvent =
        await phraseRef.orderByChild('timestamp').once();
    Map<dynamic, dynamic> phraseMap = {};
    if (databaseEvent.snapshot.value != null) {
      phraseMap = Map.from(databaseEvent.snapshot.value as dynamic);
      List<MapEntry<dynamic, dynamic>> sortedEntries =
          phraseMap.entries.toList();
      sortedEntries.sort((a, b) {
        return (a.value['timestamp'] as int).compareTo(b.value['timestamp']);
      });
      phraseMap = Map.fromEntries(sortedEntries.map((entry) {
        return MapEntry(
          entry.key,
          {
            'timestamp': entry.value['timestamp'],
            'phraseId': entry.value['phraseId'],
            'phraseName': entry.value['phraseName'],
            'listTasks': entry.value['listTasks'],
            'phraseDescription': entry.value['phraseDescription'],
            'projectId': entry.value['projectId'],
          },
        );
      }));
    }
//    _getProjectDetails();
    return phraseMap;
  }

  String getNameFromId(Map<String, dynamic> phraseMap, String id) {
    Map<String, String> mapName = {};
    for (var phrase in phraseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
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
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[phraseModel.phraseName] = num;
      if (phraseModel.phraseName == phraseName) {
        return num;
      }
      num++;
    }
    return 0;
  }

  PhaseModel? getPhraseModelFromName(
      Map<dynamic, dynamic> phraseMap, String phraseName) {
    PhaseModel? result;
    for (var phrase in phraseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      if (phraseModel.phraseName == phraseName) {
        result = phraseModel;
      }
    }
    return result;
  }

  PhaseModel? getCurrentPhraseModelFromProject(
      Map<dynamic, dynamic> phraseMap, String projectId) {
    PhaseModel? result;
    for (var phrase in phraseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      if (phraseModel.projectId == projectId) {
        result = phraseModel;
      }
    }
    return result;
  }

  Map<int, String> getMapPhraseIndex(Map<dynamic, dynamic> phraseMap) {
    Map<int, String> mapName = {};
    int num = 0;
    for (var phrase in phraseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[num] = phraseModel.phraseName;
      num++;
    }
    print(mapName);
    return mapName;
  }

  // Map<int, String> getMapPhraseIndex(Map<dynamic, dynamic> phraseMap) {
  //   List<MapEntry<int, String>> sortedEntries = [];
  //   int num = 0;

  //   for (var phrase in phraseMap.values) {
  //     PhraseModel phraseModel =
  //         PhraseModel.fromMap(Map<String, dynamic>.from(phrase));
  //     sortedEntries.add(MapEntry(num, phraseModel.phraseName));
  //     num++;
  //   }

  //   sortedEntries.sort((a, b) => b.value.compareTo(a.value));

  //   Map<int, String> sortedMap = LinkedHashMap.fromEntries(sortedEntries);
  //   return sortedMap;
  // }
}
