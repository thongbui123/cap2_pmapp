import 'dart:async';

import 'package:capstone2_project_management_app/views/subs/project_create_step2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';

import '../../models/user_model.dart';

class projectCreateStep1 extends StatefulWidget {
  const projectCreateStep1({Key? key}) : super(key: key);

  @override
  State<projectCreateStep1> createState() => _projectCreateStep1State();
}

class _projectCreateStep1State extends State<projectCreateStep1> {
  User? user;
  UserModel? currentUserModel;
  DatabaseReference? userRef;
  DatabaseReference? usersRef;
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  List<String> currentList = [];
  Map<dynamic, dynamic> leaderMap = {};
  // Sample list of members
  List<String> allLeaders = [
    'User 1',
    'User 2',
    'User 3',
  ];

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
      usersRef?.onValue.listen((event) {
        setState(() {
          leaderMap = Map.from(event.snapshot.value as dynamic);
        });
      });
    }

    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontMed',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
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
                      child: const TextField(
                        maxLines: null,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontMed',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
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
                              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
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
                          _selectDate(startDateController);
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
                              borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
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
                          _selectDate(endDateController);
                        },
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _showMemberSelectionDialog,
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 10),
                          Text(
                            'Available Members',
                            style: TextStyle(fontFamily: 'MontMed'),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Column(
                  children: currentList.map((member) {
                    return ListTile(
                      leading: const CircleAvatar(
                          child: Text(
                        'A',
                        style: TextStyle(fontFamily: 'MontMed'),
                      )),
                      title: Text(member),
                      subtitle: const Text(
                        'Number of project',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      trailing: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.redAccent,
                          onPressed: () {
                            _removeMember(member);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const projectCreateStep2()),
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

  Future<void> _selectDate(TextEditingController textEditingController) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
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
            child: Column(
              children: allLeaders.map((user) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const CircleAvatar(
                          child: Text(
                        'A',
                        style: TextStyle(fontFamily: 'MontMed'),
                      )),
                      title: const Text('user'),
                      subtitle: const Text(
                        'Supporting text',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        _addMember(user);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    const Divider(height: 0),
                  ],
                );
              }).toList(),
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

  void _removeMember(String member) {
    setState(() {
      currentList.remove(member);
    });
  }

  void _addMember(String member) {
    setState(() {
      currentList.add(member);
    });
  }
}
