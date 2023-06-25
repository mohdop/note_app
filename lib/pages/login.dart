import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/utils.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 158.0,left: 12,right: 12),
                    child:Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage("assets/images/note.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 25),
              child: Stack(
                children: [
            // Add a positioned backdrop filter to blur the background image
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 211, 211, 211),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  
                  controller: mailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (email) => 
                                    email != null && !EmailValidator.validate(email)
                                    ?'Please enter a valide Email'
                                    :null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) => value != null && value.length <6
                                    ?'password must be at least six characters long'
                                    :null,
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: signIn,
                    child: Text('Sign In',style: TextStyle(fontSize: 20)),
                    style: ButtonStyle(
                     side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  
                  children: [
                    Text("Click here if you've",style: TextStyle(fontSize: 14.5)),
                    TextButton(onPressed: () {
                      Navigator.pushNamed(context, "/password");
                    }, child: Text("Forgotten your Password",style: TextStyle(fontSize: 14.5))),
                  ],
                ),
              ],
            ),
                ],
              ),
            ),
          ),
          
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left:68.0),
                  child: Center(
                    child: Row(
                      children: [
                        Text("Don't have an account?",style: TextStyle(fontSize: 18)),
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, "/inscription");
                        }, child: Text("sign up",style: TextStyle(fontSize: 18)),
                        
                        )
                      ],
                    ),
                  ),
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
 Future signIn() async {
  final isValid = formKey.currentState!.validate();
  if (!isValid) return; // Check if form is not valid, then return early
  
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailController.text.trim(),
      password: passwordController.text.trim(),
    );
    Navigator.pushReplacementNamed(context, '/listNotes');
  }on FirebaseAuthException catch (e) {
    print('Sign-in error: $e');
    Utils.showSnackBar(e.message);
  }
}


}