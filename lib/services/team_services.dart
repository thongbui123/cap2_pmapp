import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeamServices {
  Future<void> addTeam(String teamName, List<String> memberList,
      UserModel? currentUserModel) async {
    List<String> teamMembers = [];
    if (teamName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide team name');
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      List<String> members = memberList;
      int dt = DateTime.now().microsecondsSinceEpoch;
      DatabaseReference teamRef =
          FirebaseDatabase.instance.ref().child('teams');

      String? teamId = teamRef.push().key;
      DatabaseReference memberRef =
          FirebaseDatabase.instance.ref().child('teams').child(teamId!);
      await teamRef.child(teamId!).set({
        'teamName': teamName,
        'teamLeader':
            "${currentUserModel!.userFirstName} ${currentUserModel!.userLastName}",
        'teamId': teamId,
        'teamMembers': members
      });
    }
  }
}
