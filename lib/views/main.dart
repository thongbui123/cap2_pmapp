import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    // Set up your events
    _loadEvents();
  }

  // Simulating an event loader function
  void _loadEvents() {
    _events = {
      DateTime(2024, 2, 28): ['Event 1'],
      DateTime(2024, 3, 1): ['Event 2'],
      DateTime(2024, 3, 2): ['Event 3'],
    };
  }

  List<String> _getEventFromDay(DateTime date) {
    return _events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Calendar Marker Example'),
      ),
      body: TableCalendar(
        eventLoader: _getEventFromDay,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            // Customize marker for each event
            List<Widget> markers = [];

            for (var event in events) {
              // Define marker color for each event
              Color markerColor;
              if (event == 'Event 1') {
                markerColor = Colors.red;
              } else if (event == 'Event 2') {
                markerColor = Colors.blue;
              } else {
                markerColor = Colors.green;
              }

              markers.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: markerColor,
                    ),
                    width: 16,
                    height: 16,
                    child: Center(
                      child: Text(
                        '●', // You can use any symbol or text as a marker
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2025, 1, 1),
      ),
    );
  }
}
