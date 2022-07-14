import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_notes/screens/app_main.dart';
import 'package:task_notes/screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SigninPage(),
    debugShowCheckedModeBanner: false,
  ));
}
