import 'package:capstone2_project_management_app/views/dashboard_screen/dashboard_screen.dart';
import 'package:capstone2_project_management_app/views/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAuth auth = FirebaseAuth.instance;
  //auth.signOut();
  //AuthServices().signOut;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFF7E57C2)),
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginScreen()
            : const DashboardScreen());
  }
}
