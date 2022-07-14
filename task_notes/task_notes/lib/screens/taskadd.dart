import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_notes/models/note.dart';
import 'package:task_notes/screens/app_main.dart';

class AddNote extends StatefulWidget {
  Note? note;
  AddNote({Key? key, this.note}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title = TextEditingController();
  late TextEditingController des;
  // = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("notes");

  void setUp() {
    if (widget.note != null) {
      title.text = widget.note?.title ?? "";
      des.text = widget.note?.des ?? "";
    }
  }

  @override
  void initState() {
    des = TextEditingController();
    setUp();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    des.dispose(); //des
    super.dispose();
  }

  void addNote() async {
    if (widget.note != null) {
      ref
          .doc(widget.note?.id!)
          .update({'title': title.text, 'content': des.text});
    } else {
      ref.add({'title': title.text, 'content': des.text});
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppMainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note Screen',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[500],
      ),
      body: Center(
        child: Container(
          color: Colors.amberAccent[200],
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: des,
                decoration: const InputDecoration(
                  hintText: 'Note',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.black),
                onPressed: addNote,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green[400],
                  ),
                ),
                label: const Text(
                  'Save Note',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
