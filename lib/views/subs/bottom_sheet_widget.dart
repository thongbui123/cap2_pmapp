import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/project_screen/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class StatefulBottomSheetWidget extends StatefulWidget {
  final ProjectModel projectModel;
  final UserModel userModel;
  final String message;
  final List<String> allMembers;
  final List<String> currentList;
  final Map<String, dynamic> userMap;
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> phraseMap;
  final Map<dynamic, dynamic> taskMap;
  const StatefulBottomSheetWidget(
      {super.key,
      required this.message,
      required this.allMembers,
      required this.currentList,
      required this.userMap,
      required this.projectMap,
      required this.projectModel,
      required this.phraseMap,
      required this.userModel,
      required this.taskMap});

  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  late ProjectModel projectModel;
  late UserModel currentUserModel;
  late List<String> allMembers;
  late List<String> allLeader;
  late List<String> allStaff;
  late List<String> currentList;
  late Map<String, dynamic> userMap;
  Map<String, String> mapName = {};
  UserServices userServices = UserServices();
  late Map<dynamic, dynamic> projectMap;
  late Map<dynamic, dynamic> phraseMap;
  late Map<dynamic, dynamic> taskMap;
  late int joinProjectNumber;
  ProjectServices projectServices = ProjectServices();
  late DatabaseReference projectRef;
  String selectedMember = '';
  Map<String, bool> mapGetNotification = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserModel = widget.userModel;
    allMembers = widget.allMembers;
    userMap = widget.userMap;
    currentList = widget.currentList;
    projectMap = widget.projectMap;
    projectModel = widget.projectModel;
    phraseMap = widget.phraseMap;
    taskMap = widget.taskMap;
    projectRef = FirebaseDatabase.instance
        .ref()
        .child('projects')
        .child(projectModel.projectId);
    allLeader = userServices.getAllLeaderStringList(userMap);
    allStaff = userServices.getAllUserStringList(userMap);
    currentList.forEach((element) {
      if (allStaff.contains(element)) {
        allStaff.remove(element);
      }
    });
    currentList.forEach((element) {
      mapGetNotification[element] = false;
    });
    selectedMember = projectModel.projectMembers.first;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          ProjectServices().reference.onValue,
          ProjectServices().reference.child(projectModel.projectId).onValue
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return loader();
          }
          var event0 = snapshot.data![0] as DatabaseEvent;
          var event1 = snapshot.data![1] as DatabaseEvent;
          var value0 = event0.snapshot.value as dynamic;
          var value1 = event1.snapshot.value as dynamic;
          projectMap = Map.from(value0);
          projectModel = ProjectModel.fromMap(Map.from(value1));
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Visibility(
                  visible: currentUserModel.userRole != 'User',
                  child: Container(
                      child: TextButton(
                    onPressed: () => _showMemberSelectionDialog(allStaff),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Add New Participant',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  )),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: ListTile.divideTiles(
                        context:
                            context, // Make sure to provide the BuildContext if this code is inside a widget build method
                        tiles: currentList.map((member) {
                          return ListTile(
                            leading: avatar(userMap, member),
                            title: Text(
                                userServices.getNameFromId(userMap, member),
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 13)),
                            subtitle: Text(
                              'Joined project numbers: ${projectServices.getJoinedProjectNumber(projectMap, member)}',
                              style: const TextStyle(
                                  fontFamily: 'MontMed', fontSize: 12),
                            ),
                            trailing: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(),
                              ),
                              child: (member != currentList.first)
                                  ? Visibility(
                                      visible: projectModel.projectMembers
                                              .contains(uid) ||
                                          projectModel.leaderId == uid ||
                                          projectModel.managerId == uid ||
                                          currentUserModel!.userRole == 'Admin',
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          _showDeleteMemberDialog(member);
                                        },
                                      ),
                                    )
                                  : Visibility(
                                      visible: projectModel.projectMembers
                                              .contains(uid) ||
                                          projectModel.leaderId == uid ||
                                          projectModel.managerId == uid ||
                                          currentUserModel!.userRole == 'Admin',
                                      child: IconButton(
                                        icon: const Icon(Icons.change_circle),
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          _showLeaderSelectionDialog(allLeader);
                                        },
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ).toList(),
                    ),
                  ),
                ),
                Visibility(
                  visible: projectModel.projectMembers.contains(uid) ||
                      projectModel.leaderId == uid ||
                      projectModel.managerId == uid ||
                      currentUserModel!.userRole == 'Admin',
                  child: TextButton(
                      onPressed: () async {
                        DatabaseReference projectRef =
                            FirebaseDatabase.instance.ref().child('projects');
                        await projectRef.child(projectModel.projectId).update({
                          'projectMembers': currentList,
                        });
                        // DatabaseEvent snapshot = await projectRef.once();
                        // if (snapshot.snapshot.value != null &&
                        //     snapshot.snapshot.value is Map) {
                        //   setState(() {
                        //     projectMap =
                        //         Map.from(snapshot.snapshot.value as dynamic);
                        //   });
                        // }
                        //Navigator.of(context).pop();
                        List<String> afterList =
                            getAfterList(mapGetNotification);
                        if (afterList.isNotEmpty) {
                          String notificationContent =
                              'You have been added to the project of ${projectModel.projectName.toUpperCase()} as Member role';
                          NotificationService().addNotification(
                              notificationContent,
                              projectModel.projectId,
                              afterList,
                              'Project');
                          Fluttertoast.showToast(
                              msg:
                                  'You have been added new members to the project of ${projectModel.projectName.toUpperCase()}');
                        }
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailScreen(
                              projectModel: projectModel,
                              userMap: userMap,
                              projectMap: projectMap,
                              phraseMap: phraseMap,
                              userModel: currentUserModel,
                              taskMap: taskMap,
                            ),
                          ),
                        );
                        currentList = projectModel.projectMembers;
                      },
                      child: const Text('SAVE')),
                ),
              ],
            ),
          );
        });
  }

  List<String> getAfterList(Map<String, bool> map) {
    List<String> afterList = [];
    for (var element in map.keys) {
      if (map[element] == true) {
        afterList.add(element);
      }
    }
    return afterList;
  }

  Future<void> _showMemberSelectionDialog(List<String> allMembers) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MEMBERS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: allMembers.map((user) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: avatar(userMap, user),
                      title: Text(userServices.getNameFromId(userMap, user)),
                      subtitle: Text(
                        '${projectServices.getJoinedProjectNumber(projectMap, user)} Project(s) Involved',
                        style: const TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () async {
                        setState(() {
                          currentList.add(user);
                          allStaff.remove(user);
                          mapGetNotification[user] = true;
                        });

                        Navigator.of(context).pop();
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

  Future<void> _showLeaderSelectionDialog(List<String> allMembers) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'MEMBERS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: allMembers.map((user) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: avatar(userMap, user),
                      title: Text(userServices.getNameFromId(userMap, user)),
                      subtitle: Text(
                        '${projectServices.getJoinedProjectNumber(projectMap, user)} Project(s) Involved',
                        style: const TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () async {
                        setState(() {
                          _changeTeamLeader(user);
                        });

                        Navigator.of(context).pop();
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

  Future<void> _showDeleteMemberDialog(String member) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('REMOVE MEMBER'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do You Want To Remove This Member?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setState(() {
                  currentList.remove(member);
                  allStaff.add(member);
                  mapGetNotification[member] = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeTeamLeader(String member) {
    setState(() {
      selectedMember = member;
      currentList.first = selectedMember;
    });
  }
}
