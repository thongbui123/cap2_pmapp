import 'package:flutter/material.dart';

import '../../services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  String selectedRole = 'User'; // Set the default role to "Developer"
  @override
  void dispose() {
    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                width: 200,
                image: AssetImage('assets/projectLogo.png'),
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 145,
                      child: TextField(
                        controller: _controllerFirstName,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Consolas'),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Robot',
                          ),
                          filled: true,
                          fillColor: Colors.black87,
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 145,
                      child: TextField(
                        controller: _controllerLastName,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Consolas'),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Robot',
                          ),
                          filled: true,
                          fillColor: Colors.black87,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300, // Set the desired width here
                child: DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.always,
                  dropdownColor: Colors.black87, // Force validation
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                        color: Colors.redAccent, fontFamily: 'Consolas'),
                    filled: true,
                    fillColor: Colors.black87,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    prefixIcon: Icon(
                      Icons.school_outlined,
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Robot',
                    fontSize: 16,
                  ),
                  items: ['User', 'Admin']
                      .map((role) => DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  value: selectedRole, // Set the current selected value
                  onChanged: (selectedValue) {
                    setState(() {
                      selectedRole = selectedValue ?? selectedRole;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role'; // Display an error message if no role is selected
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerEmail,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Consolas'),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Robot',
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerPhone,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Consolas'),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Phone',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Robot',
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerPassword,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Consolas'),
                  obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Robot',
                    ),
                    filled: true,
                    fillColor: Colors.black87,
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // SizedBox(
              //   width: 300,
              //   child: TextField(
              //     controller: _controllerConfirm,
              //     style: const TextStyle(
              //         color: Colors.white, fontFamily: 'Consolas'),
              //     obscureText: true,
              //     decoration: const InputDecoration(
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.black),
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.black),
              //       ),
              //       labelText: 'Confirm Password',
              //       labelStyle: TextStyle(
              //         color: Colors.white,
              //         fontFamily: 'Robot',
              //       ),
              //       filled: true,
              //       fillColor: Colors.black87,
              //       border: UnderlineInputBorder(),
              //       prefixIcon: Icon(
              //         Icons.lock_outline,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              //const SizedBox(height: 20), // Add additional spacing
              OutlinedButton(
                onPressed: () {
                  AuthServices().createUserWithEmailAndPassword(
                      _controllerEmail,
                      _controllerPassword,
                      _controllerFirstName,
                      _controllerLastName,
                      _controllerConfirm,
                      selectedRole,
                      context);
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  side: const BorderSide(
                    color: Colors.green,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Robot',
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add additional spacing
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  side: const BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Robot',
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
