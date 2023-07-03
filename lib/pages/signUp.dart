import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/models/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 158.0, left: 12, right: 12),
                  child: Container(
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
                                "Create your account here",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 211, 211, 211),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: emailController,
                                
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: 'Enter your email',
                                   labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    prefixIcon: Icon(Icons.mail_rounded, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (email) => 
                                email != null && !EmailValidator.validate(email)
                                ?'Please enter a valide Email'
                                :null,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: 'Enter your password',
                                  labelStyle: TextStyle(
                                  color: Colors.white,
                                ),prefixIcon: Icon(Icons.lock, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                                ),
                                 autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => value != null && value.length <6
                                ?'password must be at least six characters long'
                                :null,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                               TextFormField(
                                obscureText: true,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  hintText: 'Confirm your password',
                                   labelStyle: TextStyle(
                      color: Colors.white,
                    ),prefixIcon: Icon(Icons.check_circle_outline, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },style: TextStyle(color: Colors.white),
                               ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: signUp,
                                  child: Text('Sign Up',style: TextStyle(fontSize: 20,color: Colors.white)),
                                  style: ButtonStyle(
                                     side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  ),
                                ),
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
                    Text("Already have an account?",style: TextStyle(fontSize: 18),),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, "/connexion");
                    }, child: Text( "sign In",style: TextStyle(fontSize: 18))),
                    
                    
                  ],
                ),
              ),
            )

            ],
          ),
        ),
      ),
    );
  }

 Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return; // Check if form is not valid, then return early

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/NoteTake'); // Navigate to the Notes page
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

}
