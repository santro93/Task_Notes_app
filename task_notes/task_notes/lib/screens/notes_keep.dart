import 'package:flutter/material.dart';
import 'package:task_notes/model/note.dart';
import 'package:task_notes/screens/archieved_notes.dart';
import 'package:task_notes/screens/search_note.dart';
import 'package:task_notes/screens/signin.dart';
import 'package:task_notes/screens/addnote.dart';
import 'package:task_notes/service/firebase_auth.dart';
import 'package:task_notes/service/firebasenote_service.dart';
import 'package:task_notes/widgets/note_card.dart';

class NoteKeep extends StatefulWidget {
  @override
  State<NoteKeep> createState() => _NoteKeepState();
}

class _NoteKeepState extends State<NoteKeep> {
  ScrollController scrollController = ScrollController();
  bool isListView = true;
  final List<Note> notesList = [];
  bool loadding = false;

  initialFetch() async {
    print("item length ${notesList.length}");
    List<Note> dumyData2 = await FirebaseNoteService.instance.initialFetch();

    print("dumyData2 length ${dumyData2.length}");
    setState(() {
      notesList.addAll(dumyData2);
      loadding = false;
    });
    print("item length adding dumyData2 ${notesList.length}");
  }

  fetchData() async {
    setState(() {
      loadding = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<Note> dumyData2 = await FirebaseNoteService.instance.fetchMoreData();

    setState(() {
      notesList.addAll(dumyData2);
      loadding = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initialFetch();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !loadding) {
        print("NewData Called");
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void signOut() {
    FirebaseAuthentication.instance.signOutUser();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SigninPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_on : Icons.view_list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
          IconButton(
              onPressed: (() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchNote()));
              }),
              icon: const Icon(Icons.search)),
        ],
        centerTitle: true,
        title: const Text(
          "Notes Keep",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        //   automaticallyImplyLeading: false,
        backgroundColor: Colors.green[400],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                'Notes Keep',
                style: TextStyle(fontSize: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text(
                'Notes',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteKeep(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.remember_me),
              title: Text(
                'Reminders',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.create),
              title: Text(
                'Create new label',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: const Text(
                'Archive',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArchievedNotes(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: signOut,
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
      body: loadding
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isListView ? 1 : 2, crossAxisSpacing: 2),
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                final Note note = notesList[index];
                return NoteCard(note: note);
              },
            ),
    );
  }
}
      // body: FutureBuilder<QuerySnapshot>(
      //     future: ref
      //         .orderBy(
      //           "dateTime",
      //           descending: true,
      //         )
      //         .limit(noteDisplayLimit)
      //         .get(),
      //     builder: (context, snapshot) {
      //       log("message");
      //       if (snapshot.hasData) {
      //         if (snapshot.data!.docs.isEmpty) {
      //           return const Center(
      //             child: Text(
      //               "You have not yet saved Notes !",
      //               style: TextStyle(
      //                 color: Colors.white70,
      //               ),
      //             ),
      //           );
      //         }

      //         return ListView.builder(
      //           controller: scrollController,
      //           itemCount: snapshot.data!.docs.length,
      //           itemBuilder: (context, index) {
      //             final doc = snapshot.data!.docs[index];
      //             final note = Note.fromJson(doc);
      //             return NoteCard(note: note);
      //           },
      //         );
      //       } else {
      //         return const Center(
      //           child: Text("Loading Content..."),
      //         );
      //       }
      //     }),
//     );
//   }
// }

