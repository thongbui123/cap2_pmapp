import 'dart:collection';

import 'package:capstone2_project_management_app/models/phase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/task_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/comment_service.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/project_screen/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:capstone2_project_management_app/views/task_screen/task_create_screen.dart';
import 'package:capstone2_project_management_app/views/task_screen/task_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

class ListOfTaskScreen extends StatefulWidget {
  final ProjectModel? projectModel;
  final UserModel userModel;
  final Map projectMap;
  final Map taskMap;
  const ListOfTaskScreen({
    super.key,
    required this.userModel,
    required this.projectMap,
    required this.taskMap,
    this.projectModel,
  });

  @override
  State<ListOfTaskScreen> createState() => _ListOfTaskScreenState();
}

late PhaseModel phaseModel;

class _ListOfTaskScreenState extends State<ListOfTaskScreen> {
  late UserModel currentUserModel;
  late ProjectModel? projectModel;
  //late PhaseModel phaseModel;
  late Map<String, dynamic> userMap;
  late Map<String, dynamic> commentMap;
  late Map<dynamic, dynamic> projectMap;
  List<ProjectModel> listJoinedProjects = [];
  List<TaskModel> listJoinedTasks = [];
  List<TaskModel> listCompleteTasks = [];
  List<TaskModel> listOverdueTasks = [];
  late Map phaseMap = {};
  late Map taskMap;
  late int taskLength;
  late Map<DateTime, List<TaskModel>> calendarTaskEvents;
  UserServices userServices = UserServices();
  TaskService taskService = TaskService();
  PhaseServices phraseServices = PhaseServices();
  ProjectServices projectServices = ProjectServices();
  @override
  void initState() {
    currentUserModel = widget.userModel;
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    listJoinedProjects = currentUserModel.userRole != 'Admin'
        ? projectServices.getJoinedProjectList(projectMap, currentUserModel)
        : projectServices.getAllProjectList(projectMap);
    projectModel = (widget.projectModel == null)
        ? listJoinedProjects.first
        : widget.projectModel;
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _fetchCalendarEvents() {
    List<TaskModel> listTasks = listJoinedTasks;
    calendarTaskEvents =
        LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    for (var task in listTasks) {
      //DateTime convertDate_1 = DateTime.parse(task.taskStartDate.toString());
      DateTime convertEndDate = DateTime.parse(task.taskEndDate.toString());
      // DateTime date_1 = DateTime.utc(
      //     convertDate_1.year, convertDate_1.month, convertDate_1.day);
      DateTime endDate = DateTime.utc(
          convertEndDate.year, convertEndDate.month, convertEndDate.day);
      // if (calendarTaskEvents[date_1] == null) {
      //   calendarTaskEvents[date_1] = [];
      // }
      if (calendarTaskEvents[endDate] == null) {
        calendarTaskEvents[endDate] = [];
      }
      //calendarTaskEvents[date_1]!.add(task);
      calendarTaskEvents[endDate]!.add(task);
    }
  }

  sortDecending<T>(List<TaskModel> list,
      Comparable<T> Function(TaskModel obj) getAttribute) {
    setState(() {
      list.sort((a, b) => getAttribute(b).compareTo(getAttribute(a) as T));
    });
  }

  sortAscending<T>(List<TaskModel> list,
      Comparable<T> Function(TaskModel obj) getAttribute) {
    setState(() {
      list.sort((a, b) => getAttribute(a).compareTo(getAttribute(b) as T));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Object>>(
        stream: CombineLatestStream.list([
          UserServices().databaseReference.onValue,
          TaskService().reference.onValue,
          ProjectServices().reference.onValue,
          PhaseServices().reference.onValue,
          NotificationService().databaseReference.onValue,
          PhaseServices().reference.child(projectModel!.currentPhaseId).onValue,
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return loader();
          }
          var eventUser = snapshot.data![0] as DatabaseEvent;
          var valueUser = eventUser.snapshot.value as dynamic;
          Map mapUser = Map.from(valueUser);
          var eventTask = snapshot.data![1] as DatabaseEvent;
          var valueTask = eventTask.snapshot.value as dynamic;
          taskMap = Map.from(valueTask);
          var eventProject = snapshot.data![2] as DatabaseEvent;
          var valueProject = eventProject.snapshot.value as dynamic;
          projectMap = Map.from(valueProject);
          var eventPhase = snapshot.data![3] as DatabaseEvent;
          var valuePhase = eventPhase.snapshot.value as dynamic;
          phaseMap = Map.from(valuePhase);
          phaseMap = PhaseServices().sortedPhaseMap(phaseMap);
          var eventNotifi = snapshot.data![4] as DatabaseEvent;
          var valueNotifi = eventNotifi.snapshot.value as dynamic;
          Map notifiMap = Map<String, dynamic>.from(valueNotifi);
          //NotificationService().databaseReference.onValue
          int numNr =
              NotificationService().getListAllNotRead(notifiMap, uid).length;
          var eventPhaseModel = snapshot.data![5] as DatabaseEvent;
          var valuePhaseModel = eventPhaseModel.snapshot.value as dynamic;
          phaseModel = PhaseModel.fromMap(Map.from(valuePhaseModel));
          listJoinedProjects = currentUserModel.userRole != 'Admin'
              ? projectServices.getJoinedProjectList(
                  projectMap, currentUserModel)
              : projectServices.getAllProjectList(projectMap);
          projectModel = (widget.projectModel == null)
              ? listJoinedProjects.first
              : widget.projectModel;
          listCompleteTasks = taskService.getCompleteTaskListByProject(
              taskMap, currentUserModel, projectModel!);
          listJoinedTasks = taskService.getJoinedTaskListFromProject(
              taskMap, currentUserModel, projectModel!);
          listOverdueTasks = taskService.getOverdouTaskListFromProject(
              taskMap, currentUserModel, projectModel!);
          taskLength = taskService.getJoinedTaskNumberFromProject(
              taskMap, currentUserModel, projectModel!);
          _fetchCalendarEvents();
          return Scaffold(
            floatingActionButton: Visibility(
              visible: currentUserModel.userRole != 'User',
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => _getTaskCreateScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.blueAccent,
                tooltip:
                    'Add Project', // Optional tooltip text shown on long-press
                child: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ), // Updated icon for the FAB
              ),
            ),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DbSideMenu(userModel: currentUserModel, numNotRead: numNr),
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
                                    'TASKS',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 20),
                                  ),
                                ],
                              ),
                              const Divider(),
                              ListTile(
                                leading: const CircleAvatar(
                                    child: Icon(Icons.folder,
                                        color: Colors.blueAccent)),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return _getProjectDetailScreen();
                                      },
                                    ),
                                  );
                                },
                                title: Text(projectModel!.projectName,
                                    style: const TextStyle(
                                        fontFamily: 'MontMed', fontSize: 13)),
                                subtitle: Text(
                                  '$taskLength Task(s)',
                                  style: const TextStyle(
                                      fontFamily: 'MontMed', fontSize: 12),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    _showProjectSelectionDialog();
                                  },
                                  child: const Text('Switch',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 12)),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              const SizedBox(height: 5),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        _showFilterDrawer(context);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.filter_list, size: 15),
                                          SizedBox(width: 10),
                                          Text(
                                            'Sort',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'MontMed',
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                      width: 1, height: 25, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  TextButton(
                                    onPressed: () {
                                      _showOrderDrawer(context);
                                    },
                                    child: const Row(
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
                                  const SizedBox(width: 5),
                                  Container(
                                      width: 1, height: 25, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        _showStateDrawer(context);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.flag_outlined, size: 15),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text('Priority',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'MontMed',
                                                    fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              ExpansionTileTasks(
                                projectMap: projectMap,
                                taskMap: taskMap,
                                currentUserModel: currentUserModel,
                                projectModel: projectModel!,
                                taskCalendarEvents: calendarTaskEvents,
                              ),
                            ],
                          ))))
                ],
              ),
            ),
          );
        });
  }

  FutureBuilder<Map<String, dynamic>> _getTaskCreateScreen() {
    return FutureBuilder(
      future: userServices.getUserDataMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          userMap = snapshot.data ?? {};
          return Expanded(
            child: TaskCreateScreen(
              projectMap: projectMap,
              currentUserModel: currentUserModel,
              userMap: userMap,
              projectModel: projectModel!,
              phraseMap: phaseMap,
              taskMap: taskMap,
              phaseModel: phaseModel,
            ),
          );
        }
      },
    );
  }

  FutureBuilder<Map<String, dynamic>> _getProjectDetailScreen() {
    return FutureBuilder(
      future: userServices.getUserDataMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          userMap = snapshot.data ?? {};
          return Expanded(
            child: ProjectDetailScreen(
              projectModel: projectModel!,
              userMap: userMap,
              userModel: currentUserModel,
              projectMap: projectMap,
              phraseMap: phaseMap,
              taskMap: taskMap,
            ),
          );
        }
      },
    );
  }

  Future<void> _showProjectSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'PROJECTS',
            style: TextStyle(fontFamily: 'Anurati'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: listJoinedProjects.map((project) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.keyboard_arrow_down)),
                      title: Text(project.projectName,
                          style: const TextStyle(fontFamily: 'MontMed')),
                      subtitle: Text(
                        "Task numbers: ${taskService.getJoinedTaskNumberFromProject(taskMap, currentUserModel, project)}",
                        style: const TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {
                        setState(() {
                          projectModel = project;
                          listJoinedTasks =
                              taskService.getJoinedTaskListFromProject(
                                  taskMap, currentUserModel, projectModel!);
                          listOverdueTasks =
                              taskService.getOverdouTaskListFromProject(
                                  taskMap, currentUserModel, projectModel!);
                          taskLength =
                              taskService.getJoinedTaskNumberFromProject(
                                  taskMap, currentUserModel, projectModel!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListOfTaskScreen(
                                  userModel: currentUserModel,
                                  projectMap: projectMap,
                                  projectModel: projectModel,
                                  taskMap: taskMap),
                            ),
                          );
                        });
                        //Navigator.of(context).pop();
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
              const SizedBox(height: 20),
              const Row(
                children: [
                  SizedBox(width: 25),
                  Text('Sort by:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.people_alt_outlined),
                  title: const Text('Number of members involved',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    numberVisibility = true;
                    nameVisibility = false;

                    sortAscending(
                        listJoinedTasks, (obj) => obj.taskMembers.length);
                    sortAscending(
                        listCompleteTasks, (obj) => obj.taskMembers.length);
                    sortAscending(
                        listOverdueTasks, (obj) => obj.taskMembers.length);

                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: numberVisibility,
                    child: const Icon(Icons.check),
                  ))),
              ListTile(
                  leading: const Icon(Icons.folder_open_sharp),
                  title: const Text('Name',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    numberVisibility = false;
                    nameVisibility = true;

                    sortAscending(listJoinedTasks, (obj) => obj.taskName);
                    sortAscending(listCompleteTasks, (obj) => obj.taskName);
                    sortAscending(listOverdueTasks, (obj) => obj.taskName);

                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: nameVisibility,
                    child: const Icon(Icons.check),
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
              const SizedBox(height: 20),
              const Row(
                children: [
                  SizedBox(width: 25),
                  Text('Order:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Ascending',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    ascendingVisibility = true;
                    descendingVisibility = false;
                    setState(() {
                      sortAscending(listJoinedTasks, (obj) => obj.taskName);
                      sortAscending(listCompleteTasks, (obj) => obj.taskName);
                      sortAscending(listOverdueTasks, (obj) => obj.taskName);
                    });
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: ascendingVisibility,
                    child: const Icon(Icons.check),
                  ))),
              ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Descending',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    ascendingVisibility = false;
                    descendingVisibility = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: descendingVisibility,
                    child: const Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }

  bool highVisibility = true;
  bool mediumVisibility = false;
  bool lowVisibility = false;
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
              const Row(
                children: [
                  SizedBox(width: 25),
                  Text('Priority:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              ListTile(
                  leading: Container(width: 15, height: 15, color: Colors.red),
                  title: const Text('HIGH',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    highVisibility = true;
                    mediumVisibility = false;
                    lowVisibility = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: highVisibility,
                    child: const Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Container(
                      width: 15, height: 15, color: Colors.orangeAccent),
                  title: const Text('MEDIUM',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    highVisibility = false;
                    mediumVisibility = true;
                    lowVisibility = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: mediumVisibility,
                    child: const Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Container(width: 15, height: 15, color: Colors.blue),
                  title: const Text('LOW',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    highVisibility = false;
                    mediumVisibility = true;
                    lowVisibility = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: lowVisibility,
                    child: const Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }
}

class ExpansionTileTasks extends StatefulWidget {
  final Map taskMap;
  final Map projectMap;
  final UserModel currentUserModel;
  final ProjectModel projectModel;
  final Map<DateTime, List<TaskModel>> taskCalendarEvents;
  const ExpansionTileTasks(
      {super.key,
      required this.taskMap,
      required this.currentUserModel,
      required this.projectMap,
      required this.projectModel,
      required this.taskCalendarEvents});

  @override
  State<ExpansionTileTasks> createState() => _ExpansionTileTasksState();
}

class _ExpansionTileTasksState extends State<ExpansionTileTasks> {
  bool _customTileExpanded0 = false;
  bool _customTileExpanded1 = false;
  bool _customTileExpanded2 = false;
  bool _customTileExpanded3 = false;
  TaskService taskService = TaskService();
  ProjectServices projectServices = ProjectServices();
  late List<TaskModel> listJoinedTasks;
  late List<TaskModel> listDoneTasks;
  late List<TaskModel> listOverdueTasks;
  late UserModel currentUserModel;
  late Map taskMap;
  late Map projectMap;
  late ProjectModel projectModel;
  late Map<DateTime, List<TaskModel>> groupEvents;
  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Color markerColor;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    projectMap = widget.projectMap;
    taskMap = widget.taskMap;
    currentUserModel = widget.currentUserModel;
    projectModel = widget.projectModel;
    listDoneTasks = taskService.getCompleteTaskListByProject(
        taskMap, currentUserModel, projectModel);
    listJoinedTasks = taskService.getJoinedTaskListFromProject(
        taskMap, currentUserModel, projectModel);
    listOverdueTasks = taskService.getOverdouTaskListFromProject(
        taskMap, currentUserModel, projectModel);
    groupEvents = widget.taskCalendarEvents;
    super.initState();
  }

  List<TaskModel> _getEventFromDay(DateTime date) {
    return groupEvents[date] ?? [];
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      if (groupEvents[today] != null) {
        showDateDialog(today, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              const Icon(Icons.calendar_month),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Selected Day: ${_selectedDay.toString().split(' ')[0]}',
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
              ),
            ],
          ),
          trailing: Icon(
            _customTileExpanded3
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            const Divider(),
            Container(
              child: TableCalendar(
                  eventLoader: _getEventFromDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (BuildContext context, date, events) {
                      if (events.isEmpty) return SizedBox();
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                // height: 7,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                  // color: Colors.primaries[Random()
                                  //     .nextInt(Colors.primaries.length)],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  rowHeight: 50,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontFamily: 'MontMed')),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontFamily: 'MontMed')),
                  //onDaySelected: _onDaySelected,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        if (groupEvents[selectedDay] != null) {
                          //showDateDialog(selectedDay, context);
                          for (var event in groupEvents[selectedDay]!) {
                            DateTime dateTimeParse =
                                DateTime.parse(event.taskEndDate);
                            if (dateTimeParse.isBefore(DateTime.now())) {}
                          }
                        }
                      });
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  focusedDay: today,
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: const BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(5.0),
                    ),
                    weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black.withOpacity(0.05)),
                    markerDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  availableGestures: AvailableGestures.all,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2025, 1, 1)),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded3 = expanded;
            });
          },
        ),
        const Divider(),
        ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              const Icon(Icons.list_alt),
              const SizedBox(width: 10),
              Text('Complete Tasks (${listDoneTasks.length})',
                  style: const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded0
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            const Divider(),
            Container(
              child: _showTaskList(listDoneTasks),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded0 = expanded;
            });
          },
        ),
        const Divider(),
        ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              Text('Recent Tasks (${listJoinedTasks.length})',
                  style: const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded1
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            const Divider(),
            Container(
              child: _showTaskList(listJoinedTasks),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded1 = expanded;
            });
          },
        ),
        const Divider(),
        ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Row(
            children: [
              Text('Overdue Tasks (${listOverdueTasks.length})',
                  style: const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded2
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            const Divider(),
            Container(
              child: _showTaskList(listOverdueTasks),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded2 = expanded;
            });
          },
        ),
        const Divider(),
      ],
    );
  }

  Column _showTaskList(List<TaskModel> listOfJoinedTasks) {
    Map<String, dynamic> userMap;
    return Column(
      children: listOfJoinedTasks.map((task) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Set the radius here
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: Future.wait([
                        UserServices().getUserDataMap(),
                        CommentService().getCommentMap(),
                        PhaseServices().getPhraseMap()
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          userMap = snapshot.data![0];
                          commentMap = snapshot.data![1];

                          return TaskDetailScreen(
                            taskModel: task,
                            userMap: userMap,
                            taskMap: taskMap,
                            commentMap: commentMap,
                            userModel: currentUserModel,
                            phaseModel: phaseModel,
                          );
                        }
                      },
                    );
                  },
                ),
              );
            },
            tileColor: Colors.blue[50],
            leading: const CircleAvatar(
                child: Icon(Icons.layers, color: Colors.blue)),
            title: Text('Task Name: ${task.taskName}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.folder_open_sharp,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                          'Project: ${projectServices.getProjectNameFromId(projectMap, task.projectId)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'MontMed', fontSize: 12)),
                    )
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Priority: ',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                Text(
                  task.taskPriority.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'MontMed',
                    fontSize: 13,
                    color: task.taskPriority == 'High'
                        ? Colors.red
                        : (task.taskPriority == 'Medium'
                            ? Colors.yellow
                            : Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
