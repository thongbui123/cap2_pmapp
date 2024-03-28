// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/views/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/search_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardMainV1 extends StatefulWidget {
  final UserModel? currentUserModel;
  final Map<dynamic, dynamic> projectMap;
  final Map<dynamic, dynamic> taskMap;
  const DashboardMainV1(
      {Key? key,
      required this.currentUserModel,
      required this.projectMap,
      required this.taskMap})
      : super(key: key);

  @override
  State<DashboardMainV1> createState() => _DashboardMainV1State();
}

class _DashboardMainV1State extends State<DashboardMainV1> {
  ProjectServices projectServices = ProjectServices();
  TaskService taskService = TaskService();
  UserModel? currentUserModel;
  final databaseReference = FirebaseDatabase.instance.ref();
  DatabaseReference? projectRef;
  Map<dynamic, dynamic> projectMap = {};
  Map<dynamic, dynamic> taskMap = {};
  List<ProjectModel> allProjects = [];
  List<ProjectModel> joinedProjects = [];
  int overdouProjectNumber = 0;
  List<TaskModel> listAllTasks = [];
  Future<void> getProjectMap() async {
    DatabaseEvent databaseEvent =
        await databaseReference.child('projects').once();
    if (databaseEvent.snapshot.value != null) {
      projectMap = Map.from(databaseEvent.snapshot.value as dynamic);
      _getProjectDetails();
    }
  }

