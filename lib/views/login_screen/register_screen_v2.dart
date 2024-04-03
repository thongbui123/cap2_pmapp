import 'package:flutter/material.dart';

import '../../services/auth_services.dart';

class RegisterScreenV2 extends StatefulWidget {
  const RegisterScreenV2({super.key});

  @override
  State<RegisterScreenV2> createState() => _RegisterScreenV2State();
}

class _RegisterScreenV2State extends State<RegisterScreenV2> {
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
              Text(
                'REGISTER',
                style: TextStyle(
                  fontFamily: 'Anurati',
                  fontSize: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom:
                        40.0), // Adds padding (margin) at the bottom of this container
                child: Container(
                  width: 100,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 145,
                      child: TextField(
                        controller: _controllerFirstName,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Mont',
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 145,
                      child: TextField(
                        controller: _controllerLastName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Mont',
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerEmail,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerPassword,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerConfirm,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    labelText: 'Confirm',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add additional spacing
              Container(
                width: 300.0,
                height: 50, // Set the desired width for the ElevatedButton
                child: ElevatedButton(
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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF005CB1)), // Set the background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4.0), // Set the corner radius
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Mont',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Already have and account? Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.bold,
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
