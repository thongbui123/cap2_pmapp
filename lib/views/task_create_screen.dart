import 'package:capstone2_project_management_app/models/phrase_model.dart';
import 'package:capstone2_project_management_app/models/project_model.dart';
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/phrase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/services/task_services.dart';
import 'package:capstone2_project_management_app/services/user_services.dart';
import 'package:capstone2_project_management_app/views/list_of_tasks_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/sub_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TaskCreateScreen extends StatefulWidget {
  final Map projectMap;
  final Map phraseMap;
  final Map taskMap;
  final UserModel currentUserModel;
  final Map<String, dynamic> userMap;
  final ProjectModel projectModel;
  const TaskCreateScreen(
      {super.key,
      required this.projectMap,
      required this.currentUserModel,
      required this.userMap,
      required this.projectModel,
      required this.phraseMap,
      required this.taskMap});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

List<String> list = <String>['HIGH', 'MEDIUM', 'LOW'];
// List<String> allTasks = [
//   'Task A01',
//   'Task B02',
//   'Task B01',
// ];

// List<String> allProjects = [
//   'Project A01',
//   'Project B02',
//   'Project B01',
// ];

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  late Map projectMap;
  late Map phraseMap;
  late Map taskMap;
  late UserModel currentUserModel;
  late PhraseModel currentPhraseModel;
  late ProjectModel projectModel;
  late Map<String, dynamic> userMap;
  var taskNameController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var endDateController = TextEditingController();
  String _selectedValue = 'Low';
  late List<String> allMembers;
  UserServices userServices = UserServices();
  ProjectServices projectServices = ProjectServices();
  List<String> currentList = [];
  String taskStartDate = DateTime.now().toString().split(" ")[0];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectMap = widget.projectMap;
    phraseMap = widget.phraseMap;
    taskMap = widget.taskMap;
    currentUserModel = widget.currentUserModel;
    userMap = widget.userMap;
    projectModel = widget.projectModel;
    allMembers = projectModel!.projectMembers;
    _getPhraseModel();
  }

  _getPhraseModel() {
    String currentPhraseName = projectModel.projectStatus;
    for (var phrase in phraseMap.values) {
      PhraseModel phraseModel =
          PhraseModel.fromMap(Map<String, dynamic>.from(phrase));
      if (phraseModel.phraseName == currentPhraseName) {
        currentPhraseModel = phraseModel;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            const Text(
              'NEW TASK',
              style: TextStyle(
                fontFamily: 'Anurati',
                fontSize: 30,
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: taskNameController,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'Name of Task',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontMed',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    prefixIcon: Icon(
                      Icons.layers,
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: Container(
              child: TextField(
                controller: taskDescriptionController,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontMed',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    prefixIcon: Icon(
                      Icons.bubble_chart,
                    )),
              ),
            )),
          ],
        ),
        const SizedBox(height: 5),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: avatar(userMap, currentUserModel.userId),
                title: const Text('Assigned by:',
                    style: TextStyle(
                        fontFamily: 'MontMed',
                        fontSize: 12,
                        color: Colors.black54)),
                subtitle: Text(
                    '${currentUserModel.userFirstName} ${currentUserModel.userLastName}',
                    style:
                        const TextStyle(fontFamily: 'MontMed', fontSize: 14)),
              ),
            ),
            Expanded(
                child: Container(
              child: TextField(
                controller: endDateController,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'End Date',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontMed',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    prefixIcon: Icon(
                      Icons.calendar_month,
                    )),
                readOnly: true,
                onTap: () {
                  DateTime endDate = DateTime.parse(projectModel!.endDate);
                  DateTime now = DateTime.now();
                  _selectDate(endDateController, now, endDate);
                },
              ),
            )),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.folder, color: Colors.orangeAccent)),
                title: const Text('Project Name:',
                    style: TextStyle(
                        fontFamily: 'MontMed',
                        fontSize: 14,
                        color: Colors.black54)),
                subtitle: Text(projectModel!.projectName.toUpperCase(),
                    style:
                        const TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Number of tasks: ',
                        style: TextStyle(
                            fontFamily: 'MontMed',
                            fontSize: 14,
                            color: Colors.black54)),
                    Text('${currentPhraseModel.listTasks.length}',
                        style: const TextStyle(
                            fontFamily: 'MontMed', fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const Text('Priority:',
            style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
        Row(
          children: [
            Expanded(
                child: Container(
                    height: 50,
                    child: Row(children: [
                      Radio<String>(
                        value: 'Low',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text('LOW',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.blue)),
                      const SizedBox(width: 15),
                      Container(height: 25, width: 2, color: Colors.grey),
                      const SizedBox(width: 15),
                      Radio<String>(
                        value: 'Medium',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text('MEDIUM',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.orange)),
                      const SizedBox(width: 15),
                      Container(height: 25, width: 2, color: Colors.grey),
                      const SizedBox(width: 15),
                      Radio<String>(
                        value: 'High',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      const Text('HIGH',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.redAccent)),
                    ]))),
          ],
        ),
        const SizedBox(height: 5),
        const Divider(),
        const Text('Participant(s):',
            style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
        Container(
          child: Column(
            children: currentList.map((member) {
              return ListTile(
                leading: avatar(userMap, member),
                title: Text(userServices.getNameFromId(userMap, member),
                    style:
                        const TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                subtitle: Text(
                  '${projectServices.getJoinedProjectNumber(projectMap, member)} Project(s)',
                  style: const TextStyle(fontFamily: 'MontMed', fontSize: 12),
                ),
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.redAccent,
                    onPressed: () {
                      _removeMember(member);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: TextButton(
              onPressed: _showMemberSelectionDialog,
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.blueAccent),
                  Text(
                    'Assign to Member(s)',
                    style: TextStyle(
                        fontFamily: 'MontMed', color: Colors.blueAccent),
                  ),
                ],
              ),
            )),
        Container(
            height: 50,
            child: TextButton(
              onPressed: () {
                _addTask();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return ListOfTaskScreen(
                    projectModel: projectModel!,
                    projectMap: projectMap,
                    userModel: currentUserModel,
                    taskMap: taskMap,
                  );
                }));
              },
              child: Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Initiate Task',
                      style: TextStyle(fontFamily: 'MontMed'),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            )),
      ])),
    )));
  }

  Future<void> _addTask() async {
    TaskService taskService = TaskService();
    taskService.addTask(
        taskNameController.text,
        taskDescriptionController.text,
        _selectedValue,
        taskStartDate,
        endDateController.text,
        projectModel!.projectId,
        currentUserModel.userId,
        currentPhraseModel.phraseId,
        currentList);
    currentPhraseModel.listTasks.add(taskService.realTaskId);
    PhraseServices().updatePhraseTaskList(projectModel!.projectId,
        currentPhraseModel.phraseId, currentPhraseModel.listTasks);
    DatabaseEvent taskDatabaseEvent = await taskService.taskRef.once();
    if (taskDatabaseEvent.snapshot.value != null &&
        taskDatabaseEvent.snapshot.value is Map) {
      taskMap = Map.from(taskDatabaseEvent.snapshot.value as dynamic);
    }

    // DatabaseReference phraseRef = FirebaseDatabase.instance
    //     .ref()
    //     .child('phrases')
    //     .child(projectModel.projectId);
    // DatabaseEvent phraseDatabaseEvent = await phraseRef.once();
    // if (phraseDatabaseEvent.snapshot.value != null &&
    //     phraseDatabaseEvent.snapshot.value is Map) {
    //   setState(() {
    //     phraseMap = Map.from(phraseDatabaseEvent.snapshot.value as dynamic);
    //   });
    // }
  }

  Future<void> _selectDate(TextEditingController textEditingController,
      DateTime dateTime, DateTime endDate) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: dateTime,
        lastDate: endDate);
    if (picked != null) {
      textEditingController.text = picked.toString().split(" ")[0];
    }
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
                      leading: avatar(userMap, user),
                      title: Text(UserServices().getNameFromId(userMap, user)),
                      subtitle: Text(
                        '${ProjectServices().getJoinedProjectNumber(projectMap, user)} Projects Involved',
                        style: const TextStyle(fontFamily: 'MontMed'),
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

  void _removeMember(String member) {
    setState(() {
      currentList.remove(member);
      allMembers.add(member);
    });
  }

  void _addMember(String member) {
    setState(() {
      currentList.add(member);
      allMembers.remove(member);
    });
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Container(width: 15, height: 15, color: Colors.redAccent),
                const SizedBox(width: 5),
                Text(
                  value,
                  style: const TextStyle(fontFamily: 'MontMed'),
                )
              ],
            ));
      }).toList(),
    );
  }
}
