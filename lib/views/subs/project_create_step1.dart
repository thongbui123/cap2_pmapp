import 'dart:async';
import 'dart:io';

import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/services/image_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/project_create_step3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/project_services.dart';

class projectCreateStep1 extends StatefulWidget {
  final UserModel? currentUserModel;

  const projectCreateStep1({Key? key, this.currentUserModel}) : super(key: key);

  @override
  State<projectCreateStep1> createState() => _projectCreateStep1State();
}

class _projectCreateStep1State extends State<projectCreateStep1> {
  ProjectServices projectServices = ProjectServices();
  //User? user;
  UserModel? currentUserModel;
  ProjectModel? projectModelTest;
  //DatabaseReference? userRef;
  DatabaseReference? usersRef;
  DatabaseReference? projectsRef;
  DatabaseReference? listProjectsRef;
  var projectNameController = TextEditingController();
  var projectDescriptionController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var teamLeaderIdController = TextEditingController();
  List<String> currentList = [];
  Map<dynamic, dynamic> userMap = {};
  List<String> allLeaders = [];
  Map<String, String> userAvatarMap = {};
  Map<String, String> leaderIdMap = {};
  Map<dynamic, dynamic> projectMap = {};
  Map<String, int> countProjectMap = {};
  bool showLocalFile = false;
  ImageServices? imageServices;
  File? imageFile;
  String defaultAvatar =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU';
  // Sample list of members
  String selectedMember = "";
  _getUserDetails() async {
    usersRef?.onValue.listen((event) {
      setState(() {
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
      //_getProjectDetail();
    });
  }

  _getProjectDetail() {
    projectsRef?.onValue.listen((event) {
      setState(() {
        projectMap = Map.from(event.snapshot.value as dynamic);
        for (var project in projectMap.values) {
          ProjectModel projectModel =
              ProjectModel.fromMap(Map<String, dynamic>.from(project));
          for (var leaderId in allLeaders) {
            if (projectModel.leaderId == leaderId) {
              countProjectMap[projectModel.leaderId] =
                  (countProjectMap[projectModel.leaderId]! + 1);
              print(countProjectMap[leaderId]);
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    currentUserModel = widget.currentUserModel;
    if (FirebaseAuth.instance.currentUser != null) {
      projectsRef = FirebaseDatabase.instance.ref().child('projects');
      usersRef = FirebaseDatabase.instance.ref().child('users');
    }
    _getUserDetails();
    // user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    //   usersRef = FirebaseDatabase.instance.ref().child('users');
    //   projectsRef = FirebaseDatabase.instance.ref().child('projects');
    //   _getUserDetails();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUserModel == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          const Text(
                            'NEW PROJECT',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: projectNameController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD9D9D9)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                  ),
                                  labelText: 'Name of Project',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFD9D9D9),
                                  prefixIcon: Icon(
                                    Icons.drive_folder_upload,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: TextField(
                              controller: projectDescriptionController,
                              maxLines: null,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD9D9D9)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                  ),
                                  labelText: 'Description of Project',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFD9D9D9),
                                  prefixIcon: Icon(
                                    Icons.bubble_chart,
                                  )),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: TextField(
                              controller: startDateController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD9D9D9)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                  ),
                                  labelText: 'Start Date',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFD9D9D9),
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                  )),
                              readOnly: true,
                              onTap: () {
                                _selectDate(
                                    startDateController,
                                    DateTime.now()
                                        .subtract(const Duration(days: 0)));
                              },
                            ),
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Container(
                            child: TextField(
                              controller: endDateController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD9D9D9)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                  ),
                                  labelText: 'End Date',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFD9D9D9),
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                  )),
                              readOnly: true,
                              onTap: () {
                                _selectDate(
                                    endDateController,
                                    DateTime.now()
                                        .subtract(const Duration(days: 60)));
                              },
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      selectedMember == ""
                          ? Container(
                              height: 50,
                              child: TextButton(
                                onPressed: _showMemberSelectionDialog,
                                child: const Row(
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 10),
                                    Text(
                                      'Available Team Leader(s)',
                                      style: TextStyle(fontFamily: 'MontMed'),
                                    ),
                                  ],
                                ),
                              ))
                          : const Text(
                              'TEAM LEADER',
                              style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 20,
                              ),
                            ),
                      const SizedBox(height: 10),
                      selectedMember == ""
                          ? Container()
                          : ListTile(
                              leading: CircleAvatar(
                                  child: userAvatarMap[selectedMember] == ''
                                      ? Text(
                                          getFirstLetter(
                                              leaderIdMap[selectedMember]
                                                  .toString()),
                                          style: const TextStyle(
                                              fontFamily: 'MontMed'),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: showLocalFile
                                              ? FileImage(imageFile!)
                                                  as ImageProvider
                                              : NetworkImage(userAvatarMap[
                                                  selectedMember]!))),
                              title: Text(leaderIdMap[selectedMember]!),
                              subtitle: Text(
                                "Handling: ${countProjectMap[selectedMember].toString()} project(s)",
                                style: const TextStyle(fontFamily: 'MontMed'),
                              ),
                              trailing: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.transparent,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                    icon: const Icon(Icons.change_circle),
                                    color: Colors.blueAccent,
                                    onPressed: _showMemberSelectionDialog),
                              ),
                            ),
                      const SizedBox(height: 5),
                      const Divider(),
                      // Column(
                      //   children: currentList.map((member) {
                      //     return ListTile(
                      //       leading: CircleAvatar(
                      //           child: userAvatarMap[member] == ''
                      //               ? Text(
                      //                   getFirstLetter(
                      //                       leaderIdMap[member].toString()),
                      //                   style: const TextStyle(
                      //                       fontFamily: 'MontMed'),
                      //                 )
                      //               : CircleAvatar(
                      //                   backgroundColor: Colors.white,
                      //                   backgroundImage: showLocalFile
                      //                       ? FileImage(imageFile!)
                      //                           as ImageProvider
                      //                       : NetworkImage(
                      //                           userAvatarMap[member]!))),
                      //       title: Text(leaderIdMap[member]!),
                      //       subtitle: Text(
                      //         "Handling: ${countProjectMap[member].toString()} project(s)",
                      //         style: const TextStyle(fontFamily: 'MontMed'),
                      //       ),
                      //       trailing: Ink(
                      //         decoration: const ShapeDecoration(
                      //           color: Colors.transparent,
                      //           shape: CircleBorder(),
                      //         ),
                      //         child: IconButton(
                      //           icon: const Icon(Icons.remove_circle),
                      //           color: Colors.redAccent,
                      //           onPressed: () {
                      //             _removeMember(member);
                      //           },
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      //const SizedBox(height: 5),
                      //const Divider(),
                      const SizedBox(height: 5),
                      Container(
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => projectCreateStep3(
                                        projectNameController:
                                            projectNameController,
                                        projectDescriptionController:
                                            projectDescriptionController,
                                        startDateController:
                                            startDateController,
                                        endDateController: endDateController,
                                        teamLeaderId: selectedMember,
                                        currentUserModel: currentUserModel)),
                              );
                            },
                            child: Container(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Next Steps',
                                    style: TextStyle(fontFamily: 'MontMed'),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(
      TextEditingController textEditingController, DateTime dateTime) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: dateTime,
        lastDate: DateTime(2030));
    if (_picked != null) {
      textEditingController.text = _picked.toString().split(" ")[0];
    }
  }

  Future<void> _showMemberSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Members',
            style: TextStyle(fontFamily: 'MontMed'),
          ),
          content: SingleChildScrollView(
            child: allLeaders.isNotEmpty
                ? Column(
                    children: allLeaders.map((user) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                child: userAvatarMap[user] == ''
                                    ? Text(
                                        getFirstLetter(
                                            leaderIdMap[user].toString()),
                                        style: const TextStyle(
                                            fontFamily: 'MontMed'),
                                      )
                                    : CircleAvatar(
                                        radius: 66,
                                        backgroundColor: Colors.white,
                                        backgroundImage: showLocalFile
                                            ? FileImage(imageFile!)
                                                as ImageProvider
                                            : NetworkImage(
                                                userAvatarMap[user]!))),
                            title: Text(leaderIdMap[user]!),
                            subtitle: Text(
                              "Handling: ${countProjectMap[user].toString()} project(s)",
                              style: const TextStyle(fontFamily: 'MontMed'),
                            ),
                            onTap: () {
                              _changeTeamLeader(user);
                              Navigator.of(context).pop();
                              // Close the dialog
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }).toList(),
                  )
                : const Text(
                    'No Available Team Leader',
                    style: TextStyle(
                      fontFamily: 'MontMed',
                      color: Colors.redAccent,
                    ),
                  ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MontMed'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeTeamLeader(String member) {
    setState(() {
      selectedMember = member;
      teamLeaderIdController.text = selectedMember;
    });
  }

  void _removeMember(String member) {
    setState(() {
      //selectedMember = member;
      currentList.remove(member);
      allLeaders.add(member);
    });
  }

  void _addMember(String member) {
    setState(() {
      //selectedMember = member;
      currentList.add(member);
      allLeaders.remove(member);
    });
  }

  String getFirstLetter(String myString) => myString.substring(0, 1);
}
