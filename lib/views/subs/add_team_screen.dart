import 'package:capstone2_project_management_app/models/member_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({super.key});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  DatabaseReference? usersRef;
  DatabaseReference? membersRef;
  List<String> memberList = [];
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
      membersRef = FirebaseDatabase.instance.ref().child('teams');
    }
    _getUserDetails();
    super.initState();
  }

  var teamNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(hintText: 'Team Name'),
            ),
            const SizedBox(
              height: 10,
            ),
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
                    var idList = <String>[];
                    for (var teamMap in map.values) {
                      UserModel userModel =
                          UserModel.fromMap(Map<String, dynamic>.from(teamMap));
                      users.add(userModel);
                      idList.add(
                          "${userModel.userFirstName} ${userModel.userLastName}");
                    }
                    userList = users;
                    String dropdownVal = idList.first;
                    return DropdownButtonFormField<String>(
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      items: idList
                          .map<DropdownMenuItem<String>>((String value) =>
                              DropdownMenuItem(
                                  value: value, child: Text(value)))
                          .toList(),
                      value: dropdownVal,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownVal = newValue ?? dropdownVal;
                          if (memberList.contains(dropdownVal)) {
                            memberList.remove(dropdownVal);
                          } else {
                            memberList.add(dropdownVal);
                          }
                          if (memberList.length > 3) {
                            memberList.remove(memberList.first);
                          }
                          if (dropdownVal ==
                              "${currentUserModel?.userFirstName} ${currentUserModel?.userLastName}") {
                            memberList.remove(dropdownVal);
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
                  String teamName = teamNameController.text.trim();
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
                    DatabaseReference memberRef = FirebaseDatabase.instance
                        .ref()
                        .child('teams')
                        .child(teamId!);
                    await teamRef.child(teamId!).set({
                      'teamName': teamName,
                      'teamLeader':
                          "${currentUserModel!.userFirstName} ${currentUserModel!.userLastName}",
                      'teamId': teamId,
                      'teamMembers': members
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
