import 'package:flutter/material.dart';

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
  List<String> itemList = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Items Example'),
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return index == 0
              ? ListTile(
                  title: Text(itemList[index]),
                )
              : Dismissible(
                  key: Key(itemList[index]),
                  onDismissed: (direction) {
                    // Remove the item from the list
                    setState(() {
                      itemList.removeAt(index);
                    });
                    SnackBar snackBar = SnackBar(
                      content: Text('${itemList[index]} dismissed'),
                    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // Show a snackbar with the item name
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                  ),
                  child: ListTile(
                    title: Text(itemList[index]),
                  ),
                );
        },
      ),
    );
  }
}
