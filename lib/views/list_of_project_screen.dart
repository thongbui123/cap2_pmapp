import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/project_create_step1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListOfProjectScreen extends StatefulWidget {
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> taskMap;
  final UserModel? currentUserModel;
  const ListOfProjectScreen(
      {Key? key,
      required this.projectMap,
      required this.currentUserModel,
      required this.taskMap})
      : super(key: key);

  @override
  State<ListOfProjectScreen> createState() => _ListOfProjectScreenState();
}

class _ListOfProjectScreenState extends State<ListOfProjectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<dynamic, dynamic> projectMap;
  late Map<dynamic, dynamic> taskMap;
  late Map<String, dynamic> userMap;
  List<ProjectModel> allProjects = [];
  late UserModel? userModel;
  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    userModel = widget.currentUserModel;
    allProjects = _getData();
    _tabController = TabController(length: 2, vsync: this);
  }

  List<ProjectModel> _getData() {
    List<ProjectModel> allProjects = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.projectMembers.contains(user!.uid)) {
        allProjects.add(projectModel);
      }
    }
    return allProjects;
  }

  sortDecending<T>(List<ProjectModel> list,
      Comparable<T> Function(ProjectModel obj) getAttribute) {
    setState(() {
      list.sort((a, b) => getAttribute(b).compareTo(getAttribute(a) as T));
    });
  }

  sortAscending<T>(List<ProjectModel> list,
      Comparable<T> Function(ProjectModel obj) getAttribute) {
    setState(() {
      list.sort((a, b) => getAttribute(a).compareTo(getAttribute(b) as T));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: userModel?.userRole != 'User',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProjectCreateStep1(
                    projectMap: projectMap, currentUserModel: userModel),
              ),
            );
          },
          backgroundColor: Colors.deepOrangeAccent,
          tooltip: 'Add Project', // Optional tooltip text shown on long-press
          child: Icon(
            Icons.create_new_folder,
            color: Colors.white,
          ),
          // Updated icon for the FAB
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DbSideMenu(
              userModel: userModel!,
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
                            'PROJECTS',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Recent'),
                          Tab(text: 'All'),
                        ],
                        labelStyle: TextStyle(fontFamily: 'MontMed'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _showFilterDrawer(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.filter_list, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(width: 1, height: 25, color: Colors.grey),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              _showOrderDrawer(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.import_export, size: 15),
                                SizedBox(width: 10),
                                Text(
                                  'Order',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(width: 1, height: 25, color: Colors.grey),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              _showStateDrawer(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.data_saver_off, size: 15),
                                SizedBox(width: 10),
                                Text('State',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      Container(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Content for Tab 1
                            SingleChildScrollView(
                              child: Column(
                                children: allProjects.map(
                                  (project) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Set the radius here
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ListOfTaskScreen(
                                                  projectModel: project,
                                                  projectMap: projectMap,
                                                  userModel: userModel!,
                                                  taskMap: taskMap,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        tileColor: Colors.deepOrange[50],
                                        leading: const CircleAvatar(
                                          child: Icon(
                                            Icons.folder,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        title: Text(
                                          project.projectName.toString(),
                                          style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Started Date: ${project.startDate}',
                                              style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Participant(s): ${project.projectMembers.length}',
                                              style: const TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            // Content for Tab 2
                            Container(
                              child: Column(
                                children: allProjects.map(
                                  (project) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15.0), // Set the radius here
                                      ),
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(
                                            Icons.folder,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        tileColor: Colors.deepOrange[50],
                                        title: Text(project.projectId,
                                            style: TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 13)),
                                        subtitle: Text(
                                          'Participants: 3',
                                          style: const TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 12),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
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

  bool dateVisibility = true;
  bool numberVisibility = false;
  bool nameVisibility = false;
  void _showFilterDrawer(BuildContext context) {
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
                  Text('Filter by:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.date_range_sharp),
                  title: Text('Day started',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    dateVisibility = true;
                    numberVisibility = false;
                    nameVisibility = false;
                    setState(() {
                      sortAscending(allProjects, (obj) => obj.startDate);
                      Navigator.pop(context);
                    });
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: dateVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.people_alt_outlined),
                  title: Text('Number of members',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    dateVisibility = false;
                    numberVisibility = true;
                    nameVisibility = false;
                    sortAscending(allProjects = allProjects,
                        (obj) => obj.projectMembers.length);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: numberVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.folder_open_sharp),
                  title: Text('Name',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    dateVisibility = false;
                    numberVisibility = false;
                    nameVisibility = true;

                    sortAscending(allProjects, (obj) => obj.projectName);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: nameVisibility,
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }

  bool ascendingVisibility = true;
  bool descendingVisibility = false;
  void _showOrderDrawer(BuildContext context) {
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
                  Text('Order:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.arrow_downward),
                  title: Text('Ascending',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    ascendingVisibility = true;
                    descendingVisibility = false;
                    sortAscending(allProjects, (obj) => obj.projectName);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: ascendingVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text('Descending',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    ascendingVisibility = false;
                    descendingVisibility = true;
                    sortDecending(allProjects, (obj) => obj.projectName);
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: descendingVisibility,
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }

  bool completedVisibility = true;
  bool incompletedVisibility = false;
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
                  leading: Icon(Icons.mood),
                  title: Text('Completed',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    completedVisibility = true;
                    incompletedVisibility = false;

                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: completedVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.mood_bad),
                  title: Text('Incompleted',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    completedVisibility = false;
                    incompletedVisibility = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: incompletedVisibility,
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }
}

class filteredList extends StatefulWidget {
  const filteredList({super.key});

  @override
  State<filteredList> createState() => _filteredListState();
}

List<String> list = <String>['Ascending', 'Descending'];

class _filteredListState extends State<filteredList> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontFamily: 'MontMed', color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
