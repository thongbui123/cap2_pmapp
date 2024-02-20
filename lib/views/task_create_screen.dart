import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:flutter/material.dart';

class TaskCreateScreen extends StatefulWidget {
  final Map projectMap;
  final UserModel currentUserModel;
  final Map userMap;
  const TaskCreateScreen(
      {super.key,
      required this.projectMap,
      required this.currentUserModel,
      required this.userMap});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

List<String> list = <String>['HIGH', 'MEDIUM', 'LOW'];
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

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  late Map projectMap;
  late UserModel currentUserModel;
  late Map userMap;
  var taskNameController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var endDateController = TextEditingController();
  String _selectedValue = 'Option 1';
  List<String> _allMembers = [
    'User 1',
    'User 2',
    'User 3',
  ];

  List<String> currentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectMap = widget.projectMap;
    currentUserModel = widget.currentUserModel;
    userMap = widget.userMap;
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
        SizedBox(height: 5),
        Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                    child: Text(
                  'T',
                  style: TextStyle(fontFamily: 'MontMed'),
                )),
                title: Text('Assigned by:',
                    style: TextStyle(
                        fontFamily: 'MontMed',
                        fontSize: 12,
                        color: Colors.black54)),
                subtitle: Text('THONG B',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
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
                  _selectDate(endDateController,
                      DateTime.now().subtract(const Duration(days: 60)));
                },
              ),
            )),
          ],
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                    child: Icon(Icons.folder, color: Colors.orangeAccent)),
                title: Text('Project :',
                    style: TextStyle(
                        fontFamily: 'MontMed',
                        fontSize: 12,
                        color: Colors.black54)),
                subtitle: Text('PROJECT B',
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                trailing: TextButton(
                  onPressed: () {
                    _showProjectSelectionDialog();
                  },
                  child: Text('Switch',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        Text('Priority:',
            style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
        Row(
          children: [
            Expanded(
                child: Container(
                    height: 50,
                    child: Row(children: [
                      Radio<String>(
                        value: 'Option 1',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      Text('LOW',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.blue)),
                      SizedBox(width: 15),
                      Container(height: 25, width: 2, color: Colors.grey),
                      SizedBox(width: 15),
                      Radio<String>(
                        value: 'Option 2',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      Text('MEDIUM',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.orange)),
                      SizedBox(width: 15),
                      Container(height: 25, width: 2, color: Colors.grey),
                      SizedBox(width: 15),
                      Radio<String>(
                        value: 'Option 3',
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      Text('HIGH',
                          style: TextStyle(
                              fontFamily: 'MontMed', color: Colors.redAccent)),
                    ]))),
          ],
        ),
        SizedBox(height: 5),
        Divider(),
        Text('Participant(s):',
            style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
        Container(
          child: Column(
            children: currentList.map((member) {
              return ListTile(
                leading: const CircleAvatar(
                    child: Text(
                  'A',
                  style: TextStyle(fontFamily: 'MontMed'),
                )),
                title: Text(member,
                    style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                subtitle: Text(
                  '2 Projects',
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
        SizedBox(height: 10),
        Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
              onPressed: () {},
              child: Container(
                child: Row(
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

  Future<void> _selectDate(
      TextEditingController textEditingController, DateTime dateTime) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: dateTime,
        lastDate: DateTime(2030));
    if (_picked != null) {
      textEditingController.text = _picked.toString().split(" ")[0];
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
              children: _allMembers.map((user) {
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
    });
  }

  void _addMember(String member) {
    setState(() {
      currentList.add(member);
    });
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
                SizedBox(width: 5),
                Text(
                  value,
                  style: TextStyle(fontFamily: 'MontMed'),
                )
              ],
            ));
      }).toList(),
    );
  }
}
