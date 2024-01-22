import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectServices {
  getUserDetailFromProjects(
      DatabaseReference? usersRef,
      Map<dynamic, dynamic> userMap,
      Map<String, String> userAvatarMap,
      Map<String, int> countProjectMap,
      List<String> allLeaders,
      Map<String, String> leaderIdMap) {
    usersRef?.onValue.listen((event) {
      userMap = Map.from(event.snapshot.value as dynamic);
      for (var leader in userMap.values) {
        UserModel userModel =
            UserModel.fromMap(Map<String, dynamic>.from(leader));
        userAvatarMap[userModel.userId] = userModel.profileImage;
        countProjectMap[userModel.userId] = 0;
        if (userModel.userRole == 'Team Leader') {
          allLeaders.add(userModel.userId);
          leaderIdMap[userModel.userId] =
              "${userModel.userFirstName} ${userModel.userLastName}";
        }
      }
    });
  }

  Future<void> addProject(
      String projectName,
      String projectDescription,
      String startDate,
      String endDate,
      String teamLeaderId,
      List<String> memberList,
      List<String> phrases,
      UserModel? currentUserModel) async {
    if (projectName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide project name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      List<String> members = memberList;
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

  Future<ProjectModel?> fetchProjectModelFromFirebase(String projectId) async {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('projects')
        .child(projectId);

    DatabaseEvent snapshot = await reference.once();

    if (snapshot.snapshot.value != null) {
      return ProjectModel.fromMap(
          snapshot.snapshot.value as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
