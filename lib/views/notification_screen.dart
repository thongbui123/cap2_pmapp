import 'package:capstone2_project_management_app/models/notification_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/notification_services.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/views/profile_screen.dart';
import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class NotificationScreen extends StatefulWidget {
  final Map notificationMap;
  final Map userMap;
  final UserModel userModel;
  const NotificationScreen(
      {Key? key,
      required this.userModel,
      required this.notificationMap,
      required this.userMap})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

List<String> allNotice = [
  'You are now assigned as the leader of project A',
  'Task A has been assigned to you'
];

class _NotificationScreenState extends State<NotificationScreen> {
  late UserModel userModel;
  late Map notificationMap;
  Map<String, dynamic> userMap = {};
  Map<String, dynamic> castMap = {};
  NotificationService notificationService = NotificationService();
  late List<NotificationModel> listNotifications;
  late List<NotificationModel> listNrNotifications;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    notificationMap = widget.notificationMap;
    widget.userMap.forEach((key, value) {
      userMap[key.toString()] = value;
    });
    notificationMap =
        NotificationService().getSortedMap(notificationMap.cast());
    listNotifications = notificationService.getListAllNotifications(
        notificationMap, userModel.userId);
    listNrNotifications = notificationService.getListAllNotRead(
        notificationMap, userModel.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DbSideMenu(
              userModel: userModel,
              numNotRead: listNrNotifications.length,
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
                            'NOTIFICATION',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 20),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        child: Column(
                          children: ListTile.divideTiles(
                            context:
                                context, // Make sure to provide the BuildContext if this code is inside a widget build method
                            tiles: listNotifications.map((notification) {
                              return ColoredBox(
                                color: notification.readOrNot == 'No'
                                    ? const Color.fromARGB(255, 218, 220, 225)
                                    : Colors.white,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onTap: () {
                                    if (notification.notificationType ==
                                        'User') {
                                      NotificationService().updateReadOrNot(
                                          notification.notificationId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => profile_screen(
                                            userModel: userModel,
                                          ),
                                        ),
                                      );
                                    }
                                    if (notification.notificationType ==
                                        'Project') {
                                      NotificationService().updateReadOrNot(
                                          notification.notificationId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return StreamBuilder<List<Object>>(
                                                stream:
                                                    CombineLatestStream.list([
                                                  ProjectServices()
                                                      .reference
                                                      .child(notification
                                                          .notificationRelatedId)
                                                      .onValue,
                                                  ProjectServices()
                                                      .reference
                                                      .onValue,
                                                  PhaseServices()
                                                      .phaseRef
                                                      .onValue,
                                                  TaskService().taskRef.onValue,
                                                ]),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError ||
                                                      !snapshot.hasData) {
                                                    return loader();
                                                  }

                                                  var event_0 =
                                                      snapshot.data![0]
                                                          as DatabaseEvent;
                                                  var event_1 =
                                                      snapshot.data![1]
                                                          as DatabaseEvent;
                                                  var event_2 =
                                                      snapshot.data![2]
                                                          as DatabaseEvent;
                                                  var event_3 =
                                                      snapshot.data![3]
                                                          as DatabaseEvent;
                                                  var value_0 = event_0.snapshot
                                                      .value as dynamic;
                                                  var value_1 = event_1.snapshot
                                                      .value as dynamic;
                                                  var value_2 = event_2.snapshot
                                                      .value as dynamic;
                                                  var value_3 = event_3.snapshot
                                                      .value as dynamic;
                                                  ProjectModel projectModel =
                                                      ProjectModel.fromMap(
                                                          Map.from(value_0));
                                                  Map projectMap =
                                                      Map.from(value_1);
                                                  Map phraseMap =
                                                      Map.from(value_2);
                                                  Map taskMap =
                                                      Map.from(value_3);
                                                  return ProjectDetailScreen(
                                                      userModel: userModel,
                                                      projectModel:
                                                          projectModel,
                                                      userMap: userMap,
                                                      projectMap: projectMap,
                                                      phraseMap: phraseMap,
                                                      taskMap: taskMap);
                                                });
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  title: Text(notification.notificationContent,
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 13)),
                                  subtitle: Text(
                                    notification.notificationDate,
                                    style: const TextStyle(
                                        fontFamily: 'MontMed', fontSize: 12),
                                  ),
                                ),
                              );
                            }),
                          ).toList(),
                        ),
                      ),
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
}

class Dashboard_chart extends StatefulWidget {
  const Dashboard_chart({Key? key}) : super(key: key);

  @override
  State<Dashboard_chart> createState() => _Dashboard_chartState();
}

class _Dashboard_chartState extends State<Dashboard_chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("123",
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
                    title: '20',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 24),
                PieChartSectionData(
                    value: 5,
                    color: Colors.lightBlueAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.6,
                    title: '50',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 20),
                PieChartSectionData(
                    value: 3,
                    color: Colors.redAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.5,
                    title: '30',
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
  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  int selectedYear = DateTime.now().year;

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
