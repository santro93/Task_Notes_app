import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String? title;
  String? des;
  Timestamp? dateTime;
  bool isArchive = false;

  Note({required this.isArchive, this.id, this.title, this.des, this.dateTime});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': des,
        'dateTime': dateTime,
        "isArchive": isArchive,
      };

  static Note fromJson(DocumentSnapshot<Object?> doc) {
    Map<String, dynamic> noteMap = doc.data() as Map<String, dynamic>;
    return Note(
      id: noteMap["id"],
      title: noteMap["title"],
      des: noteMap["content"],
      dateTime: noteMap["dateTime"],
      isArchive: noteMap["isArchive"],
    );
  }
}
