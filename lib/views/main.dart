import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String name;
  final String role;

  User(this.name, this.role);
}

class MyApp extends StatelessWidget {
  final List<User> users = [
    User("John Doe", "Admin"),
    User("Jane Smith", "Moderator"),
    User("Tom Brown", "User"),
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserSelection(users),
    );
  }
}

class UserSelection extends StatefulWidget {
  final List<User> users;

  UserSelection(this.users);

  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  User? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<User>(
              hint: Text('Select a user'),
              value: selectedUser,
              onChanged: (user) {
                setState(() {
                  selectedUser = user;
                });
                // Handle user selection here
                print('Selected user: ${user?.name}');
              },
              items: widget.users.map<DropdownMenuItem<User>>((User user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
            ),
            if (selectedUser != null) ...[
              SizedBox(height: 20),
              Text(
                'Selected user details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Name: ${selectedUser?.name}'),
              Text('Role: ${selectedUser?.role}'),
            ],
          ],
        ),
      ),
    );
  }
}
