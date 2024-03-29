// CRUD operation of Cloud Storage
// add time of note created, when fetching latest should come 1st
/// Firebase  listner
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_notes/model/note.dart';

class FirebaseNoteService {
  FirebaseNoteService._privateCon();
  static final FirebaseNoteService instance = FirebaseNoteService._privateCon();
  Note? note;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static get uid => FirebaseAuth.instance.currentUser?.uid;
  static bool allLoaded = false;
  static QueryDocumentSnapshot? lastDocument;

  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection("notes");

  Future<String> addNote({required String title, required String des}) async {
    DocumentReference document = ref.doc();
    await ref.doc(document.id).set({
      'id': document.id,
      'title': title,
      'content': des,
      'dateTime': DateTime.now(),
    });
    return document.id;
  }

  void updateNote(Note note) {
    ref.doc(note.id!).update({
      'id': note.id,
      'title': note.title,
      'content': note.des,
    });
  }

  void deleteNote(Note note) {
    ref.doc(note.id!).delete();
  }

  Future<List<Note>> searchNote(String search) async {
    final snapshot =
        await ref.where('title', isGreaterThanOrEqualTo: search).get();
    final List<Note> notes = [];
    for (var element in snapshot.docs) {
      final note = Note.fromJson(element);
      notes.add(note);
    }
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<List<Note>> initialFetch() async {
    // print("currentUser uid ${FirebaseAuth.instance.currentUser!.uid}");
    // print("last Document ${lastDocument}");

    final snapshot = await ref
        .orderBy("dateTime")
        // .where("isArchive", isEqualTo: false)
        .limit(10)
        .get();
    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;
    }
    print("docs length ${snapshot.docs.length}");
    final List<Note> dumyData = [];
    for (var element in snapshot.docs) {
      final note = Note.fromJson(element);
      dumyData.add(note);
    }
    return dumyData;
  }

  Future<List<Note>> fetchMoreData() async {
    print(FirebaseAuth.instance.currentUser!.uid);

    if (allLoaded == true || lastDocument == null) {
      return [];
    }
    final snapshot = await ref
        .orderBy("dateTime")
        // .where("isArchive", isEqualTo: false)
        .startAfterDocument(lastDocument!)
        .limit(10)
        .get();

    lastDocument = snapshot.docs.last;
    final List<Note> dumyData = [];
    for (var element in snapshot.docs) {
      final note = Note.fromJson(element);
      dumyData.add(note);
    }
    if (snapshot.docs.length < 10) {
      //if getting less than 10 notes means
      allLoaded = true;
    }
    return dumyData;
  }

  void resetData() {
    allLoaded = false;
    lastDocument = null;
  }

  Future<String> archievedNotes(Note note) async {
    String result = "Some error occured ";
    try {
      await ref
        ..orderBy("dateTime").where("isArchive", isEqualTo: true).get();
      return result = "Successfully Archieved Notes";
    } catch (err) {
      result = err.toString();
      return result = "Unsuccessfully Archieved Notes";
      ;
    }
  }
}
