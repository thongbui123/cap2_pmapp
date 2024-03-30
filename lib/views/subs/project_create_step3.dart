// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:capstone2_project_management_app/services/phase_services.dart';
import 'package:capstone2_project_management_app/services/project_services.dart';
import 'package:capstone2_project_management_app/views/dashboard_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProjectCreateStep3 extends StatefulWidget {
  final TextEditingController projectNameController;
  final TextEditingController projectDescriptionController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final String teamLeaderId;
  final UserModel? currentUserModel;
  final Map<String, dynamic> projectMap;
  const ProjectCreateStep3(
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
  State<ProjectCreateStep3> createState() => _ProjectCreateStep3State();
}

List<String> list = <String>['Member', 'Leader'];

class _ProjectCreateStep3State extends State<ProjectCreateStep3> {
  var projectNameController = TextEditingController();
  var projectDescriptionController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  UserModel? currentUserModel;
  String teamLeaderIdController = "";
  Map<String, dynamic> projectMap = {};
  List<String> phaseNames = [];
  List<Phase> phrasesList = [
    Phase(
        phaseName: "Requirement and Gathering",
        phraseDescription: "Description"),
    Phase(phaseName: "Planning", phraseDescription: "Description"),
    Phase(phaseName: "Design", phraseDescription: "Description"),
    Phase(phaseName: "Development", phraseDescription: "Description"),
    Phase(
        phaseName: "Requirement and Gathering",
        phraseDescription: "Description"),
    Phase(phaseName: "Testing", phraseDescription: "Description"),
    Phase(phaseName: "Deployment", phraseDescription: "Description"),
    Phase(phaseName: "Maintenance", phraseDescription: "Description"),
  ];

  List<Phase> additionPhrases = [
    Phase(phaseName: "Distribution", phraseDescription: "Description"),
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
    phrasesList.forEach((element) {
      phaseNames.add(element.phaseName);
    });
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
                      'PHASES',
                      style: TextStyle(
                        fontFamily: 'MontMed',
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
                  children: phrasesList.map((phase) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                          title: Text(
                            phase.phaseName,
                            style: const TextStyle(fontFamily: 'MontMed'),
                          ),
                          subtitle: Text(
                            phase.phraseDescription,
                            style: const TextStyle(fontFamily: 'MontMed'),
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
                  children: additionPhrases.map((phase) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                          title: Text(
                            phase.phaseName,
                            style: const TextStyle(fontFamily: 'MontMed'),
                          ),
                          subtitle: Text(
                            phase.phraseDescription,
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
                                _removeProcess(phase.phaseName);
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
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const Dashboard_screen(),
                          ),
                        );
                        ProjectServices projectServices = ProjectServices();
                        if (additionPhrases.isNotEmpty) {
                          for (var phase in additionPhrases) {
                            phrasesList.add(phase);
                            phaseNames.add(phase.phaseName);
                          }
                        }
                        projectServices.addProject(
                            projectNameController.text,
                            projectDescriptionController.text,
                            startDateController.text,
                            endDateController.text,
                            teamLeaderIdController,
                            phaseNames,
                            currentUserModel);
                        //Navigator.popUntil(context, ModalRoute.withName('/'));
                        for (var phase in phrasesList) {
                          PhaseServices().addPhrase(
                            phase.phaseName,
                            projectServices.realProjectID,
                            [],
                            phase.phraseDescription,
                          );
                          phaseNames.add(projectServices.realProjectID);
                          DatabaseReference projectRef = FirebaseDatabase
                              .instance
                              .ref()
                              .child('projects')
                              .child(projectServices.realProjectID);
                          await projectRef.update({
                            'projectPhrases': phaseNames,
                          });
                        }
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
            child: SingleChildScrollView(
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
                  additionPhrases.add(Phase(
                      phaseName: nameController.text,
                      phraseDescription: descriptionController.text));
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
      additionPhrases.remove(member);
    });
  }
}

class Phase {
  String phaseName;
  String phraseDescription;
  Phase({
    required this.phaseName,
    required this.phraseDescription,
  });
}