  Future<void> _getProjectDetails() async {
    for (var project in projectMap.values) {
      ProjectModel projectModel =
          ProjectModel.fromMap(Map<String, dynamic>.from(project));
      allProjects.add(projectModel);
      if (projectModel.leaderId == currentUserModel?.userId) {
        joinedProjects.add(projectModel);
      }
      if (projectModel.startDate != "" && projectModel.endDate != "") {
        DateFormat format = DateFormat('yyyy-MM-dd');
        DateTime getEndDate = format.parse(projectModel.endDate);
        if (DateTime.now().isAfter(getEndDate)) {
          overdouProjectNumber++;
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    currentUserModel = widget.currentUserModel;
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    listAllTasks = taskService.getTaskListOnlyContainUser(
        taskMap, currentUserModel!.userId);
    _getData();
    //_getProjectDetails();
  }

  _getData() async {
    //await getProjectMap();
    await _getProjectDetails();
    //projectMap = await projectServices.getProjectMap();
  }

  @override
  Widget build(BuildContext context) {
    return projectMap.isEmpty
        ? const Center(
            child: Column(
            children: [CircularProgressIndicator(), Text('Please')],
          ))
        : SafeArea(
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'WELCOME BACK, ${currentUserModel?.userFirstName.toUpperCase()}',
                      style: const TextStyle(
                        fontFamily: 'MontMed',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Align(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontMed',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFD9D9D9)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              labelText: 'Search here...',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Color(0xFFD9D9D9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                            height: 50,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => search_screen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.search),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the border radius
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ListOfTaskScreen(
                                                userModel: currentUserModel!,
                                                projectMap: projectMap,
                                                taskMap: taskMap,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.layers,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'TASKS',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${TaskService().getJoinedTaskNumber(taskMap, currentUserModel!.userId)} on going',
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'MontMed'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[50],
                          borderRadius: BorderRadius.circular(
                              5.0), // Set the border radius
                        ),
                        //height: 125,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ListOfProjectScreen(
                                              currentUserModel:
                                                  currentUserModel,
                                              projectMap: projectMap,
                                              taskMap: taskMap,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.folder,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'PROJECTS',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${joinedProjects.length.toString()} on going',
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'MontMed'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          color: Colors.indigo[50],
                          child: Row(
                            children: [
                              Icon(Icons.playlist_remove_rounded,
                                  size: 30, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Overdue:',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 12)),
                                  Text(
                                      '${taskService.getOverdouTaskNumber(taskMap, currentUserModel!.userId)} Task(s)',
                                      style: TextStyle(fontFamily: 'MontMed'))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          color: Colors.deepOrange[50],
                          child: Row(
                            children: [
                              const Icon(Icons.rule_folder_sharp,
                                  size: 30, color: Colors.redAccent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Overdue:',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12)),
                                    Text('$overdouProjectNumber Project(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'MontMed',
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          color: Colors.indigo[50],
                          child: Row(
                            children: [
                              Icon(Icons.layers,
                                  size: 30, color: Colors.blueAccent),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Finalized:',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 12)),
                                  Text(
                                      '${taskService.getCompleteTaskNumber(taskMap, currentUserModel!.userId)} Task(s)',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'MontMed'))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          color: Colors.deepOrange[50],
                          child: Row(
                            children: [
                              Icon(Icons.folder_special,
                                  size: 30, color: Colors.green),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Finalized:',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12)),
                                    Text(
                                        '${projectServices.getCompleteProjectNumber(projectMap, currentUserModel!.userId)} Project(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontFamily: 'MontMed'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.green[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the border radius
                          ),
                          height: 200,
                          child: Dashboard_chart(
                            listAllTasks: listAllTasks,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 150,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 45),
                            const Text(
                              'THIS WEEK TASKS',
                              style: TextStyle(
                                fontFamily: 'MontMed',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Overdue',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'In Progress',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Done',
                                  style: TextStyle(
                                      fontFamily: 'MontMed', fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.deepOrange[50],
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            SizedBox(width: 20),
                            Text('RECENT PROJECTS',
                                style: TextStyle(
                                    fontFamily: 'MontMed',
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Divider(),
                        ),
                        Column(
                          children: joinedProjects.map((project) {
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.black12,
                                child: Icon(
                                  Icons.folder,
                                  color: Colors.orange,
                                ),
                              ),
                              title: Text(project.projectName,
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 13)),
                              subtitle: Text(
                                '${project.projectMembers.length.toString()} participant(s)',
                                style: const TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  DateTime? stringToDateTime(
    String dateString,
  ) {
    try {
      String format = "yyyy-MM-dd";
      return DateFormat(format).parse(dateString);
    } catch (e) {
      print("Error parsing date: $e");
      return null; // or throw an exception, depending on your needs
    }
  }
}

class Dashboard_chart extends StatefulWidget {
  List<TaskModel> listAllTasks;
  Dashboard_chart({
    Key? key,
    required this.listAllTasks,
  }) : super(key: key);

  @override
  State<Dashboard_chart> createState() => _Dashboard_chartState();
}

class _Dashboard_chartState extends State<Dashboard_chart> {
  late List<TaskModel> listAllTasks;
  int totalTasks = 0;
  int doneTaskNumber = 0;
  int overdueTaskNumber = 0;
  int inProgressTaskNumber = 0;
  double overdueTaskPercentage = 0;
  double inProgressTaskPercentage = 0;
  double doneTaskPercentage = 0;
  @override
  void initState() {
    super.initState();
    listAllTasks = widget.listAllTasks;
    totalTasks = listAllTasks.length;
    countTask(listAllTasks);
    doneTaskPercentage = (doneTaskNumber / totalTasks) * 100;
    overdueTaskPercentage = (overdueTaskNumber / totalTasks) * 100;
    inProgressTaskPercentage = (inProgressTaskNumber / totalTasks) * 100;
  }

  countTask(List<TaskModel> listAllTasks) {
    for (var task in listAllTasks) {
      if (task.taskStatus == 'Complete') {
        doneTaskNumber++;
      } else {
        if (task.taskStatus == 'Overdue') {
          overdueTaskNumber++;
        } else {
          inProgressTaskNumber++;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          PieChart(PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 10,
            sections: [
              PieChartSectionData(
                  value: double.parse(doneTaskPercentage.toStringAsFixed(1)),
                  color: Colors.green,
                  showTitle: true,
                  radius: 35),
              PieChartSectionData(
                  value:
                      double.parse(inProgressTaskPercentage.toStringAsFixed(1)),
                  color: Colors.blueAccent,
                  showTitle: true,
                  radius: 30),
              PieChartSectionData(
                  value: double.parse(overdueTaskPercentage.toStringAsFixed(1)),
                  color: Colors.redAccent,
                  showTitle: true,
                  radius: 40),
            ],
          )),
        ],
      ),
    );
  }
}
