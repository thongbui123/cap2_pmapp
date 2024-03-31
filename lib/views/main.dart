import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<String> _allItems = [
    'Apple',
    'Banana',
    'Orange',
    'Pineapple',
    'Grapes',
    'Mango',
    'Peach'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter search term',
          ),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _search,
            child: Text('Search'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    String searchText = _searchController.text.toLowerCase();
    _searchResults.clear();
    if (searchText.isEmpty) {
      setState(() {});
      return;
    }

    _allItems.forEach((item) {
      if (item.toLowerCase().contains(searchText)) {
        _searchResults.add(item);
      }
    });
    setState(() {});
  }
}
