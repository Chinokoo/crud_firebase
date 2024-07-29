import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class NotesDisplay extends StatefulWidget {
  final Function()? update;
  final TextEditingController noteController;
  const NotesDisplay(
      {super.key, required this.update, required this.noteController});

  @override
  State<NotesDisplay> createState() => _NotesDisplayState();
}

class _NotesDisplayState extends State<NotesDisplay> {
  //updating a note
  void updateNote(docID) {
    FirestoreService().updateNote(docID, widget.noteController.text);

    //clear the controller
    widget.noteController.clear();

    //pop the dialog
    Navigator.pop(context);
  }

  //open a dialog box to add a new note
  void openNoteBox(String docID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: widget.noteController,
                decoration: const InputDecoration(
                  hintText: "Update Note",
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => updateNote(docID),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notes available'));
        }
        //listing all the notes
        List notesList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notesList.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = notesList[index];
            String docID = document.id;

            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String noteText = data['note'] ?? 'No content';

            return ListTile(
              title: Text(noteText),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => openNoteBox(docID),
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () => FirestoreService().deleteNote(docID),
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
