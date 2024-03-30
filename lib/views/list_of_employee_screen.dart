import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmployeeScreen extends StatefulWidget {
  final UserModel userModel;
  final Map userMap;
  final Map projectMap;
  const EmployeeScreen(
      {Key? key,
      required this.userModel,
      required this.userMap,
      required this.projectMap})
      : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

bool _customTileExpanded0 = true;
bool _customTileExpanded1 = true;
bool _customTileExpanded2 = true;

class _EmployeeScreenState extends State<EmployeeScreen> {
  late UserModel currentUserModel;
  DatabaseReference? usersRef;
  Map<String, dynamic> userMap = {};
  Map projectMap = {};
  List<UserModel> listMembers = [];
  List<UserModel> listLeaders = [];
  List<UserModel> listManagers = [];
  List<UserModel> listAdmin = [];
  NotificationService notificationService = NotificationService();
  bool member = true;
  bool leader = false;
  bool manager = false;
  bool admin = false;

  String _getNotificationForm(String authId, String output) {
    String relatedName = UserServices().getNameFromId(userMap, authId);
    String form = 'You have been assigned as $output by $relatedName';
    return form;
  }

  _getUserCurrentRole(UserModel userModel) {
    if (userModel.userRole == 'User') {
      member = true;
      leader = false;
      manager = false;
      admin = false;
    } else {
      if (userModel.userRole == 'Team Leader') {
        member = false;
        leader = true;
        manager = false;
        admin = false;
      } else if (userModel.userRole == 'Manager') {
        member = false;
        leader = false;
        manager = true;
        admin = false;
      } else {
        member = false;
        leader = false;
        manager = false;
        admin = true;
      }
    }
  }

  _getUserDetails() {
    widget.userMap.forEach((key, value) {
      userMap[key.toString()] = value;
    });
    for (var user in userMap.values) {
      UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(user));
      if (userModel.userRole == 'User') {
        listMembers.add(userModel);
      } else {
        if (userModel.userRole == 'Team Leader') {
          listLeaders.add(userModel);
        } else if (userModel.userRole == 'Manager') {
          listManagers.add(userModel);
        } else {
          listAdmin.add(userModel);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentUserModel = widget.userModel;
    projectMap = widget.projectMap;
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DbSideMenu(
              userModel: currentUserModel,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'LIST OF USERS',
                          style: TextStyle(
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
                                  title: Text(
                                      '${member.userFirstName} ${member.userLastName}',
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
                                          Text(
                                              'Projects Joined: ${ProjectServices().getJoinedProjectNumber(projectMap, member.userId)}',
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
                                        _getUserCurrentRole(member);
                                        _showStateDrawer(context, member);
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
                              children: listLeaders.map((leader) {
                                return ListTile(
                                  leading: avatar(userMap, leader.userId),
                                  title: Text(
                                      '${leader.userFirstName} ${leader.userLastName}',
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
                                          Text(
                                              'Project Joined: ${ProjectServices().getJoinedProjectNumber(projectMap, leader.userId)}',
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
                                        _getUserCurrentRole(leader);
                                        _showStateDrawer(context, leader);
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
                              children: listManagers.map((manager) {
                                return ListTile(
                                  leading: avatar(userMap, manager.userId),
                                  title: Text(
                                      '${manager.userFirstName} ${manager.userLastName}',
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
                                          Text(
                                              'Project Created: ${ProjectServices().getCreateProjectNumber(projectMap, manager.userId)}',
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
                                        _getUserCurrentRole(manager);
                                        _showStateDrawer(context, manager);
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
                            Text('Admin(s)',
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
                              children: listAdmin.map((admin) {
                                return ListTile(
                                  leading: avatar(userMap, admin.userId),
                                  title: Text(
                                      '${admin.userFirstName} ${admin.userLastName}',
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
                                          Text(
                                              'Project Created: ${ProjectServices().getCreateProjectNumber(projectMap, admin.userId)}',
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
                                        _getUserCurrentRole(admin);
                                        _showStateDrawer(context, admin);
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

  void _showStateDrawer(BuildContext context, UserModel userModel) {
    UserServices userServices = UserServices();
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
                  leading: Icon(Icons.person),
                  title: Text('Member',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = true;
                    leader = false;
                    manager = false;
                    admin = false;
                    userServices.updateUserRole('User', userModel.userId);
                    setState(() {
                      if (!listMembers.contains(userModel)) {
                        listMembers.add(userModel);
                      }
                      if (listLeaders.contains(userModel)) {
                        listLeaders.remove(userModel);
                      }
                      if (listManagers.contains(userModel)) {
                        listManagers.remove(userModel);
                      }
                      if (listAdmin.contains(userModel)) {
                        listAdmin.remove(userModel);
                      }
                      userModel.userRole = 'User';
                      _getUserCurrentRole(userModel);
                      notificationService.addNotification(
                          _getNotificationForm(
                              currentUserModel.userId, 'Member'),
                          userModel.userId,
                          [userModel.userId],
                          'User');
                    });
                    Fluttertoast.showToast(
                        msg:
                            'You have been assigned ${userModel.userFirstName} ${userModel.userLastName} as Member role.',
                        timeInSecForIosWeb: 5);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: member,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Team Leader',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    member = false;
                    leader = true;
                    manager = false;
                    admin = false;
                    userServices.updateUserRole(
                        'Team Leader', userModel.userId);
                    setState(() {
                      if (!listLeaders.contains(userModel)) {
                        listLeaders.add(userModel);
                      }
                      if (listMembers.contains(userModel)) {
                        listMembers.remove(userModel);
                      }
                      if (listManagers.contains(userModel)) {
                        listManagers.remove(userModel);
                      }
                      if (listAdmin.contains(userModel)) {
                        listAdmin.remove(userModel);
                      }
                      userModel.userRole = 'Team Leader';
                      _getUserCurrentRole(userModel);
                      notificationService.addNotification(
                          _getNotificationForm(currentUserModel.userId,
                              userModel.userRole.toLowerCase()),
                          userModel.userId,
                          [userModel.userId],
                          'User');
                    });
                    Fluttertoast.showToast(
                        msg:
                            'You have been assigned ${userModel.userFirstName} ${userModel.userLastName} as ${userModel.userRole} role.',
                        timeInSecForIosWeb: 5);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: leader,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Manager',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  member = false;
                  leader = false;
                  manager = true;
                  admin = false;
                  userServices.updateUserRole('Manager', userModel.userId);
                  setState(() {
                    if (!listManagers.contains(userModel)) {
                      listManagers.add(userModel);
                    }
                    if (listMembers.contains(userModel)) {
                      listMembers.remove(userModel);
                    }
                    if (listLeaders.contains(userModel)) {
                      listLeaders.remove(userModel);
                    }
                    if (listAdmin.contains(userModel)) {
                      listAdmin.remove(userModel);
                    }
                    userModel.userRole = 'Manager';
                    _getUserCurrentRole(userModel);
                    notificationService.addNotification(
                        _getNotificationForm(
                            currentUserModel.userId, 'manager'),
                        userModel.userId,
                        [userModel.userId],
                        'User');
                  });
                  Fluttertoast.showToast(
                      msg:
                          'You have been assigned ${userModel.userFirstName} ${userModel.userLastName} as Project ${userModel.userRole} role.',
                      timeInSecForIosWeb: 5);
                  Navigator.pop(context);
                },
                trailing: Container(
                  child: Visibility(
                    visible: manager,
                    child: Icon(Icons.check),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  member = false;
                  leader = false;
                  manager = false;
                  admin = true;
                  userServices.updateUserRole('Admin', userModel.userId);
                  setState(() {
                    if (!listAdmin.contains(userModel)) {
                      listAdmin.add(userModel);
                    }
                    if (listManagers.contains(userModel)) {
                      listManagers.remove(userModel);
                    }
                    if (listMembers.contains(userModel)) {
                      listMembers.remove(userModel);
                    }
                    if (listLeaders.contains(userModel)) {
                      listLeaders.remove(userModel);
                    }
                    userModel.userRole = 'Admin';
                    _getUserCurrentRole(userModel);
                    notificationService.addNotification(
                        _getNotificationForm(currentUserModel.userId, 'admin'),
                        userModel.userId,
                        [userModel.userId],
                        'User');
                  });
                  Fluttertoast.showToast(
                      msg:
                          'You have been assigned ${userModel.userFirstName} ${userModel.userLastName} as ${userModel.userRole} role.',
                      timeInSecForIosWeb: 5);
                  Navigator.pop(context);
                },
                trailing: Container(
                  child: Visibility(
                    visible: admin,
                    child: Icon(Icons.check),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
