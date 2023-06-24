import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/utils.dart';

class password extends StatefulWidget {
  const password({super.key});

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:28.0),
            child: Column(children: [
              SizedBox(height: 250,),
              Text("Enter your email To retrieve password",style: TextStyle(fontSize: 20,color: Colors.teal[700],fontWeight: FontWeight.bold),maxLines: 4,),
              SizedBox(height: 25,),
              TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (email) => 
                                  email != null && !EmailValidator.validate(email)
                                  ?'Please enter a valide Email'
                                  :null,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),SizedBox(height: 25,),
                ElevatedButton(
                  onPressed: resetPassword,
                  child: Text('Reset password',style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
  Future resetPassword() async{
    try {
      await FirebaseAuth.instance
    .sendPasswordResetEmail(email: emailController.text.trim());
   Utils.showSnackBar("Password reset email sent"); 
   Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e); 
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}