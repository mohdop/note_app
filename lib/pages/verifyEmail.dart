import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/utils.dart';
import 'package:note_taking/pages/listeNotes.dart';


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();
    }
  }

  Future sendVerificationEmail() async{
    try {
      final user= FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification(); 
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
    ? Notes()
    :Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
    );
}