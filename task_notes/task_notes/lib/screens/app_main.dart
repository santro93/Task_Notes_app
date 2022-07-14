import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_notes/models/note.dart';
import 'package:task_notes/screens/signup.dart';
import 'package:task_notes/screens/taskadd.dart';
import 'package:task_notes/widgets/note_card.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({Key? key}) : super(key: key);

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  void _signOut() {
    FirebaseAuth.instance.signOut().then(
      (value) {
        // ignore: avoid_print
        print("Signed Out");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
    );
  }

  ////////////  CollectionReference to fetching database from Cloud /////////
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://picsum.photos/200/300'),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "Task Notes",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        //   automaticallyImplyLeading: false,
        backgroundColor: Colors.green[400],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            ListTile(
              title: Text(
                'Notes Keep',
                style: TextStyle(fontSize: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(
                'Notes',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.remember_me),
              title: Text(
                'Reminders',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text(
                'Create new label',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text(
                'Archive',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => AddNote()),
            ),
          );
        },
        backgroundColor: Colors.grey,
        child: (const Icon(Icons.add)),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "You have not yet saved Notes !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final title =
                    snapshot.data!.docs[index].get("title") ?? "default";
                final id = snapshot.data!.docs[index].id;
                final des =
                    snapshot.data!.docs[index].get("content") ?? "default";
                ////    //////////////
                final note = Note(id: id, title: title, des: des);
                /////////////
                return NoteCard(note: note);
              },
            );
          } else {
            return const Center(
              child: Text("Loading Content..."),
            );
          }
        },
      ),
    );
  }
}
