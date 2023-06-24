import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/pages/listeNotes.dart';
import 'package:note_taking/pages/login.dart';
import 'package:note_taking/pages/noteTake.dart';
import 'package:note_taking/pages/signUp.dart';
import 'package:note_taking/pages/voir_note.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
    theme:ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: SignUp(),
    initialRoute: "",
    routes: {
      "/takeNote": (context) => newNote(),
      "/listNotes":(context) =>  Notes(),
      "/voirNote":(context) => voirNote(),
      "/connexion":(context)=> Login(),
      "/inscription":(context) => SignUp(),
      
    },
  ));
}


class NoteTake extends StatefulWidget {
  const NoteTake({super.key});

  @override
  State<NoteTake> createState() => _NoteTakeState();
}

class _NoteTakeState extends State<NoteTake> {
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:   StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Notes();
          }else{
            return Login();
          }
        }
      ),
    );
  }
}

/**Scaffold(
      body:   StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Notes();
          }else{
            return Login();
          }
        }
      ),
    ); */