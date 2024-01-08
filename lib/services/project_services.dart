import 'package:flutter/material.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectServices {
  Future<void> addProject(
      String projectName,
      String projecctDescription,
      String startDate,
      String endDate,
      List<String> memberList,
      UserModel? currentUserModel) async {
    List<String> teamMembers = [];
    if (projectName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide team name');
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
      await projectRef.child(projectId!).set({
        'projectName': projectName,
        'projecctDescription': projecctDescription,
        'projectLeader':
            "${currentUserModel!.userFirstName} ${currentUserModel!.userLastName}",
        'managerId': currentUserModel.userId,
        'startDate': startDate,
        'endDate': endDate,
        'projectStatus': 'Requirement & Gathering',
        'projectMembers': members,
      });
      Fluttertoast.showToast(msg: 'New project has been created successfully');
    }
  }
}
