import 'package:crud_firebase/components/notes_display.dart';
import 'package:crud_firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService fireStoreService = FirestoreService();

  //controller for the text field
  final TextEditingController noteController = TextEditingController();

  //add a new note to the database
  void newNote({String? docID}) {
    //add a new note.
    fireStoreService.addNote(noteController.text);

    //clear the text controller
    noteController.clear();
    //close the dialog box
    Navigator.of(context).pop();
  }

  //open a dialog box to add a new note
  void openNoteBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: noteController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => newNote(),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Notes"),
        ),
      ),
      //floating action bar on the home page
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: NotesDisplay(
        noteController: noteController,
        update: openNoteBox,
      ),
    );
  }
}
