// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:capstone2_project_management_app/models/team_model.dart';

class UpdateTeamScreen extends StatefulWidget {
  final TeamModel teamModel;

  const UpdateTeamScreen({
    Key? key,
    required this.teamModel,
  }) : super(key: key);

  @override
  State<UpdateTeamScreen> createState() => _UpdateTeamScreenState();
}

class _UpdateTeamScreenState extends State<UpdateTeamScreen> {
  User? user;
  DatabaseReference? userRef;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('userId');
    }
    super.initState();
    teamController.text = widget.teamModel.teamName;
  }

  var teamController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: teamController,
              decoration: const InputDecoration(hintText: 'Task Name'),
            ),
            widget.teamModel.teamMembers.length < 3 ? Container() : Container(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  String teamName = teamController.text.trim();
                  if (teamName.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please provide team name');
                  }
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String uid = user.uid;
                    int dt = DateTime.now().microsecondsSinceEpoch;
                    DatabaseReference teamRef = FirebaseDatabase.instance
                        .ref()
                        .child('teams')
                        .child(widget.teamModel.teamId);
                    //String? teamId = teamRef.push().key;
                    await teamRef.update({
                      'teamName': teamName,
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save')),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
