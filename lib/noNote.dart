import 'package:flutter/material.dart';

Widget noNote() {
  return Center(
    child:Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:98.0),
          child: Image.asset("assets/images/new-note.png",scale: 2,),
        ),
        Text('Create your first note', style: TextStyle(fontSize: 22),)
      ],
    ) ,
  );
}