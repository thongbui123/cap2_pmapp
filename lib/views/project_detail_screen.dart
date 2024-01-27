import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';

class projectDetailScreen extends StatefulWidget {
  final ProjectModel projectModel;
  final Map<String, dynamic> userMap;
  const projectDetailScreen(
      {Key? key, required this.projectModel, required this.userMap})
      : super(key: key);

  @override
  State<projectDetailScreen> createState() => _projectDetailScreenState();
}

List<String> allMembers = [
  'User 1',
  'User 2',
  'User 3',
];

List<String> currentList = [

];

class _projectDetailScreenState extends State<projectDetailScreen> {
  late ProjectModel projectModel;
  UserServices userServices = UserServices();
  List<UserModel> allMembers = [];
  late Map<String, dynamic> userMap;
  List<String> currentList = [];

  bool _customTileExpanded = false;

  @override
  void initState() {
    super.initState();
    projectModel = widget.projectModel;
    userMap = widget.userMap;
    allMembers = userServices.getUserDataList(userMap).cast<UserModel>();
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
                            'PROJECT',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                            child: Icon(Icons.folder, color: Colors.orange)),
                        title: Text('Project Name: ${projectModel.projectName}',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                color: Colors.black,
                                fontSize: 13)),
                        subtitle: Text(
                          'Current State: ${projectModel.projectStatus}',
                          style: TextStyle(fontFamily: 'MontMed', fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 50,
                        height: 1,
                        color: Colors.black,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Description: ${projectModel.projecctDescription}',
                        style: TextStyle(
                            fontFamily: 'MontMed',
                            color: Colors.black87,
                            fontSize: 12),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                            child: Text(
                          'T',
                          style: TextStyle(fontFamily: 'MontMed'),
                        )),
                        title: Text('Assigned by: ',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 12,
                                color: Colors.black54)),
                        subtitle: Text('${projectModel.managerId}',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                      ),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.calendar_month),
                        ),
                        title: Text('Start Date: ',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 12,
                                color: Colors.black54)),
                        subtitle: Text('${projectModel.startDate}',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                        trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('End Date: ',
                                  style: TextStyle(
                                      fontFamily: 'MontMed',
                                      fontSize: 12,
                                      color: Colors.black54)),
                              Text('${projectModel.endDate}',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14))
                            ]),
                      ),
                      Divider(),
                      ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.account_tree_outlined),
                          ),
                          title: Text('Current Phrase: ',
                              style: TextStyle(
                                  fontFamily: 'MontMed',
                                  fontSize: 12,
                                  color: Colors.black54)),
                          subtitle: Text('Requirement Gathering',
                              style: TextStyle(
                                  fontFamily: 'MontMed', fontSize: 14)),
                          trailing: TextButton(
                              onPressed: () {
                                _showStateDrawer(context);
                              },
                              child: Text('Alter',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)))),
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.people),
                        ),
                        title: Text('Participants: ',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 12,
                                color: Colors.black54)),
                        subtitle: Text(
                            '${projectModel.projectMembers.length} participant(s) ',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                      ),
                      Divider(),
                      SizedBox(height: 5),
                      Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: TextButton(
                            onPressed: _showMemberSelectionDialog,
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
                                      fontFamily: 'MontMed',
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          )
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.people),
                        ),
                        title: Text('Participants: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 12, color: Colors.black54)),
                        subtitle: Text('4 participants ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                        trailing: TextButton(onPressed: (){_showStateBottomSheet(context);}, child: Text('View All ', style: TextStyle(fontFamily: 'MontMed', fontSize: 14))),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                        child: Column(
                          children: currentList.map((member) {
                            return ListTile(
                              leading: const CircleAvatar(
                                  child: Text(
                                'A',
                                style: TextStyle(fontFamily: 'MontMed'),
                              )),
                              title: Text(member,
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)),
                              subtitle: Text(
                                'Member',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                              trailing: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Remove',
                                  style: TextStyle(fontFamily: 'MontMed'),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(),
                      ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.settings),
                          ),
                          title: Text('Advanced Options',
                              style: TextStyle(
                                  fontFamily: 'MontMed', fontSize: 14)),
                          trailing: TextButton(
                              onPressed: () {
                                _showStateDrawer2(context);
                              },
                              child: Text('View',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14)))),
                      Divider(),
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
                      subtitle: Text(
                        '2 Projects Involved',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        _addMember(user.userId);
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
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('State:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Reverse Phrase',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_forward),
                title: Text('Conclude Phrase',
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
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('Advanced Settings:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                leading: Icon(Icons.stop_screen_share_outlined),
                title: Text('Halt Project',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel_presentation_outlined),
                title: Text('Cancel Project',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.screen_rotation_alt),
                title: Text('Relaunch Project',
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

  void _showStateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBottomSheetWidget(message: 'Hello');
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

class StatefulBottomSheetWidget extends StatefulWidget {
  final String message;

  StatefulBottomSheetWidget({required this.message});

  @override
  _StatefulBottomSheetWidgetState createState() =>
      _StatefulBottomSheetWidgetState();
}

class _StatefulBottomSheetWidgetState extends State<StatefulBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
              child: TextButton(
                onPressed: _showMemberSelectionDialog,
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.blueAccent,),
                    SizedBox(width: 10),
                    Text(
                      'Add New Participant',
                      style: TextStyle(fontFamily: 'MontMed', color: Colors.blueAccent),
                    ),
                  ],
                ),
              )
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(
              children: ListTile.divideTiles(
                context: context,  // Make sure to provide the BuildContext if this code is inside a widget build method
                tiles: currentList.map((member) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    title: Text(member, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: Text(
                      'Participants: 3',
                      style: const TextStyle(fontFamily: 'MontMed', fontSize: 12),
                    ),
                  );
                }),
              ).toList(),
            ),
          ),
        ],
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
                      title: Text(user),
                      subtitle: Text(
                        '2 Projects Involved',
                        style: TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        setState(() {
                          currentList.add(user);
                        });
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
}

