import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/task_screen/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/bottom_sheet_widget.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectDetailScreen extends StatefulWidget {
  final UserModel userModel;
  final ProjectModel projectModel;
  final Map<String, dynamic> userMap;
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> phraseMap;
  final Map<dynamic, dynamic> taskMap;
  const ProjectDetailScreen({
    Key? key,
    required this.userModel,
    required this.projectModel,
    required this.userMap,
    required this.projectMap,
    required this.phraseMap,
    required this.taskMap,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

List<String> currentList = [];
List<String> allMembers = [];
List<PhaseModel> listOfPhrase = [];

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late ProjectModel _projectModel;
  late PhaseModel phraseModel;
  UserServices userServices = UserServices();
  late UserModel _userModel;
  PhaseServices phaseServices = PhaseServices();
  List<UserModel> allMembers = [];
  List<String> allMemberIds = [];
  late Map<String, dynamic> userMap;
  Map<String, PhaseModel> currentPhraseMap = {};
  List<UserModel> currentListModel = [];
  bool _customTileExpanded = false;
  late Map<dynamic, dynamic> projectMap;
  late String currentPhaseName;
  late String currentPhaseId;
  late int selectedIndex;
  late Map phaseMap;
  late Map taskMap;
  late List<PhaseModel> listPhases;
  Map<int, String> mapPhaseIndex = {};
  Map<int, String> mapPhaseId = {};
  Map<String, bool> mapGetNotification = {};
  late int memberLength;
  @override
  void initState() {
    super.initState();
    _projectModel = widget.projectModel;
    userMap = widget.userMap;
    _userModel = widget.userModel;
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    phaseMap = widget.phraseMap;
    currentPhaseName = phaseServices.getPhaseNameFromId(
        phaseMap, _projectModel.currentPhaseId);
    listPhases =
        phaseServices.getPhaseListByProject(phaseMap, _projectModel.projectId);
    memberLength = _projectModel.projectMembers.length;
    allMembers = userServices.getUserDataList(userMap).cast<UserModel>();
    allMemberIds = userServices.getUserIdList(userMap);
    mapPhaseIndex = phaseServices.getMapPhaseIndex(listPhases);
    mapPhaseId = phaseServices.getMapPhaseId(listPhases);
    selectedIndex = phaseServices.getPhraseIndex(listPhases, currentPhaseName);
    currentPhaseId = mapPhaseId[selectedIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: NotificationService().databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var event = snapshot.data! as DatabaseEvent;
          var value = event.snapshot.value as dynamic;
          Map notifiMap = Map<String, dynamic>.from(value);
          int numNr =
              NotificationService().getListAllNotRead(notifiMap, uid).length;
          return Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DbSideMenu(
                    userModel: _userModel,
                    numNotRead: numNr,
                  ),
                  Expanded(
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
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListOfTaskScreen(
                                                  projectModel: _projectModel,
                                                  projectMap: projectMap,
                                                  userModel: _userModel,
                                                  taskMap: taskMap,
                                                )),
                                      );
                                    }),
                                const Text(
                                  'PROJECT',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 20),
                                ),
                              ],
                            ),
                            const Divider(),
                            ListTile(
                              leading: const CircleAvatar(
                                  child:
                                      Icon(Icons.folder, color: Colors.orange)),
                              title: Text(
                                  'Project Name: ${_projectModel.projectName}',
                                  style: const TextStyle(
                                      fontFamily: 'MontMed',
                                      color: Colors.black,
                                      fontSize: 13)),
                              subtitle: Text(
                                'Current State: ${_projectModel.projectStatus}',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 50,
                              height: 1,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Description: ${_projectModel.projecctDescription}',
                              style: const TextStyle(
                                  fontFamily: 'MontMed',
                                  color: Colors.black87,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            ListTile(
                              leading: avatar(userMap, _projectModel.managerId),
                              title: const Text('Assigned by: ',
                                  style: TextStyle(
                                      fontFamily: 'MontMed',
                                      fontSize: 12,
                                      color: Colors.black54)),
                              subtitle: Text(
                                  userServices.getNameFromId(
                                      userMap, _projectModel.managerId),
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.calendar_month),
                              ),
                              title: const Text('Start Date: ',
                                  style: TextStyle(
                                      fontFamily: 'MontMed',
                                      fontSize: 12,
                                      color: Colors.black54)),
                              subtitle: Text(_projectModel.startDate,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)),
                              trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text('End Date: ',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    Text(_projectModel.endDate,
                                        style: const TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 14))
                                  ]),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.account_tree_outlined),
                              ),
                              title: const Text('Current Phrase: ',
                                  style: TextStyle(
                                      fontFamily: 'MontMed',
                                      fontSize: 12,
                                      color: Colors.black54)),
                              subtitle: Text(
                                currentPhaseName,
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 14),
                              ),
                              trailing: Visibility(
                                visible: _userModel.userRole != 'User',
                                child: TextButton(
                                  onPressed: () {
                                    _showStateDrawer(context);
                                  },
                                  child: const Text('Alter',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 14)),
                                ),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 5),
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.people),
                              ),
                              title: const Text(
                                'Participants: ',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                              subtitle: Text(
                                '$memberLength member(s)',
                                style: const TextStyle(
                                  fontFamily: 'MontMed',
                                  fontSize: 14,
                                ),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  _showStateBottomSheet(
                                      context,
                                      _projectModel.projectMembers,
                                      allMemberIds);
                                },
                                child: const Text(
                                  'View All ',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14),
                                ),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.settings),
                              ),
                              title: const Text('Advanced Options',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)),
                              trailing: Visibility(
                                visible: _userModel.userRole != 'User',
                                child: TextButton(
                                  onPressed: () {
                                    _showStateDrawer2(context);
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

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
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('State: $currentPhaseName',
                      style:
                          const TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.arrow_back),
                title: const Text('Reverse Phrase',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  if (selectedIndex > 0) {
                    setState(() {
                      selectedIndex--;
                      currentPhaseName = mapPhaseIndex[selectedIndex]!;
                      currentPhaseId = mapPhaseId[selectedIndex]!;
                      _updateProjectStatus(
                          currentPhaseName, currentPhaseId, uid);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward),
                title: const Text('Conclude Phrase',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  if (selectedIndex < listPhases.length - 1) {
                    setState(() {
                      selectedIndex++;
                      currentPhaseName = mapPhaseIndex[selectedIndex]!;
                      currentPhaseId = mapPhaseId[selectedIndex]!;
                      _updateProjectStatus(
                          currentPhaseName, currentPhaseId, uid);
                    });
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProjectStatus(
      String currentPhraseName, String currentPhaseId, String uid) async {
    DatabaseReference projectRef =
        FirebaseDatabase.instance.ref().child('projects');
    DateTime now = DateTime.now();
    DateTime endDate = DateTime.parse(_projectModel.endDate);
    if (selectedIndex >= 6) {
      if (now.isAfter(endDate)) {
        projectRef.child(_projectModel.projectId).update({
          'projectStatus': 'Overdue',
        });
      } else {
        projectRef.child(_projectModel.projectId).update({
          'projectStatus': 'Done',
        });
      }
    } else {
      if (now.isAfter(endDate)) {
        projectRef.child(_projectModel.projectId).update({
          'projectStatus': 'Overdue',
        });
      } else {
        projectRef.child(_projectModel.projectId).update({
          'projectStatus': 'In progress',
        });
      }
    }
    projectRef.child(_projectModel.projectId).update({
      //'projectStatus': currentPhraseName,
      'currentPhaseId': currentPhaseId,
    });
    DatabaseEvent snapshot = await projectRef.once();
    DatabaseEvent databaseEventModel =
        await projectRef.child(_projectModel.projectId).once();
    if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
      setState(() {
        projectMap = Map.from(snapshot.snapshot.value as dynamic);
        _projectModel = ProjectModel.fromMap(Map<String, dynamic>.from(
            databaseEventModel.snapshot.value as dynamic));
      });
    }
    List<String> notificationReceivers = _projectModel.projectMembers;
    if (uid != _projectModel.managerId) {
      notificationReceivers.add(_projectModel.managerId);
    }
    if (uid != _projectModel.leaderId) {
      notificationReceivers.add(_projectModel.leaderId);
    }
    String notificationContent =
        'The current phase of ${_projectModel.projectName.toUpperCase()} project has been changed';
    NotificationService().addNotification(notificationContent,
        _projectModel.projectId, notificationReceivers, 'Project');
    Fluttertoast.showToast(
        msg:
            'You have changed the current phase of ${_projectModel.projectName.toUpperCase()} project');
  }

  void _showStateDrawer2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Your bottom drawer content goes here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Row(
                children: [
                  SizedBox(width: 25),
                  Text('Advanced Settings:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.stop_screen_share_outlined),
                title: const Text('Halt Project',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel_presentation_outlined),
                title: const Text('Cancel Project',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.screen_rotation_alt),
                title: const Text('Relaunch Project',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStateBottomSheet(BuildContext context,
      List<String> currentStringList, List<String> allStaff) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget(
          message: 'Hello',
          allMembers: allMemberIds,
          currentList: currentStringList,
          userMap: userMap,
          projectMap: projectMap,
          projectModel: _projectModel,
          phraseMap: phaseMap,
          userModel: _userModel,
          taskMap: taskMap,
        );
      },
    );
  }

  void _memberLengthUpdate(int newLength) {
    setState(() {
      memberLength = newLength;
    });
  }

  void _removeMember(UserModel member) {
    setState(() {
      currentList.remove(member);
      allMembers.add(member);
    });
  }

  void _addMember(UserModel member) {
    setState(() {
      currentList.add(member.userId);
      allMembers.remove(member);
    });
  }
}
