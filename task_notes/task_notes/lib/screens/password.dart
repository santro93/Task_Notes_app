import 'package:flutter/material.dart';

class PasswordRefactor extends StatefulWidget {
  const PasswordRefactor({Key? key}) : super(key: key);

  @override
  State<PasswordRefactor> createState() => _PasswordRefactorState();
}

class _PasswordRefactorState extends State<PasswordRefactor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Refactor Screen',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[200],
      ),
    );
  }
}
