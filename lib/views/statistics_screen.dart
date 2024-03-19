import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';

class statistic_screen extends StatefulWidget {
  const statistic_screen({Key? key}) : super(key: key);

  @override
  State<statistic_screen> createState() => _statistic_screenState();
}

List<String> list = <String>['2023 - 2024', '2024 - Present'];

class _statistic_screenState extends State<statistic_screen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        const Text(
                          'STATISTIC',
                          style: TextStyle(
                            fontFamily: 'Anurati',
                            fontSize: 30,
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.indigo[50],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bar_chart, color: Colors.orangeAccent),
                                  SizedBox(width: 5),
                                  Text('Project Statistic:', style: TextStyle(fontFamily: 'MontMed', fontSize: 14)),
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [YearDropdown()],
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 200,
                                      child: Dashboard_chart(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(height: 15, width: 15, color: Colors.lightBlueAccent,),
                                    SizedBox(width: 10),
                                    Text('In Progress', style: TextStyle(fontFamily: 'MontMed')),
                                    SizedBox(width: 20),
                                    Container(height: 15, width: 15, color: Colors.greenAccent,),
                                    SizedBox(width: 10),
                                    Text('Done', style: TextStyle(fontFamily: 'MontMed')),
                                    SizedBox(width: 20),
                                    Container(height: 15, width: 15, color: Colors.redAccent,),
                                    SizedBox(width: 10),
                                    Text('Overdue', style: TextStyle(fontFamily: 'MontMed')),
                                  ]
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.playlist_play, size: 30, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Assigned: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('200 Tasks', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.playlist_add_check, size: 30, color: Colors.green),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Completed: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('180 Tasks', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.timer, size: 25, color: Colors.purpleAccent),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Time/Task: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('8.5 days', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.playlist_remove, size: 30, color: Colors.redAccent),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Overdue: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('20 Tasks', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, size: 25, color: Colors.deepOrange),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Leader Role: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('12 People', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.indigo[50],
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, size: 30, color: Colors.redAccent),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Member Role: ', style: TextStyle(fontFamily: 'MontMed', fontSize: 11)),
                                          Text('36 People', style: TextStyle(fontFamily: 'MontMed'))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
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
                  Text("123", style: TextStyle(fontFamily: 'MontMed', fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("PROJECTS", style: TextStyle(fontFamily: 'MontMed'),),
                  Text("IN TOTAL", style: TextStyle(fontFamily: 'MontMed'),)
                ],
              )
          ),
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
                    radius: 24
                ),
                PieChartSectionData(
                    value: 5,
                    color: Colors.lightBlueAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.6,
                    title: '50',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 20
                ),
                PieChartSectionData(
                    value: 3,
                    color: Colors.redAccent,
                    showTitle: true,
                    titlePositionPercentageOffset: 1.5,
                    title: '30',
                    titleStyle: TextStyle(fontFamily: 'MontMed'),
                    radius: 28
                ),
              ],
            ),),
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
    final List<int> years = List.generate(currentYear - 2022, (index) => currentYear - index);

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
          child: Text(value.toString(), style: TextStyle(fontFamily: 'MontMed', fontSize: 14),),
        );
      }).toList(),
    );
  }
}

