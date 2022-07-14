import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:task_notes/Model/firebsaseAuth.dart';
import 'package:task_notes/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isObscure = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

////////////// Database Storage   ////////////////////////////
  void _storeUserDetails() async {
    final uid = _auth.currentUser?.uid;
    await firestore
        .collection('users')
        .doc(uid)
        .set({
          'name': name.text,
          'email': email.text,
          'password': password.text,
        })
        .then((value) => {
              print("New database Added"),
            })
        .onError(
          (error, stackTrace) => {
            print("Error ${error.toString()}"),
          },
        );
  }

////////////// Account  Create  ////////////////////////////
  void _createAccount() async {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 5000),
      content: const Text(
        "Account Is Created Successfully.",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      backgroundColor: Colors.green[400],
    );

    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      _auth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                print("New account created"),
                _storeUserDetails(),
                ScaffoldMessenger.of(context).showSnackBar(snackBar),
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                ),
              });
    } else {
      final snackBar = SnackBar(
        duration: const Duration(milliseconds: 5000),
        content: const Text(
          "Account Is Not Created.",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.green[400],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _switchToSignin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SigninPage()));
  }

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://picsum.photos/200/300'),
                  ),
                  Positioned(
                    left: 70,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: name,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(gapPadding: 7),
                  hintText: "Enter Your Full Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(gapPadding: 7),
                  hintText: "Enter Your Email Id",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: password,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(gapPadding: 7),
                  labelText: "Enter Your Password",
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
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: _createAccount,
                color: Colors.green[400],
                child: const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Have Already Account ?",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: _switchToSignin,
                color: Colors.green[400],
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
