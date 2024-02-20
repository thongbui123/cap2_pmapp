import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/project_create_step1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class projectCreateStep2 extends StatefulWidget {
  const projectCreateStep2({Key? key}) : super(key: key);

  @override
  State<projectCreateStep2> createState() => _projectCreateStep2State();
}

User? user;
UserModel? currentUserModel;
Map<dynamic, dynamic> projectMap = {};
DatabaseReference? userRef;
DatabaseReference? usersRef;
List<String> list = <String>['Member', 'Leader'];

class _projectCreateStep2State extends State<projectCreateStep2> {
  List<String> allLeaders = [
    "User 1",
    "User 2",
    "User 3",
    "User 4",
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
    }
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
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
                    Text(
                      'ROLES',
                      style: TextStyle(
                        fontFamily: 'Anurati',
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Column(
                  children: allLeaders.map((user) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                              child: Text(
                            'A',
                            style: TextStyle(fontFamily: 'MontMed'),
                          )),
                          title: Text(user),
                          subtitle: Text(
                            'Supporting text',
                            style: TextStyle(fontFamily: 'MontMed'),
                          ),
                          trailing: DropdownButtonExample(),
                        ),
                        Divider(height: 0),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectCreateStep1(
                                    currentUserModel: currentUserModel,
                                    projectMap: projectMap,
                                  )),
                        );
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Final Steps',
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
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontFamily: 'MontMed'),
          ),
        );
      }).toList(),
    );
  }
}
