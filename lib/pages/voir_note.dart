import 'package:flutter/material.dart';

class voirNote extends StatefulWidget {
  const voirNote({super.key});

  @override
  State<voirNote> createState() => _voirNoteState();
}

class _voirNoteState extends State<voirNote> {
  @override
  Widget build(BuildContext context) {
    // Récupérer les arguments passés via Navigator
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extraire le titre et le contenu de la note
    final String title = arguments['title'];
    final String content = arguments['content'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
