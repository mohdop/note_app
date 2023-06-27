import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/note.dart';
import '../noNote.dart';

 class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool isDone=false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.pushNamed(context, "/takeNote");
        },child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.orange[300],
        ),
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/connexion');
            }, icon: Icon(Icons.logout,color: Colors.orange[300],)),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("My notes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.orange[300]),),
        ) ,
        body: StreamBuilder<List<Note>>(
        stream: readUserNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final notes = snapshot.data!;
            if (notes.isEmpty) {
              return noNote();
            } else {
              return ListView(
                children: notes.map(buildnotes).toList(),
              );
            }
          } else {
            // Check internet connectivity here
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Text("You're not connected to the internet");
            }
          }
        },
      ),
      ),
    );
  }


  Stream<List<Note>> readNotes() => FirebaseFirestore.instance
      .collection('notes')
      .snapshots()
      .map((snapshot)=> 
      snapshot.docs.map((doc) => Note.fromJson(doc.data()) ).toList());

 Stream<List<Note>> readUserNotes() {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userId = currentUser?.uid;

  if (userId != null) {
    return FirebaseFirestore.instance
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
  }

  return Stream.value([]); // Return an empty stream if the user is not logged in
}


   Widget buildnotes(Note note) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/voirNote", arguments: {
          'title': note.title,
          'content': note.content,
        });
      },
      child: Stack(
        children: [
          Container(
          
          decoration: BoxDecoration(
             boxShadow: [
        BoxShadow(
          color: note.color.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
          ],
            color: note.color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ${note.title}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text( 
                    "${note.content}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 148.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Warning"),
                              content: Text("Do you want to delete this note?"),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blueGrey),
                                  ),
                                  child: Text("Delete"),
                                  onPressed: () {
                                    final docUser = FirebaseFirestore.instance
                                        .collection("notes")
                                        .doc(note.id);
                                    docUser.delete();
                                    Navigator.pushNamed(context, "/listNotes");
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blueGrey),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                      color: Color.fromARGB(255, 200, 200, 200),
                    ),
                    IconButton(
                      onPressed: () =>
                          _showEditDialog(note.id, note.title, note.content),
                      icon: Icon(Icons.edit, color: const Color.fromARGB(255, 200, 200, 200)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ]
      ),
    ),
  );
}


    void _showEditDialog(String id, String initialTitle, String initialContent) {
  _titleController.text = initialTitle;
  _contentController.text = initialContent;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                 keyboardType: TextInputType.multiline,
                 maxLines: null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
            ),
            child: Text('Save',style: TextStyle(color: Colors.white),),
            onPressed: () {
              // Perform the update logic here using the entered values
              final docNote = FirebaseFirestore.instance
                  .collection("notes")
                  .doc(id);
              docNote.update({
                "title": _titleController.text.toUpperCase(),
                "content": _contentController.text,
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}


Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}