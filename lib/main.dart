import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/utils.dart';
import 'package:note_taking/pages/listeNotes.dart';
import 'package:note_taking/pages/login.dart';
import 'package:note_taking/pages/noteTake.dart';
import 'package:note_taking/pages/password.dart';
import 'package:note_taking/pages/signUp.dart';
import 'package:note_taking/pages/verifyEmail.dart';
import 'package:note_taking/pages/voir_note.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
    scaffoldMessengerKey: Utils.messengerKey,
    theme:ThemeData(primarySwatch: Colors.orange),
    debugShowCheckedModeBanner: false,
    home: Login(),
    initialRoute: "",
    routes: {
      "/takeNote": (context) => newNote(),
      "/listNotes":(context) =>  Notes(),
      "/voirNote":(context) => voirNote(),
      "/connexion":(context)=> Login(),
      "/inscription":(context) => SignUp(),
      "/password":(context) => password(),
      "/NoteTake":(context) => NoteTake()
      
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
            return VerifyEmail();
          }else{
            return Login();
          }
        }
      ),
    );
  }
}

