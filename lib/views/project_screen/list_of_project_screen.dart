import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/views/project_screen/project_create_step1.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:capstone2_project_management_app/views/task_screen/list_of_tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    allProjects = userModel!.userRole != 'Admin'
        ? _getData()
        : ProjectServices().getAllProjectList(projectMap);
    _tabController = TabController(length: 2, vsync: this);
  }

  List<ProjectModel> _getData() {
    List<ProjectModel> allProjects = [];
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      if (projectModel.projectMembers.contains(user!.uid) ||
          projectModel.leaderId == user!.uid ||
          projectModel.managerId == user!.uid) {
        allProjects.add(projectModel);
      }
    }
    return allProjects;
  }

  String currentAttribute = "";
  String currentOrder = "";
  String currentStatus = "";
  void _sortProjects(
      String currentAttribute, String currentOrder, String currentStatus) {
    setState(() {
      switch (currentAttribute) {
        case 'projectId':
          allProjects.sort((a, b) => currentOrder == 'asc'
              ? a.projectId.compareTo(b.projectId)
              : b.projectId.compareTo(a.projectId));
          break;
        case 'projectName':
          allProjects.sort((a, b) => currentOrder == 'asc'
              ? a.projectName.compareTo(b.projectName)
              : b.projectName.compareTo(a.projectName));
          break;
        case 'projectMembers':
          allProjects.sort((a, b) => currentOrder == 'asc'
              ? a.projectMembers.length.compareTo(b.projectMembers.length)
              : b.projectMembers.length.compareTo(a.projectMembers.length));
          break;
        case 'startDate':
          allProjects.sort((a, b) => currentOrder == 'asc'
              ? a.startDate.compareTo(b.startDate)
              : b.startDate.compareTo(a.startDate));
          break;
        case 'projectStatus':
          allProjects.sort((a, b) {
            if (a.projectStatus == currentStatus &&
                b.projectStatus != currentStatus) {
              return currentOrder == 'asc' ? -1 : 1;
            } else if (a.projectStatus != currentStatus &&
                b.projectStatus == currentStatus) {
              return currentOrder == 'asc' ? 1 : -1;
            } else {
              return currentOrder == 'asc'
                  ? a.projectStatus.compareTo(b.projectStatus)
                  : b.projectStatus.compareTo(a.projectStatus);
            }
          });
          break;
        default:
          // do nothing
          break;
      }
    });
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
    return StreamBuilder<Object>(
        stream: NotificationService().databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var event = snapshot.data! as DatabaseEvent;
          var value = event.snapshot.value as dynamic;
          Map notifiMap = Map<String, dynamic>.from(value);
          //NotificationService().databaseReference.onValue
          int numNr =
              NotificationService().getListAllNotRead(notifiMap, uid).length;
          return Scaffold(
            floatingActionButton: Visibility(
              visible: userModel?.userRole == 'Admin' ||
                  userModel?.userRole == 'Manager',
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
                tooltip:
                    'Add Project', // Optional tooltip text shown on long-press
                child: const Icon(
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
                    numNotRead: numNr,
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
                                      fontFamily: 'MontMed', fontSize: 20),
                                ),
                              ],
                            ),
                            Divider(),
                            TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(text: 'New'),
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
                                        'Sort',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                    width: 1, height: 25, color: Colors.grey),
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
                                            fontFamily: 'MontMed',
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                    width: 1, height: 25, color: Colors.grey),
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
                                              fontFamily: 'MontMed',
                                              fontSize: 14)),
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
                                      children: allProjects.take(4).map(
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
                                    child: SingleChildScrollView(
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
                                                          projectMap:
                                                              projectMap,
                                                          userModel: userModel!,
                                                          taskMap: taskMap,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                leading: const CircleAvatar(
                                                  child: Icon(
                                                    Icons.folder,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                tileColor:
                                                    Colors.deepOrange[50],
                                                title: Text(project.projectName,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 13)),
                                                subtitle: Text(
                                                  'Participants: ${project.projectMembers.length}',
                                                  style: const TextStyle(
                                                      fontFamily: 'MontMed',
                                                      fontSize: 12),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
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
        });
  }

  bool dateVisibility = true;
  bool numberVisibility = false;
  bool nameVisibility = false;
  bool ascendingVisibility = true;
  bool descendingVisibility = false;
  bool completedVisibility = true;
  bool incompletedVisibility = false;
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
                  Text('Sort by:',
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
                    currentAttribute = 'startDate';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
                    Navigator.pop(context);
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
                    currentAttribute = 'projectMembers';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
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
                    currentAttribute = 'projectName';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
                    //sortAscending(allProjects, (obj) => obj.projectName);
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
                    currentOrder = 'asc';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
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
                    currentOrder = 'desc';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
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
                    currentStatus = 'Done';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
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
                    currentStatus = 'In progress';
                    _sortProjects(
                        currentAttribute, currentOrder, currentStatus);
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
