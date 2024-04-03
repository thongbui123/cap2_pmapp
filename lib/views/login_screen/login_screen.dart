import 'package:capstone2_project_management_app/views/login_screen/register_screen_v2.dart';
import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                'LOGIN',
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
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerEmail,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
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
              const SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerPassword,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  obscureText: true,
                  decoration: const InputDecoration(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Remember Me',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Consolas',
                    ),
                  ),
                  Container(
                    width: 70,
                  ),
                  TextButton(
                    onPressed: () {
                      // Password reset button onPressed action
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontFamily: 'Consolas',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: 300.0,
                height: 50, // Set the desired width for the ElevatedButton
                child: ElevatedButton(
                  onPressed: () {
                    AuthServices().signInWithEmailAndPassword(
                        _controllerEmail, _controllerPassword, context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF828282)), // Set the background color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4.0), // Set the corner radius
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'LOGIN',
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
              SizedBox(height: 20),
              const Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: 0.8,
                  color: Colors.black,
                )),
                Text(" OR "),
                Expanded(
                    child: Divider(
                  thickness: 0.8,
                  color: Colors.black,
                )),
              ]),
              const SizedBox(height: 20), // Add additional spacing
              Container(
                width: 300.0,
                height: 50, // Set the desired width for the ElevatedButton
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const RegisterScreenV2();
                    }));
                    // Login button onPressed action
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'BECOME A MEMBER',
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
