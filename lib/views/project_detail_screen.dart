import 'package:capstone2_project_management_app/models/phrase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/phrase_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/bottom_sheet_widget.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  final UserModel userModel;
  final ProjectModel projectModel;
  final Map<String, dynamic> userMap;
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> phraseMap;

  const ProjectDetailScreen({
    Key? key,
    required this.userModel,
    required this.projectModel,
    required this.userMap,
    required this.projectMap,
    required this.phraseMap,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

List<String> currentList = [];
List<PhraseModel> listOfPhrase = [];

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late ProjectModel _projectModel;
  late PhraseModel phraseModel;
  UserServices userServices = UserServices();
  late UserModel _userModel;
  PhraseServices phraseServices = PhraseServices();
  List<UserModel> allMembers = [];
  List<String> allMemberIds = [];
  late Map<String, dynamic> userMap;
  Map<String, PhraseModel> currentPhraseMap = {};
  List<UserModel> currentList = [];
  bool _customTileExpanded = false;
  late Map<dynamic, dynamic> projectMap;
  late String currentPhraseName;
  late String currentPhraseId;
  late int selectedIndex;
  late Map phraseMap;
  Map<int, String> mapPhraseIndex = {};
  late int memberLength;
  @override
  void initState() {
    super.initState();
    _projectModel = widget.projectModel;
    userMap = widget.userMap;
    _userModel = widget.userModel;
    projectMap = widget.projectMap;
    currentPhraseName = _projectModel.projectStatus;
    phraseMap = widget.phraseMap;
    memberLength = _projectModel.projectMembers.length;
    allMembers = userServices.getUserDataList(userMap).cast<UserModel>();
    allMemberIds = userServices.getUserIdList(userMap);
    mapPhraseIndex = phraseServices.getMapPhraseIndex(phraseMap);
    selectedIndex = phraseServices.getPhraseIndex(phraseMap, currentPhraseName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            db_side_menu(),
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
                                      builder: (context) => ListOfTasks(
                                          projectModel: _projectModel,
                                          projectMap: projectMap,
                                          userModel: _userModel)),
                                );
                              }),
                          const Text(
                            'PROJECT',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(
                            child: Icon(Icons.folder, color: Colors.orange)),
                        title: Text(
                            'Project Name: ${_projectModel.projectName}',
                            style: const TextStyle(
                                fontFamily: 'MontMed',
                                color: Colors.black,
                                fontSize: 13)),
                        subtitle: Text(
                          'Current State: $currentPhraseName',
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
                                      fontFamily: 'MontMed', fontSize: 14))
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
                          currentPhraseName,
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
                        trailing: Visibility(
                          visible: _userModel.userRole != 'User',
                          child: TextButton(
                            onPressed: () {
                              _showStateBottomSheet(
                                  context, _projectModel.projectMembers);
                            },
                            child: const Text(
                              'View All ',
                              style: TextStyle(
                                  fontFamily: 'MontMed', fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.settings),
                        ),
                        title: const Text('Advanced Options',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 14)),
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
  }

  Future<void> _showMemberSelectionDialog() async {
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
                      leading: const CircleAvatar(
                          child: Text(
                        'A',
                        style: TextStyle(fontFamily: 'MontMed'),
                      )),
                      title: Text(user.userId),
                      subtitle: const Text(
                        '2 Projects Involved',
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
                  Text('State: $currentPhraseName',
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
                      currentPhraseName = mapPhraseIndex[selectedIndex]!;
                      _updateProjectStatus(currentPhraseName);
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
                  if (selectedIndex < phraseMap.length - 1) {
                    setState(() {
                      selectedIndex++;
                      currentPhraseName = mapPhraseIndex[selectedIndex]!;
                      _updateProjectStatus(currentPhraseName);
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

  Future<void> _updateProjectStatus(String currentPhraseName) async {
    DatabaseReference projectRef =
        FirebaseDatabase.instance.ref().child('projects');

    projectRef.child(_projectModel.projectId).update({
      'projectStatus': currentPhraseName,
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

  void _showStateBottomSheet(
      BuildContext context, List<String> currentStringList) {
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
          phraseMap: phraseMap,
          userModel: _userModel,
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
      currentList.add(member);
      allMembers.remove(member);
    });
  }
}
