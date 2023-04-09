import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oua_app_jam_project/logic/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OUA App',
      home: Auth(),
    );
  }
}
