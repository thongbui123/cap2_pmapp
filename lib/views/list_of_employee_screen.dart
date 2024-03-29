import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  final UserModel userModel;
  const EmployeeScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

List<String> allMember = [
  'Member A',
  'Member B',
  'Member C',
];

List<String> allLeader = [
  'Leader A',
  'Leader B',
];

List<String> allManager = [
  'Manager A',
  'Manager B',
];

bool _customTileExpanded0 = true;
bool _customTileExpanded1 = true;
bool _customTileExpanded2 = true;

class _EmployeeScreenState extends State<EmployeeScreen> {
  late UserModel userModel;
  DatabaseReference? usersRef;
  Map<String, dynamic> userMap = {};
  late List<UserModel> listMembers;
  late List<UserModel> listLeaders;
  late List<UserModel> listManagers;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    if (FirebaseAuth.instance.currentUser != null) {
      usersRef = FirebaseDatabase.instance.ref().child('users');
    }
    _getUserDetails();
  }

  _getUserDetails() async {
    //DatabaseEvent snapshot = await usersRef!.once();
    usersRef?.onValue.listen((event) {
      setState(() {
        userMap = Map.from(event.snapshot.value as dynamic);
        for (var user in userMap.values) {
          UserModel userModel =
              UserModel.fromMap(Map<String, dynamic>.from(user));
          if (userModel.userRole == 'User') {
            listMembers.add(userModel);
          } else {
            if (userModel.userRole == 'Team Leader') {
              listLeaders.add(userModel);
            } else {
              listManagers.add(userModel);
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DbSideMenu(
              userModel: userModel,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LIST OF USERS',
                          style: const TextStyle(
                            fontFamily: 'MontMed',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius:
                            BorderRadius.circular(5.0), // Set the border radius
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            Icon(Icons.people, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text('Member(s)',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 13)),
                          ],
                        ),
                        trailing: Icon(
                          _customTileExpanded0
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down,
                        ),
                        children: [
                          Divider(),
                          Container(
                            child: Column(
                              children: listMembers.map((member) {
                                return ListTile(
                                  leading: avatar(userMap, member.userId),
                                  title: Text('${member.userFirstName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people,
                                            size: 13,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Projects Joined: 3',
                                              style: TextStyle(
                                                  fontFamily: 'MontMed',
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.border_color,
                                        size: 14,
                                      ),
                                      onPressed: () {
                                        _showStateDrawer(context);
                                      }),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _customTileExpanded0 = expanded;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius:
                            BorderRadius.circular(5.0), // Set the border radius
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            Icon(Icons.person, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text('Leader(s)',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 13)),
                          ],
                        ),
                        trailing: Icon(
                          _customTileExpanded1
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down,
                        ),
                        children: [
                          Divider(),
                          Container(
                            child: Column(
                              children: allLeader.map((task) {
                                return ListTile(
                                  leading: const CircleAvatar(child: Text('T')),
                                  title: Text(task,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.folder_open_sharp,
                                            size: 13,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Project Joined: 3',
                                              style: TextStyle(
                                                  fontFamily: 'MontMed',
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.border_color,
                                        size: 14,
                                      ),
                                      onPressed: () {
                                        _showStateDrawer(context);
                                      }),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _customTileExpanded1 = expanded;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius:
                            BorderRadius.circular(5.0), // Set the border radius
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            Icon(Icons.person, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text('Manager(s)',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 13)),
                          ],
                        ),
                        trailing: Icon(
                          _customTileExpanded2
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down,
                        ),
                        children: [
                          Divider(),
                          Container(
                            child: Column(
                              children: allManager.map((project) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Text('H'),
                                  ),
                                  title: Text(project,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.folder_open_sharp,
                                            size: 13,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Project Created: 3',
                                              style: TextStyle(
                                                  fontFamily: 'MontMed',
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.border_color,
                                        size: 14,
                                      ),
                                      onPressed: () {
                                        _showStateDrawer(context);
                                      }),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _customTileExpanded2 = expanded;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  bool member = true;
  bool leader = false;
  bool manager = false;
  void _showStateDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Your bottom drawer content goes here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('Change Role:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Member',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = true;
                    leader = false;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: member,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Incompleted',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = true;
                    manager = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: leader,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Manager',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = false;
                    manager = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: manager,
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }
}
