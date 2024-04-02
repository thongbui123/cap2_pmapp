import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhaseServices {
  DatabaseReference phaseRef = FirebaseDatabase.instance.ref().child('phases');
  String realPhaseId = "";
  Future<void> addPhase(
    String phraseName,
    String projectId,
    List<String> listTasks,
    String phraseDescription,
  ) async {
    if (phraseName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide phase name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference phraseRef =
          FirebaseDatabase.instance.ref().child('phases');
      String? phraseId = phraseRef.push().key;
      await phraseRef.child(phraseId!).set({
        'phraseId': phraseId,
        'phraseName': phraseName,
        'listTasks': listTasks,
        'projectId': projectId,
        'phraseDescription': phraseDescription,
        'timestamp': ServerValue.timestamp
      });
      realPhaseId = phraseId;
      Fluttertoast.showToast(msg: 'New phrase has been created successfully');
    }
  }

  Future<void> updatePhraseName(
      String projectId, String phraseId, String currentPhrase) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phases');
    phraseRef.child(phraseId).update({
      'phraseName': currentPhrase,
    });
    Fluttertoast.showToast(msg: 'Phrase name has been changed successfully');
  }

  Future<void> updatePhraseTaskList(
      String projectId, String phraseId, List<String> listTasks) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phases');
    phraseRef.child(phraseId).update({
      'listTasks': listTasks,
    });
    Fluttertoast.showToast(
        msg: 'Phrase task list has been updated successfully');
  }

  String getPhaseNameFromId(Map phaseMap, String phraseId) {
    for (var phase in phaseMap.values) {
      PhaseModel phaseModel = PhaseModel.fromMap(Map.from(phase));
      if (phaseModel.phraseId == phraseId) {
        return phaseModel.phraseName;
      }
    }
    return '';
  }

  List<PhaseModel> getPhaseListByProject(Map phaseMap, String projectId) {
    List<PhaseModel> list = [];
    for (var phase in phaseMap.values) {
      PhaseModel phaseModel = PhaseModel.fromMap(Map.from(phase));
      if (phaseModel.projectId == projectId) {
        list.add(phaseModel);
      }
    }
    return list;
  }

  Future<Map<String, dynamic>> getPhraseMap() async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('phases');
    DatabaseEvent databaseEvent =
        await phraseRef.orderByChild('timestamp').once();
    Map<String, dynamic> phraseMap = {};
    if (databaseEvent.snapshot.value != null) {
      phraseMap = Map.from(databaseEvent.snapshot.value as dynamic);
      phraseMap = sortedPhaseMap(phraseMap).cast();
    }
//    _getProjectDetails();
    return phraseMap;
  }

  Map<dynamic, dynamic> sortedPhaseMap(Map<dynamic, dynamic> phraseMap) {
    List<MapEntry<dynamic, dynamic>> sortedEntries = phraseMap.entries.toList();
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
    return phraseMap;
  }

  String getNameFromId(Map<String, dynamic> phaseMap, String id) {
    Map<String, String> mapName = {};
    for (var phrase in phaseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      mapName[phraseModel.phraseId] = phraseModel.phraseName;
      if (phraseModel.phraseId == id) {
        return mapName[phraseModel.phraseId].toString();
      }
    }
    return "";
  }

  int getPhraseIndex(List<PhaseModel> phaseList, String phaseName) {
    Map<String, int> mapName = {};
    int num = 0;
    for (var phrase in phaseList) {
      mapName[phrase.phraseName] = num;
      if (phrase.phraseName == phaseName) {
        return num;
      }
      num++;
    }
    return 0;
  }

  PhaseModel? getPhraseModelFromName(
      Map<dynamic, dynamic> phaseMap, String phaseName) {
    PhaseModel? result;
    for (var phrase in phaseMap.values) {
      PhaseModel phraseModel =
          PhaseModel.fromMap(Map<String, dynamic>.from(phrase));
      if (phraseModel.phraseName == phaseName) {
        result = phraseModel;
      }
    }
    return result;
  }

  Future<void> deleteTaskInPhase(PhaseModel phaseModel, String taskId) async {
    List<String> listTasks = phaseModel.listTasks;
    if (listTasks.contains(taskId)) {
      listTasks.remove(taskId);
    }
    await phaseRef.child(phaseModel.phraseId).update({
      'listTasks': listTasks,
    });
  }

  Map<int, String> getMapPhaseId(List<PhaseModel> phaseList) {
    Map<int, String> mapId = {};
    int num = 0;
    for (var phase in phaseList) {
      mapId[num] = phase.phraseId;
      num++;
    }
    print(mapId);
    return mapId;
  }

  Map<int, String> getMapPhaseIndex(List<PhaseModel> phaseList) {
    Map<int, String> mapName = {};
    int num = 0;
    for (var phase in phaseList) {
      mapName[num] = phase.phraseName;
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
