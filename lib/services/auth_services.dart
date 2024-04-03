import 'package:capstone2_project_management_app/views/dashboard_screen/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class AuthServices {
  Future<void> signInWithEmailAndPassword(TextEditingController controllerEmail,
      TextEditingController controllerPassword, BuildContext context) async {
    var email = controllerEmail.text.trim();
    var password = controllerPassword.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text('Logging Ip'), message: const Text('Please wait'));
    progressDialog.show();
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        progressDialog.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const DashboardScreen();
        }));
      }
      progressDialog.dismiss();
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'User is not found');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Password is wrong');
      }
    } catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Sonmething went wrong');
    }
  }

  Future<void> createUserWithEmailAndPassword(
      TextEditingController controllerEmail,
      TextEditingController controllerPassword,
      TextEditingController controllerFirstName,
      TextEditingController controllerLastName,
      TextEditingController controllerConfirm,
      String selectedRole,
      BuildContext context) async {
    var email = controllerEmail.text.trim();
    var password = controllerPassword.text.trim();
    var firstName = controllerFirstName.text.trim();
    var lastName = controllerLastName.text.trim();
    var confirm = controllerConfirm.text.trim();
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      Fluttertoast.showToast(msg: 'Fill in all fields');
      return;
    }
    // if (phone.length > 10 || phone.length < 8) {
    //   Fluttertoast.showToast(
    //       msg: 'Phone number has to contain 9 to 10 numbers');
    //   return;
    // }
    if (password.length < 6) {
      Fluttertoast.showToast(
          msg: 'Weak password at least 6 characters required');
      return;
    }
    if (password != confirm) {
      Fluttertoast.showToast(msg: 'Password does not match');
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text('Signing Up'), message: const Text('Please wait'));
    progressDialog.show();

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users');
        String uid = userCredential.user!.uid;
        int dt = DateTime.now().microsecondsSinceEpoch;
        await userRef.child(uid).set({
          'userFirstName': firstName,
          'userLastName': lastName,
          'userEmail': email,
          'dt': "",
          'userId': uid,
          'profileImage': '',
          'userRole': selectedRole,
          'userPhone': ""
        });
        Fluttertoast.showToast(msg: 'Successful');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Failed');
      }
      progressDialog.dismiss();
    } on FirebaseAuthException catch (e) {
      progressDialog.dismiss();
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email is already in use');
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'Password is weak');
      }
    } catch (e) {
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Sonmething went wrong');
    }
  }

  Future<void> signOut(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
  }
}
