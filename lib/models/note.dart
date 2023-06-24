import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  String id;
  final String title;
  final String content;
  final Color color;
  String userId;
  Note({
    this.id='',
    required this.title,
    required this.content,
    required this.color,
    required this.userId
    
  });
  Map<String, dynamic> toJson() =>{
    'id':id,
    'title':title,
    'content': content,
    'color': color.value,
    'userId':userId
  };
  static Note fromJson( Map<String, dynamic> json)=> Note(
    id: json["id"],
    title :json['title'],
    content:json['content'],
    color: Color(json['color']),
    userId:json['userId']
  );
   
}