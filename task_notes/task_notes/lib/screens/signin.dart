// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_notes/screens/app_main.dart';
import 'package:task_notes/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //////////////////   Email  Sign  In  /////////////
  void _signingIn() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppMainPage()),
      );
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }

  bool _isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Task Notes",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[400],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.amber[500],
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Email",
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: "  Password",
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.green[400],
              onPressed: _signingIn,
              child: const Text("Sign In",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Forgotten Password ? Click Me",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Have Not Account ?",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.green[400],
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text("Create Account",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
