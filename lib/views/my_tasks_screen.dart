import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

List<String> allTasks = [
  'Task A01',
  'Task B02',
  'Task B01',
];

List<String> allProjects = [
  'Project A01',
  'Project B02',
  'Project B01',
];

class _MyTaskScreenState extends State<MyTaskScreen> {
  late ProjectModel projectModel;
  late Map<String, dynamic> userMap;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blueAccent,
          tooltip: 'Add Project', // Optional tooltip text shown on long-press
          child: Icon(
            Icons.playlist_add,
            color: Colors.white,
          ), // Updated icon for the FAB
        ),
      ),
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
                            Text(
                              'TASKS',
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
                              child:
                                  Icon(Icons.folder, color: Colors.blueAccent)),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return FutureBuilder(
                                  future: UserServices().getUserDataMap(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      userMap = snapshot.data ?? {};
                                      return Expanded(
                                        child: projectDetailScreen(
                                          projectModel: projectModel,
                                          userMap: userMap,
                                        ),
                                      );
                                    }
                                  });
                            }));
                          },
                          title: Text('${projectModel.projectName}',
                              style: TextStyle(
                                  fontFamily: 'MontMed', fontSize: 13)),
                          subtitle: Text(
                            '2 Tasks',
                            style: const TextStyle(
                                fontFamily: 'MontMed', fontSize: 12),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              _showProjectSelectionDialog();
                            },
                            child: Text('Switch',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12)),
                          ),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
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
                                  Icon(Icons.flag_outlined, size: 15),
                                  SizedBox(width: 10),
                                  Text('Priority',
                                      style: TextStyle(
                                          fontFamily: 'MontMed', fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        ExpansionTileTasks(),
                      ],
                    ))))
          ],
        ),
      ),
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
              children: allProjects.map((project) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading:
                          CircleAvatar(child: Icon(Icons.keyboard_arrow_down)),
                      title: Text(project,
                          style: TextStyle(fontFamily: 'MontMed')),
                      subtitle: Text(
                        "Members",
                        style: const TextStyle(fontFamily: 'MontMed'),
                      ),
                      onTap: () {},
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
                  leading: Icon(Icons.people_alt_outlined),
                  title: Text('Number of members involved',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    numberVisibility = true;
                    nameVisibility = false;
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
                    numberVisibility = false;
                    nameVisibility = true;
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
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text('Priority:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Container(width: 15, height: 15, color: Colors.red),
                  title: Text('HIGH',
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
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Container(
                      width: 15, height: 15, color: Colors.orangeAccent),
                  title: Text('MEDIUM',
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
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Container(width: 15, height: 15, color: Colors.blue),
                  title: Text('LOW',
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
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }
}

class ExpansionTileTasks extends StatefulWidget {
  const ExpansionTileTasks({super.key});

  @override
  State<ExpansionTileTasks> createState() => _ExpansionTileTasksState();
}

class _ExpansionTileTasksState extends State<ExpansionTileTasks> {
  bool _customTileExpanded0 = false;
  bool _customTileExpanded1 = false;
  bool _customTileExpanded2 = false;
  bool _customTileExpanded3 = false;

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 10),
              Text('Selected Day: ' + today.toString().split(' ')[0],
                  style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded3
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            Divider(),
            Container(
              child: TableCalendar(
                  rowHeight: 50,
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontFamily: 'MontMed')),
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontFamily: 'MontMed')),
                  calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(fontFamily: 'MontMed')),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  onDaySelected: _onDaySelected,
                  focusedDay: today,
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
        Divider(),
        Divider(),
        ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              Icon(Icons.list_alt),
              SizedBox(width: 10),
              Text('All Tasks (3)',
                  style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded0
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            Divider(),
            Container(
              child: Column(
                children: allTasks.map((project) {
                  return ListTile(
                    leading: const CircleAvatar(
                        child: Icon(Icons.layers, color: Colors.blue)),
                    title: Text('Task Name: ${project}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_open_sharp,
                              size: 13,
                            ),
                            SizedBox(width: 5),
                            Text('Project:...',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Priority: ',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                        Text('HIGH',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 13,
                                color: Colors.red))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded0 = expanded;
            });
          },
        ),
        Divider(),
        ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          initiallyExpanded: true,
          title: Row(
            children: [
              Text('Recent Tasks (3)',
                  style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded1
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            Divider(),
            Container(
              child: Column(
                children: allTasks.map((project) {
                  return ListTile(
                    leading: const CircleAvatar(
                        child: Icon(Icons.layers, color: Colors.blue)),
                    title: Text('Task Name: ${project}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_open_sharp,
                              size: 13,
                            ),
                            SizedBox(width: 5),
                            Text('Project:...',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Priority: ',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                        Text('HIGH',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 13,
                                color: Colors.red))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded1 = expanded;
            });
          },
        ),
        Divider(),
        ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Row(
            children: [
              Text('Overdue Tasks (4)',
                  style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
            ],
          ),
          trailing: Icon(
            _customTileExpanded2
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: [
            Divider(),
            Container(
              child: Column(
                children: allTasks.map((project) {
                  return ListTile(
                    leading: const CircleAvatar(
                        child: Icon(Icons.layers, color: Colors.blue)),
                    title: Text('Task Name: ${project}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_open_sharp,
                              size: 13,
                            ),
                            SizedBox(width: 5),
                            Text('Project:...',
                                style: TextStyle(
                                    fontFamily: 'MontMed', fontSize: 12))
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Priority: ',
                            style:
                                TextStyle(fontFamily: 'MontMed', fontSize: 12)),
                        Text('HIGH',
                            style: TextStyle(
                                fontFamily: 'MontMed',
                                fontSize: 13,
                                color: Colors.red))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded2 = expanded;
            });
          },
        ),
        Divider(),
      ],
    );
  }
}
