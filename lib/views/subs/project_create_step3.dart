import 'package:flutter/material.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';

class projectCreateStep3 extends StatefulWidget {
  const projectCreateStep3({Key? key}) : super(key: key);

  @override
  State<projectCreateStep3> createState() => _projectCreateStep3State();
}

List<String> list = <String>['Member', 'Leader'];

class _projectCreateStep3State extends State<projectCreateStep3> {
  List<String> developmentPhrases = [
    "Requirement and Gathering",
    "Planning",
    "Design",
    "Development",
    "Testing",
    "Deployment",
    "Maintenance"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
                    Text(
                      'PROCESSES',
                      style: TextStyle(
                        fontFamily: 'Anurati',
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Column(
                  children: developmentPhrases.map((process) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(process),
                          subtitle: Text('Description', style: TextStyle(fontFamily: 'MontMed'),),
                        ),
                        Divider(height: 0),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {_showAddItemDialog(context);},
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 10),
                          Text('Define a new process', style: TextStyle(fontFamily: 'MontMed'),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    height: 50,
                    child: TextButton(
                      onPressed: (){},
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Initiate Project', style: TextStyle(fontFamily: 'MontMed'),),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item', style: TextStyle(fontFamily: 'MontMed'),),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name',),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Description'),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontMed',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(fontFamily: 'MontMed'),),
            ),
            TextButton(
              onPressed: () {
                // Update the list with the new item
                setState(() {
                  developmentPhrases.add(nameController.text);
                });
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(fontFamily: 'MontMed'),),
            ),
          ],
        );
      },
    );
  }
}