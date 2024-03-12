import 'package:capstone2_project_management_app/views/stats/stats.dart';
import 'package:capstone2_project_management_app/views/subs/db_side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';

class notification_screen extends StatefulWidget {
  const notification_screen({Key? key}) : super(key: key);

  @override
  State<notification_screen> createState() => _notification_screenState();
}

List<String> allNotice = [
  'You are now assigned as the leader of project A',
  'Task A has been assigned to you'
];

class _notification_screenState extends State<notification_screen> {

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
                      Row(
                        children: [
                          Text(
                            'NOTIFICATION',
                            style: TextStyle(
                              fontFamily: 'Anurati',
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        child: Column(
                          children: ListTile.divideTiles(
                            context: context,  // Make sure to provide the BuildContext if this code is inside a widget build method
                            tiles: allNotice.map((notice) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.black87,
                                  ),
                                ),
                                onTap: (){ },
                                title: Text(notice, style: TextStyle(fontFamily: 'MontMed', fontSize: 13)),
                                subtitle: Text(
                                  '2024-10-20 | 7:00',
                                  style: const TextStyle(fontFamily: 'MontMed', fontSize: 12),
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

