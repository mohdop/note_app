import 'package:flutter/material.dart';

class AppLocalizationsFr {
  static const Map<String, String> translations = {
    'createAccount': 'Créer un compte',
    'email': 'Email',
    'password': 'Mot de passe',
    'signIn': 'Se connecter',
   'signUp': 'S\'inscrire'
   
    // Add more translations here
  };
}

// Create a function to retrieve the translations
String getTranslation(BuildContext context, String key) {
  return AppLocalizationsFr.translations[key] ?? key;
}
