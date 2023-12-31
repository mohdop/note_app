import 'dart:async';
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
  Timer? timer;
  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3), 
        (_)=>checkEmailVerified(),
      );
    } 
  }
  @override
    dispose(){
      timer?.cancel();
      super.dispose();  
    } 
     Future sendVerificationEmail() async{
    try {
      final user= FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification(); 
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }
    Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }

 
 @override
  Widget build(BuildContext context) => isEmailVerified
    ? Notes()
    :Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.only(top:108.0),
          child: Text("An Email has been sent to you!",style: TextStyle(color:const Color.fromARGB(255, 219, 219, 219) ),),
        ),
      )
    );
}