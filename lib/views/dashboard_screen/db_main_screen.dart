// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/stream_builder_service.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/views/project_screen/list_of_project_screen.dart';
import 'package:capstone2_project_management_app/views/search_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/task_screen/list_of_tasks_rework.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/phase_services.dart';
import '../subs/sub_widgets.dart';

class DashboardMainV1 extends StatefulWidget {
  final UserModel currentUserModel;

  const DashboardMainV1({
    Key? key,
    required this.currentUserModel,
  }) : super(key: key);

  @override
  State<DashboardMainV1> createState() => _DashboardMainV1State();
}

class _DashboardMainV1State extends State<DashboardMainV1> {
  ProjectServices projectServices = ProjectServices();
  TaskService taskService = TaskService();
  PhaseServices phaseServices = PhaseServices();
  StreamBuilderService streamBuilderService = StreamBuilderService();
  UserModel? currentUserModel;
  Map<dynamic, dynamic> projectMap = {};
  Map<dynamic, dynamic> taskMap = {};
  Map<dynamic, dynamic> phaseMap = {};
  List<ProjectModel> allProjects = [];
  List<ProjectModel> joinedProjects = [];
  List<TaskModel> allTasks = [];
  List<TaskModel> joinedTasks = [];
  List<TaskModel> filterTasks = [];
  List<PhaseModel> allPhases = [];
  int numOverdueTask = 0;
  int numOverdueProject = 0;
  int numOnGoingTask = 0;
  int numOnGoingProject = 0;
  int numDoneTask = 0;
  int numDoneProject = 0;
  TextEditingController editingController = TextEditingController();
  @override
  initState() {
    super.initState();
    currentUserModel = widget.currentUserModel;
  }

  void getListData() {
    if (currentUserModel!.userRole == 'Admin') {
      allProjects = projectServices.getAllProjectList(projectMap);
      for (var element in allProjects) {
        if (element.projectStatus == 'Done') {
          numDoneProject++;
        } else {
          if (element.projectStatus == 'Overdue') {
            numOverdueProject++;
          }
        }
      }
      allTasks = taskService.getAllTaskModelList(taskMap);
      for (var task in allTasks) {
        if (task.taskStatus == 'Complete') {
          numDoneTask++;
        } else {
          if (task.taskStatus == 'Overdue') {
            numOverdueTask++;
          } else {
            numOnGoingTask++;
          }
        }
      }
      allPhases = phaseServices.getAllPhaseList(phaseMap);
      filterTasks = taskService.getTasksFilteredByCurrentPhase(
          allProjects, allPhases, allTasks);
    } else {
      joinedProjects =
          projectServices.getJoinedProjectList(projectMap, currentUserModel!);
      for (var element in joinedProjects) {
        if (element.projectStatus == 'Done') {
          numDoneProject++;
        } else {
          if (element.projectStatus == 'Overdue') {
            numOverdueProject++;
          } else {
            numOnGoingProject++;
          }
        }
      }
      joinedTasks =
          taskService.getJoinedTaskList(taskMap, currentUserModel!.userId);
      allPhases = phaseServices.getAllPhaseList(phaseMap);
      filterTasks = taskService.getTasksFilteredByCurrentPhase(
          joinedProjects, allPhases, joinedTasks);
      for (var task in filterTasks) {
        if (task.taskStatus == 'Complete') {
          numDoneTask++;
        } else {
          if (task.taskStatus == 'Overdue') {
            numOverdueTask++;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          projectServices.reference.onValue,
          taskService.reference.onValue,
          phaseServices.reference.onValue,
        ]),
        builder: (context, snapshot) {
          if (streamBuilderService.getCondition(snapshot)) return loader();
          projectMap = streamBuilderService.getMapFromSnapshotList(snapshot, 0);
          taskMap = streamBuilderService.getMapFromSnapshotList(snapshot, 1);
          phaseMap = streamBuilderService.getMapFromSnapshotList(snapshot, 2);
          getListData();
          return SafeArea(
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
                        Expanded(
                          child: TextField(
                            controller: editingController,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontMed',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
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
                                    builder: (context) => SearchScreen(
                                      userModel: currentUserModel!,
                                      output: editingController.text.trim(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search),
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
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ListOfTaskRework(
                                                userModel: currentUserModel!,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.layers,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: const Text(
                                        'TASKS',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${currentUserModel!.userRole != 'Admin' ? filterTasks.length : allTasks.length} on going',
                                      style: const TextStyle(
                                          fontSize: 12, fontFamily: 'MontMed'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[50],
                          borderRadius: BorderRadius.circular(
                              5.0), // Set the border radius
                        ),
                        //height: 125,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 5),
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
                                    icon: const Icon(
                                      Icons.folder,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: const Text(
                                      'PROJECTS',
                                      style: TextStyle(
                                          fontFamily: 'MontMed',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${currentUserModel!.userRole != 'Admin' ? joinedProjects.length : allProjects.length} on going',
                                    style: const TextStyle(
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
                          padding: const EdgeInsets.all(15),
                          color: Colors.indigo[50],
                          child: Row(
                            children: [
                              const Icon(Icons.playlist_remove_rounded,
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
                                    Text('$numOverdueTask Task(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: 'MontMed'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
                                    Text('$numOverdueProject Project(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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
                const SizedBox(height: 10),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          color: Colors.indigo[50],
                          child: Row(
                            children: [
                              const Icon(Icons.layers,
                                  size: 30, color: Colors.blueAccent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Finalized:',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12)),
                                    Text('$numDoneTask Task(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: 'MontMed'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          color: Colors.deepOrange[50],
                          child: Row(
                            children: [
                              const Icon(Icons.folder_special,
                                  size: 30, color: Colors.green),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Finalized:',
                                        style: TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12)),
                                    Text('$numDoneProject Project(s)',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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

                // CAI NAY GAY RA OVERFLOW
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the border radius
                          ),
                          height: 200,
                          child: Visibility(
                            visible: filterTasks.isNotEmpty,
                            child: DashboardChart(
                              listAllTasks: filterTasks,
                            ),
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
                          children: (currentUserModel!.userRole == 'Admin'
                                  ? allProjects
                                  : joinedProjects)
                              .map((project) {
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
        });
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

class DashboardChart extends StatefulWidget {
  List<TaskModel> listAllTasks;
  DashboardChart({
    Key? key,
    required this.listAllTasks,
  }) : super(key: key);

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
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
