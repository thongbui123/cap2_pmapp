import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  @override
  void dispose() {
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
                'RESET PASSWORD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Anurati',
                  fontSize: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.0), // Adds padding (margin) at the bottom of this container
                child: Container(
                  width: 100,
                  height: 1,
                  color: Colors.black,
                ),
              ),

              SizedBox(width: 20),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: Text(
                        'Please enter your email again to receive a reset password link',
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontWeight: FontWeight.w900,
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
              SizedBox(height: 20), // Add additional spacing
              Container(
                width: 300.0,
                height: 50,// Set the desired width for the ElevatedButton
                child: ElevatedButton(
                  onPressed: () {
                    // Login button onPressed action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF02A724)), // Set the background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0), // Set the corner radius
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'RECEIVE RESET LINK',
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
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
