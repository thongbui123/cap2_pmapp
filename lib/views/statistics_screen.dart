import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'subs/sub_widgets.dart';

class statistic_screen extends StatefulWidget {
  final UserModel userModel;
  const statistic_screen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<statistic_screen> createState() => _statistic_screenState();
}

int currentYearLoad = DateTime.now().year;
List<String> list = <String>['2023 - 2024', '2024 - Present'];

class _statistic_screenState extends State<statistic_screen> {
  late UserModel userModel;
  late Map projectMap;
  late Map taskMap;
  late Map<String, dynamic> userMap;

  late int numOfTotalProject;
  late int numOfOverdueProject;
  late int numOfOnGoingProject;
  late int numOfDoneProject;
  late int numOfTotalTask;
  late int numOfOverdueTask;
  late int numOfOnGoingTask;
  late int numOfDoneTask;
  late double averageTaskTime;
  late int leaderNumber;
  late int memberNumber;
  List<TaskModel> listAllTaskModelInYear = [];
  ProjectServices projectServices = ProjectServices();
  TaskService taskService = TaskService();
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  _loadData() {
    numOfTotalProject =
        projectServices.getAllProjectInYear(projectMap, currentYearLoad);
    numOfDoneProject =
        projectServices.getAllDoneProjectInYear(projectMap, currentYearLoad);
    numOfOnGoingProject =
        projectServices.getAllOnGoingTaskInYear(projectMap, currentYearLoad);
    numOfOverdueProject =
        projectServices.getAllOverdueTaskInYear(projectMap, currentYearLoad);
    numOfTotalTask =
        taskService.getAllTaskNumberInYear(taskMap, currentYearLoad);
    numOfDoneTask =
        taskService.getAllCompleteTaskNumberInYear(taskMap, currentYearLoad);
    numOfOnGoingTask =
        taskService.getAllInCompleteTaskNumberInYear(taskMap, currentYearLoad);
    numOfOverdueTask =
        taskService.getAllOverdueTaskNumberInYear(taskMap, currentYearLoad);
    listAllTaskModelInYear =
        taskService.getAllTaskModelInYear(taskMap, currentYearLoad);
    averageTaskTime =
        taskService.calculateTotalAverageTime(listAllTaskModelInYear);
    memberNumber = UserServices().getAllUserStringList(userMap).length;
    leaderNumber = userMap.length - memberNumber;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          NotificationService().databaseReference.onValue,
          ProjectServices().reference.onValue,
          TaskService().taskRef.onValue,
          UserServices().databaseReference.onValue
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var notifiEvent = snapshot.data![0] as DatabaseEvent;
          var notifiValue = notifiEvent.snapshot.value as dynamic;
          Map notifiMap = Map<String, dynamic>.from(notifiValue);
          int numNr = NotificationService()
              .getListAllNotRead(notifiMap, userModel.userId)
              .length;
          var projectEvent = snapshot.data![1] as DatabaseEvent;
          var projectValue = projectEvent.snapshot.value as dynamic;
          projectMap = Map.from(projectValue);
          var taskEvent = snapshot.data![2] as DatabaseEvent;
          var taskValue = taskEvent.snapshot.value as dynamic;
          taskMap = Map.from(taskValue);
          var userEvent = snapshot.data![3] as DatabaseEvent;
          var userValue = userEvent.snapshot.value as dynamic;
          userMap = Map<String, dynamic>.from(userValue);
          //NotificationService().databaseReference.onValue
          _loadData();
          return Scaffold(
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DbSideMenu(
                    userModel: userModel,
                    numNotRead: numNr,
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SingleChildScrollView(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'STATISTIC',
                              style: TextStyle(
                                  fontFamily: 'MontMed', fontSize: 20),
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.indigo[50],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.bar_chart,
                                          color: Colors.orangeAccent),
                                      SizedBox(width: 5),
                                      Text('Project Statistic:',
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 14)),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          YearDropdown(
                                            currentYearLoad: currentYearLoad,
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 200,
                                          child: Dashboard_chart(
                                              totalProject: numOfTotalProject,
                                              totalDone: numOfDoneProject,
                                              totalOverdue: numOfOverdueProject,
                                              totalOnGoing:
                                                  numOfOnGoingProject),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 15,
                                          width: 15,
                                          color: Colors.lightBlueAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Text('In Progress',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'MontMed')),
                                        SizedBox(width: 20),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text('Done',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'MontMed')),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          color: Colors.redAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text('Overdue',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'MontMed')),
                                        ),
                                      ]),
                                  SizedBox(height: 20),
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
                                          Icon(Icons.playlist_play,
                                              size: 30, color: Colors.blue),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Assigned:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text('$numOfTotalTask Task(s)',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      color: Colors.indigo[50],
                                      child: Row(
                                        children: [
                                          Icon(Icons.playlist_add_check,
                                              size: 30, color: Colors.green),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Completed:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text('$numOfDoneTask Tasks',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
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
                                          Icon(Icons.timer,
                                              size: 25,
                                              color: Colors.purpleAccent),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Time/Task: ',
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text(
                                                    '${double.parse(averageTaskTime.toStringAsFixed(1))} days',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      color: Colors.indigo[50],
                                      child: Row(
                                        children: [
                                          Icon(Icons.playlist_remove,
                                              size: 30,
                                              color: Colors.redAccent),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Overdue: ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text('$numOfOverdueTask Tasks',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
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
                                          Icon(Icons.star,
                                              size: 25,
                                              color: Colors.deepOrange),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Leader Role:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text('$leaderNumber People',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      color: Colors.indigo[50],
                                      child: Row(
                                        children: [
                                          Icon(Icons.person,
                                              size: 30,
                                              color: Colors.redAccent),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Member Role:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed',
                                                        fontSize: 11)),
                                                Text('$memberNumber People',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'MontMed'))
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
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        });
  }
}

class Dashboard_chart extends StatefulWidget {
  final int totalProject;
  final int totalDone;
  final int totalOverdue;
  final int totalOnGoing;
  const Dashboard_chart(
      {Key? key,
      required this.totalProject,
      required this.totalDone,
      required this.totalOverdue,
      required this.totalOnGoing})
      : super(key: key);

  @override
  State<Dashboard_chart> createState() => _Dashboard_chartState();
}

class _Dashboard_chartState extends State<Dashboard_chart> {
  late int totalProject;
  late int totalDone;
  late int totalOverdue;
  late int totalOnGoing;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalProject = widget.totalProject;
    totalDone = widget.totalDone;
    totalOverdue = widget.totalOverdue;
    totalOnGoing = widget.totalOnGoing;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$totalProject",
                  style: TextStyle(
                      fontFamily: 'MontMed',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text(
                "PROJECTS",
                style: TextStyle(fontFamily: 'MontMed'),
              ),
              Text(
                "IN TOTAL",
                style: TextStyle(fontFamily: 'MontMed'),
              )
            ],
          )),
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              sections: [
                PieChartSectionData(
                    value: 2,
                    color: Colors.greenAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.5,
                    title: '$totalDone',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 24),
                PieChartSectionData(
                    value: 5,
                    color: Colors.lightBlueAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.6,
                    title: '$totalOnGoing',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 20),
                PieChartSectionData(
                    value: 3,
                    color: Colors.redAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.5,
                    title: '$totalOverdue',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YearDropdown extends StatefulWidget {
  final int currentYearLoad;

  const YearDropdown({super.key, required this.currentYearLoad});
  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  late int selectedYear;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedYear = widget.currentYearLoad;
  }

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;
    final List<int> years =
        List.generate(currentYear - 2022, (index) => currentYear - index);

    return DropdownButton<int>(
      value: selectedYear,
      onChanged: (int? newValue) {
        setState(() {
          selectedYear = newValue!;
          currentYearLoad = selectedYear;
        });
      },
      underline: Container(
        height: 0,
      ),
      items: years.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontFamily: 'MontMed', fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
