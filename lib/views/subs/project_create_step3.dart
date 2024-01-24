import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/views/subs/db_main_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class projectCreateStep3 extends StatefulWidget {
  final TextEditingController projectNameController;
  final TextEditingController projectDescriptionController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final String teamLeaderId;
  final UserModel? currentUserModel;
  final Map<String, dynamic> projectMap;
  const projectCreateStep3(
      {Key? key,
      required this.projectNameController,
      required this.projectDescriptionController,
      required this.startDateController,
      required this.endDateController,
      required this.teamLeaderId,
      required this.currentUserModel,
      required this.projectMap})
      : super(key: key);

  @override
  State<projectCreateStep3> createState() => _projectCreateStep3State();
}

List<String> list = <String>['Member', 'Leader'];

class _projectCreateStep3State extends State<projectCreateStep3> {
  var projectNameController = TextEditingController();
  var projectDescriptionController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  UserModel? currentUserModel;
  String teamLeaderIdController = "";
  Map<String, dynamic> projectMap = {};

  List<String> phrases = [
    "Requirement and Gathering",
    "Planning",
    "Design",
    "Development",
    "Testing",
    "Deployment",
    "Maintenance"
  ];

  List<String> currentPhrases = [
    "Distribution",
  ];

  Future<void> _getProjectValues() async {
    DatabaseEvent databaseEvent =
        await FirebaseDatabase.instance.ref().child('projects').once();
    projectMap = Map.from(databaseEvent.snapshot.value as dynamic);
    setState(() {});
  }

  @override
  void initState() {
    projectNameController = widget.projectNameController;
    projectDescriptionController = widget.projectDescriptionController;
    startDateController = widget.startDateController;
    endDateController = widget.endDateController;
    teamLeaderIdController = widget.teamLeaderId;
    currentUserModel = widget.currentUserModel;
    projectMap = widget.projectMap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    const Text(
                      'PHRASES',
                      style: TextStyle(
                        fontFamily: 'Anurati',
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Text('Default Phrases(immutable)',
                        style: TextStyle(fontFamily: 'MontMed')),
                  ],
                ),
                Column(
                  children: phrases.map((process) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                          title: Text(
                            process,
                            style: const TextStyle(fontFamily: 'MontMed'),
                          ),
                          subtitle: const Text(
                            'Description',
                            style: TextStyle(fontFamily: 'MontMed'),
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text('Defined Phrases',
                        style: TextStyle(fontFamily: 'MontMed')),
                  ],
                ),
                Column(
                  children: currentPhrases.map((process) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                          title: Text(
                            process,
                            style: const TextStyle(fontFamily: 'MontMed'),
                          ),
                          subtitle: const Text(
                            'Description',
                            style: TextStyle(fontFamily: 'MontMed'),
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
                                _removeProcess(process);
                              },
                            ),
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Container(
                    height: 50,
                    child: TextButton(
                      onPressed: _showAddItemDialog,
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 10),
                          Text(
                            'Define New Phrases',
                            style: TextStyle(fontFamily: 'MontMed'),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        ProjectServices().addProject(
                            projectNameController.text,
                            projectDescriptionController.text,
                            startDateController.text,
                            endDateController.text,
                            teamLeaderIdController,
                            phrases,
                            currentUserModel);
                        //Navigator.popUntil(context, ModalRoute.withName('/'));

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    DashboardMainV1(
                                        currentUserModel: currentUserModel,
                                        projectMap: projectMap)));
                      },
                      child: Container(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Initiate Project',
                              style: TextStyle(fontFamily: 'MontMed'),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Item',
            style: TextStyle(fontFamily: 'MontMed'),
          ),
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontMed',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Description'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'MontMed',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'MontMed'),
              ),
            ),
            TextButton(
              onPressed: () {
                // Update the list with the new item
                setState(() {
                  currentPhrases.add(nameController.text);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(fontFamily: 'MontMed'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeProcess(String member) {
    setState(() {
      currentPhrases.remove(member);
    });
  }
}
