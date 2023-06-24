import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            TextField(
              controller: mailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: signIn,
                child: Text('Sign In'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Click here if you've"),
                TextButton(onPressed: () {}, child: Text("Forgotten your Password")),
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
                    Text("Don't have an account?"),
                    TextButton(onPressed: (){}, child: Text("sign up"),
                    
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
 Future signIn() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailController.text.trim(),
      password: passwordController.text.trim(),
    );
    Navigator.pushReplacementNamed(context, '/listNotes');
  } catch (e) {
    print('Sign-in error: $e');
  }
}

}