// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectServices {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('projects');
  //late Map<dynamic, dynamic> projectMap;

  Future<Map> getProjectMap() async {
    DatabaseEvent databaseEvent = await reference.once();
    Map<dynamic, dynamic> projectMap = {};
    if (databaseEvent.snapshot.value != null) {
      projectMap = Map.from(databaseEvent.snapshot.value as dynamic);
    }
//    _getProjectDetails();
    return projectMap;
  }

  Future<List<ProjectModel>> getJoinedProjectList(
      Map<dynamic, dynamic> projectMap, UserModel? currentUserModel) async {
    List<ProjectModel> joinedProjects = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.leaderId == currentUserModel?.userId) {
        joinedProjects.add(projectModel);
      }
    }
    return joinedProjects;
  }

  Future<void> addProject(
      String projectName,
      String projectDescription,
      String startDate,
      String endDate,
      String teamLeaderId,
      List<String> phrases,
      UserModel? currentUserModel) async {
    if (projectName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide project name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      List<String> members = [uid];
      int dt = DateTime.now().microsecondsSinceEpoch;
      DatabaseReference projectRef =
          FirebaseDatabase.instance.ref().child('projects');

      String? projectId = projectRef.push().key;
      DatabaseReference memberRef =
          FirebaseDatabase.instance.ref().child('projects').child(projectId!);
      await projectRef.child(projectId).set({
        'projectId': projectId,
        'projectName': projectName,
        'projecctDescription': projectDescription,
        'projectManager':
            "${currentUserModel!.userFirstName} ${currentUserModel.userLastName}",
        'managerId': currentUserModel.userId,
        'leaderId': teamLeaderId,
        'startDate': startDate,
        'endDate': endDate,
        'projectStatus': 'Requirement & Gathering',
        'projectMembers': members,
        'listOfPhrases': phrases,
      });
      Fluttertoast.showToast(msg: 'New project has been created successfully');
    }
  }
}
