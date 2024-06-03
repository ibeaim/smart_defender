import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_defender/remote_page.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL:
        'https://smartdefender-51842-default-rtdb.asia-southeast1.firebasedatabase.app/');

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase if not already done
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Defender',
      theme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.interTextTheme(Typography.whiteCupertino),
          primaryColor: Color(0xFF0A0E21),
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF0A0E21), centerTitle: true)),
      home: RemotePage(),
    );
  }
}
