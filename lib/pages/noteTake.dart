import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../models/note.dart';


class newNote extends StatefulWidget {
  const newNote({super.key});
  @override
  State<newNote> createState() => _newNoteState();
}

class _newNoteState extends State<newNote> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  Color getRandomColor() {
  List<Color> colors = colorMap.values.toList();
  Random random = Random();
  return colors[random.nextInt(colors.length)];
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, "/listNotes");
      },child: Icon(Icons.list),
      backgroundColor: Colors.blueGrey,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("new Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical:20.0, horizontal: 8),
          child: Center(
            child: Column(
              children: [
                  TextField(
                    cursorColor: Colors.blueGrey,
                    keyboardType: TextInputType.multiline,
                   maxLines: null,
                  controller: titleController,
                 decoration: InputDecoration(
                  
                    hintText: "note title",
                     hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Set the border radius
                        ), focusedBorder: OutlineInputBorder(
                          
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blueGrey), // Custom border color when focused
                          ),
                        filled: false,
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical:12.0),
                   child: TextField(
                    cursorColor: Colors.blueGrey,
                     minLines: 4,
                    keyboardType: TextInputType.multiline,
                   maxLines: null,
                    controller: contentController,
                   decoration: InputDecoration(
                      hintText: "note content",
                       hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            
                            borderRadius:
                                BorderRadius.circular(10.0), // Set the border radius
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blueGrey), // Custom border color when focused
                          ),
                          filled: false,
                    ),
                               ),
                 ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                onPressed: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final userId = currentUser?.uid;
                  if (userId != null) {
              final note = Note(
                title: titleController.text.toUpperCase(),
                content: contentController.text,
                color: getRandomColor(),
                userId: userId,
              );
              if (titleController.text.isEmpty || contentController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Empty field"),
                      content: Text("Please fill  every field"),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                          ),
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                await createNote(note);
                Navigator.pushNamed(context, "/listNotes");
                titleController.text = "";
                contentController.text = "";
              }
            }
          },
          child: Text("Create new note"),
        ),
                Padding(padding: EdgeInsets.symmetric(vertical: 12,horizontal: 142),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                  onPressed: (){
                  Navigator.pushNamed(context, "/listNotes");
                },
                
                 child: Text("Cancel")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  
   Future createNote(Note note) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (userId != null) {
      final docNote = FirebaseFirestore.instance.collection("notes").doc();
      note.id = docNote.id;
      note.userId = userId; // Insert the user ID into the note object
      final json = note.toJson();
      await docNote.set(json);
    }
  }

}
/** Future createNote(Note note) async{
    final docNote = FirebaseFirestore.instance.collection("notes").doc();
    note.id = docNote.id;
    final json = note.toJson();
    await docNote.set(json);
  }*/