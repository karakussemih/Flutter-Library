import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();
  void OpenNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                children: [
                  TextField(
                    controller: textController,
                  ),
                  TextField(
                    controller: textController2,
                  ),
                  TextField(
                    controller: textController3,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addNote(
                            textController.text,
                            textController2.text,
                            textController3.text,
                            textController4.text);
                      } else {
                        firestoreService.updateNote(
                            docID,
                            textController.text,
                            textController2.text,
                            textController3.text,
                            textController4.text);
                      }
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Semih Karakuş Kutuphane')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEntryPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String DocID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  String noteText = data['note'];

                  String noteText2 = data['note2'];
                  String noteText3 = data['note3'];
                  return ListTile(
                      isThreeLine: true,
                      title: Text(noteText),
                      //subtitle: Text(noteText2),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yazar Adı: $noteText2'),
                          Text('Sayfa Sayısı: $noteText3'), // İkinci subtitle
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => OpenNoteBox(docID: DocID),
                              icon: const Icon(Icons.settings)),
                          IconButton(
                              onPressed: () =>
                                  firestoreService.deleteNote(DocID),
                              icon: const Icon(Icons.delete))
                        ],
                      ));
                },
              );
            } else {
              return const Text('No notes.');
            }
          }),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class NoteEntryPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Not Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Kitap Adı'),
            ),
            TextField(
              controller: textController2,
              decoration: InputDecoration(labelText: 'Yazar Adı'),
            ),
            TextField(
              controller: textController3,
              decoration: InputDecoration(labelText: 'Sayfa Sayısı'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                firestoreService.addNote(
                    textController.text,
                    textController2.text,
                    textController3.text,
                    textController4.text);
                textController.clear();
                textController2.clear();
                Navigator.pop(context); // Ana sayfaya dön
              },
              child: Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
