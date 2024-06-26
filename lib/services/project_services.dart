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
  late String realProjectID;
  Future<Map> getProjectMap() async {
    DatabaseEvent databaseEvent = await reference.once();
    Map<dynamic, dynamic> projectMap = {};
    if (databaseEvent.snapshot.value != null) {
      projectMap = Map.from(databaseEvent.snapshot.value as dynamic);
    }
//    _getProjectDetails();
    return projectMap;
  }

  List<ProjectModel> getJoinedProjectList(
      Map<dynamic, dynamic> projectMap, UserModel currentUserModel) {
    List<ProjectModel> joinedProjects = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (getRelateToProjectCondition(projectModel, currentUserModel)) {
        joinedProjects.add(projectModel);
      }
    }
    return joinedProjects;
  }

  bool getRelateToProjectCondition(
      ProjectModel projectModel, UserModel currentUserModel) {
    return (projectModel.projectMembers.contains(currentUserModel.userId) ||
        projectModel.managerId == currentUserModel.userId ||
        projectModel.leaderId == currentUserModel.userId);
  }

  List<ProjectModel> getJoinedOnGoingProjectList(
      Map<dynamic, dynamic> projectMap, UserModel currentUserModel) {
    List<ProjectModel> joinedProjects = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (getRelateToProjectCondition(projectModel, currentUserModel) &&
          projectModel.projectStatus == 'In progress') {
        joinedProjects.add(projectModel);
      }
    }
    return joinedProjects;
  }

  List<ProjectModel> getAllProjectList(Map<dynamic, dynamic> projectMap) {
    List<ProjectModel> list = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      list.add(projectModel);
    }
    return list;
  }

  int getAllProjectInYear(Map<dynamic, dynamic> projectMap, int currentYear) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime dateTime = DateTime.parse(projectModel.endDate);
      int projectYear = dateTime.year;
      if (projectYear == currentYear) {
        count++;
      }
    }
    return count;
  }

  int getAllOverdueTaskInYear(
      Map<dynamic, dynamic> projectMap, int currentYear) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime dateTime = DateTime.parse(projectModel.endDate);
      int projectYear = dateTime.year;
      if (projectYear == currentYear &&
          projectModel.projectStatus == 'Overdue') {
        count++;
      }
    }
    return count;
  }

  int getAllDoneProjectInYear(
      Map<dynamic, dynamic> projectMap, int currentYear) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime dateTime = DateTime.parse(projectModel.endDate);
      int projectYear = dateTime.year;
      if (projectYear == currentYear && projectModel.projectStatus == 'Done') {
        count++;
      }
    }
    return count;
  }

  int getAllOnGoingTaskInYear(
      Map<dynamic, dynamic> projectMap, int currentYear) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime dateTime = DateTime.parse(projectModel.endDate);
      int projectYear = dateTime.year;
      if (projectYear == currentYear &&
          projectModel.projectStatus == 'In progress') {
        count++;
      }
    }
    return count;
  }

  List<ProjectModel> getSearchedProjectList(
      Map<dynamic, dynamic> projectMap, String output) {
    List<ProjectModel> list = [];
    if (output != "") {
      for (var project in projectMap.values) {
        ProjectModel projectModel =
            ProjectModel.fromMap(Map<String, dynamic>.from(project));
        if (projectModel.projectName
                .toLowerCase()
                .contains(output.toLowerCase()) ||
            projectModel.projecctDescription
                .toLowerCase()
                .contains(output.toLowerCase())) {
          list.add(projectModel);
        }
      }
    }
    return list;
  }

  String getProjectNameFromId(Map<dynamic, dynamic> projectMap, String id) {
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.projectId == id) {
        return projectModel.projectName;
      }
    }
    return "";
  }

  ProjectModel? getProjectModelFromId(
      Map<dynamic, dynamic> projectMap, String id) {
    ProjectModel? result;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.projectId == id) {
        result = projectModel;
      }
    }
    return result;
  }

  int getJoinedProjectNumber(Map<dynamic, dynamic> projectMap, String id) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if ((projectModel.projectMembers.contains(id) ||
          projectModel.managerId == id ||
          projectModel.leaderId == id)) {
        count++;
      }
    }
    return count;
  }

  int getCreateProjectNumber(Map<dynamic, dynamic> projectMap, String id) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.managerId == id) {
        count++;
      }
    }
    return count;
  }

  int getJoinedOverdueProjectNumber(
      Map<dynamic, dynamic> projectMap, String id) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(projectModel.endDate);
      if ((projectModel.projectMembers.contains(id) ||
                  projectModel.managerId == id ||
                  projectModel.leaderId == id) &&
              now.isAfter(endDate) ||
          projectModel.projectStatus == 'Overdue') {
        count++;
      }
    }
    return count;
  }

  int getAllOverdueProjectNumber(Map<dynamic, dynamic> projectMap) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(projectModel.endDate);
      if (now.isAfter(endDate)) {
        count++;
      }
    }
    return count;
  }

  int getJoinedCompleteProjectNumber(
      Map<dynamic, dynamic> projectMap, String id) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if ((projectModel.projectMembers.contains(id) ||
              projectModel.managerId == id ||
              projectModel.leaderId == id) &&
          projectModel.projectStatus == 'Done') {
        count++;
      }
    }
    return count;
  }

  int getAllCompleteProjectNumber(Map<dynamic, dynamic> projectMap) {
    int count = 0;
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.projectStatus == 'Done') {
        count++;
      }
    }
    return count;
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
      realProjectID = projectId!;
      await projectRef.child(projectId).set({
        'projectId': projectId,
        'projectName': projectName,
        'projecctDescription': projectDescription,
        'projectManager':
            "${currentUserModel!.userFirstName} ${currentUserModel.userLastName}",
        'managerId': currentUserModel.userId,
        'leaderId': teamLeaderId,
        'currentPhaseId': "",
        'startDate': startDate,
        'endDate': endDate,
        'projectStatus': 'In progress',
        'projectMembers': members,
        'projectPhrases': phrases,
        'timestamp': ServerValue.timestamp
      });
      Fluttertoast.showToast(msg: 'New project has been created successfully');
    }
  }

  Future<void> updateProjectStatus(
      String projectId, String currentPhraseName) async {
    DatabaseReference phraseRef =
        FirebaseDatabase.instance.ref().child('projects');
    phraseRef.child(projectId).update({
      'projectStatus': currentPhraseName,
    });
    Fluttertoast.showToast(msg: 'Current Phrase has been changed successfully');
  }
}
