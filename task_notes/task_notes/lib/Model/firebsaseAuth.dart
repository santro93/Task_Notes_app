import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthentic {
  String? name;
  String? email;
  String? password;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _storeUserDetails() async {
    await firestore.collection('users').add({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  void _createAccount() async {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 5000),
      content: const Text(
        "Account Is Created Successfully.",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      backgroundColor: Colors.green[400],
    );

    if (name!.isNotEmpty && email!.isNotEmpty && password!.isNotEmpty) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((value) => {
                print("New account created"),
                _storeUserDetails(),
                //ScaffoldMessenger.of(context).showSnackBar(snackBar),
              })
          .onError(
            (error, stackTrace) => {
              print("Error ${error.toString()}"),
            },
          );
    } else {
      final snackBar = SnackBar(
        duration: const Duration(milliseconds: 5000),
        content: const Text(
          "Account Is Not Created.",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.green[400],
      );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
