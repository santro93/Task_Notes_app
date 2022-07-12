import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_notes/screens/signin.dart';
import 'package:task_notes/screens/signup.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({Key? key}) : super(key: key);

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  void _signOut() {
    FirebaseAuth.instance.signOut().then(
      (value) {
        print("Signed Out");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
    );
  }

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
      body: Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SigninPage()));
          },
          color: Colors.green[400],
          child: const Text(
            "Sign In",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        color: Colors.amber[500],
      ),
      drawer: Drawer(
        backgroundColor: Colors.amber[500],
        child: ListView(
          children: const [
            SizedBox(
              child: DrawerHeader(
                  child: Text(
                "Notes Keep",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              height: 60,
            ),
            ListTile(
              title: Text(
                "Notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Reminder",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: (null),
            ),
            ListTile(
              title: Text(
                "Create New lable",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: (null),
            ),
            ListTile(
              title: Text(
                "Archive",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                "Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      // RaisedButton(
      //   color: Colors.green[400],
      //   onPressed: () {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => SignupPage()),
      //     );
      //   },
      //   child: const Text("Create Account",
      //       style: TextStyle(fontSize: 20, color: Colors.black)),
      // ),
    );
  }
}
