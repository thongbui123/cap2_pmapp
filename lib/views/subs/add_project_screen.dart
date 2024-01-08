import 'dart:collection';

import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  DatabaseReference? usersRef;
  DatabaseReference? projectsRef;
  List<String> memberList = [];
  List<String> memberIdList = [];
  List<UserModel> userList = [];
  String? selectedItem;

  _getUserDetails() async {
    DatabaseEvent snapshot = await userRef!.once();

    currentUserModel = UserModel.fromMap(
        Map<String, dynamic>.from(snapshot.snapshot.value as dynamic));

    setState(() {});
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
      usersRef = FirebaseDatabase.instance.ref().child('users');
      projectsRef = FirebaseDatabase.instance.ref().child('projects');
    }
    _getUserDetails();
    super.initState();
  }

  var projectNameController = TextEditingController();
  var projectDescriptionController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        title: const Text(
          'ADDING PROJECT',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Bazer',
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: projectNameController,
              decoration: const InputDecoration(hintText: 'Project Name'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: TextField(
                controller: projectDescriptionController,
                decoration:
                    const InputDecoration(hintText: 'Project Description'),
              ),
            ),
            SizedBox(
              child: TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                    hintText: 'Starting Date',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
                readOnly: true,
                onTap: () {
                  _selectDate(startDateController,
                      DateTime.now().subtract(const Duration(days: 0)));
                },
              ),
            ),
            SizedBox(
              child: TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                    hintText: 'Ending Date',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
                readOnly: true,
                onTap: () {
                  _selectDate(endDateController,
                      DateTime.now().add(const Duration(days: 60)));
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text('Team Members'),
            Expanded(
              child: ListView.builder(
                itemCount: memberList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(memberList[index]),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Add Members'),
            StreamBuilder(
                stream: usersRef != null ? usersRef!.onValue : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var event = snapshot.data as DatabaseEvent;
                    var snapshot2 = event.snapshot.value as dynamic;
                    if (snapshot2 == null) {
                      return const Center(
                        child: Text('No Member Added Yet'),
                      );
                    }
                    Map<String, dynamic> map =
                        Map<String, dynamic>.from(snapshot2);
                    var users = <UserModel>[];
                    var namesList = <String>[];
                    var mapId = <String, String>{};
                    for (var teamMap in map.values) {
                      UserModel userModel =
                          UserModel.fromMap(Map<String, dynamic>.from(teamMap));
                      users.add(userModel);
                      namesList.add(
                          "${userModel.userFirstName} ${userModel.userLastName}");
                      mapId["${userModel.userFirstName} ${userModel.userLastName}"] =
                          userModel.userId;
                      //print(mapId);
                    }

                    userList = users;
                    String dropdownVal = namesList.first;
                    return DropdownButtonFormField<String>(
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      items: namesList
                          .map<DropdownMenuItem<String>>((String value) =>
                              DropdownMenuItem(
                                  value: value, child: Text(value)))
                          .toList(),
                      value: dropdownVal,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownVal = newValue ?? dropdownVal;
                          if (memberList.contains(dropdownVal) &&
                              memberIdList.contains(mapId[dropdownVal])) {
                            memberList.remove(dropdownVal);
                            memberIdList.remove(mapId[dropdownVal]);
                          } else {
                            memberList.add(dropdownVal);
                            String? drop = mapId[dropdownVal].toString();
                            memberIdList.add(drop);
                          }
                          if (memberList.length > 3) {
                            memberList.remove(memberList.first);
                            memberIdList.remove(memberIdList.first);
                          }
                          if (dropdownVal ==
                              "${currentUserModel?.userFirstName} ${currentUserModel?.userLastName}") {
                            memberList.remove(dropdownVal);
                            memberIdList.remove(mapId[dropdownVal]);
                            Fluttertoast.showToast(
                              msg: 'This member is already the team leader',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        });
                      },
                    );
                  }
                  return const Text('No Member Added Yet');
                }),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  ProjectServices().addProject(
                      projectNameController.text,
                      projectDescriptionController.text,
                      startDateController.text,
                      endDateController.text,
                      memberIdList,
                      currentUserModel);
                  Navigator.pop(context);
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
}
