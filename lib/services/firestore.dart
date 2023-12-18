import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

//Create
  Future<void> addNote(String note, String note2, String note3, String text) {
    return notes.add({
      'note': note,
      'note2': note2,
      'note3': note3,
      'TimeStamp': Timestamp.now(),
    });
  }

  //read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('TimeStamp', descending: true).snapshots();
    return notesStream;
  }

  //Update
  Future<void> updateNote(
      String DocID, String newNote, newnote2, newnote3, String text) {
    return notes.doc(DocID).update({
      'note': newNote,
      'note2': newnote2,
      'note2': newnote3,
      'TimeStamp': Timestamp.now()
    });
  }

  //delete
  Future<void> deleteNote(String DocID) {
    return notes.doc(DocID).delete();
  }
}
