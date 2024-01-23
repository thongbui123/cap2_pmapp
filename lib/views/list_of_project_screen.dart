import 'package:capstone2_project_management_app/views/project_detail_screen.dart';
import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';

class listOfProjects extends StatefulWidget {
  const listOfProjects({Key? key}) : super(key: key);

  @override
  State<listOfProjects> createState() => _listOfProjectsState();
}

class _listOfProjectsState extends State<listOfProjects>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> allProjects = [
    'Project A01',
    'Project B02',
    'Project B01',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.deepOrangeAccent,
          tooltip: 'Add Project', // Optional tooltip text shown on long-press
          child: Icon(
            Icons.create_new_folder,
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
                            'PROJECTS',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Recent'),
                          Tab(text: 'All'),
                        ],
                        labelStyle: TextStyle(fontFamily: 'MontMed'),
                      ),
                      SizedBox(height: 10),
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
                                Icon(Icons.data_saver_off, size: 15),
                                SizedBox(width: 10),
                                Text('State',
                                    style: TextStyle(
                                        fontFamily: 'MontMed', fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      Container(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Content for Tab 1
                            Container(
                              child: Column(
                                children: ListTile.divideTiles(
                                  context:
                                      context, // Make sure to provide the BuildContext if this code is inside a widget build method
                                  tiles: allProjects.map((project) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const projectDetailScreen()));
                                      },
                                      leading: const CircleAvatar(
                                        child: Icon(
                                          Icons.folder,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      title: Text(project,
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 13)),
                                      subtitle: Text(
                                        'Participants: 3',
                                        style: const TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12),
                                      ),
                                    );
                                  }),
                                ).toList(),
                              ),
                            ),
                            // Content for Tab 2
                            Container(
                              child: Column(
                                children: ListTile.divideTiles(
                                  context:
                                      context, // Make sure to provide the BuildContext if this code is inside a widget build method
                                  tiles: allProjects.map((project) {
                                    return ListTile(
                                      leading: const CircleAvatar(
                                        child: Icon(
                                          Icons.folder,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      title: Text(project,
                                          style: TextStyle(
                                              fontFamily: 'MontMed',
                                              fontSize: 13)),
                                      subtitle: Text(
                                        'Participants: 3',
                                        style: const TextStyle(
                                            fontFamily: 'MontMed',
                                            fontSize: 12),
                                      ),
                                    );
                                  }),
                                ).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
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

  bool dateVisibility = true;
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
                  leading: Icon(Icons.date_range_sharp),
                  title: Text('Day started',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    dateVisibility = true;
                    numberVisibility = false;
                    nameVisibility = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: dateVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.people_alt_outlined),
                  title: Text('Number of members',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    dateVisibility = false;
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
                    dateVisibility = false;
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

  bool completedVisibility = true;
  bool incompletedVisibility = false;
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
                  Text('State:',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              ListTile(
                  leading: Icon(Icons.mood),
                  title: Text('Completed',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    completedVisibility = true;
                    incompletedVisibility = false;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: completedVisibility,
                    child: Icon(Icons.check),
                  ))),
              ListTile(
                  leading: Icon(Icons.mood_bad),
                  title: Text('Incompleted',
                      style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                  onTap: () {
                    completedVisibility = false;
                    incompletedVisibility = true;
                    Navigator.pop(context);
                  },
                  trailing: Container(
                      child: Visibility(
                    visible: incompletedVisibility,
                    child: Icon(Icons.check),
                  ))),
            ],
          ),
        );
      },
    );
  }
}

class filteredList extends StatefulWidget {
  const filteredList({super.key});

  @override
  State<filteredList> createState() => _filteredListState();
}

List<String> list = <String>['Ascending', 'Descending'];

class _filteredListState extends State<filteredList> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontFamily: 'MontMed', color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
