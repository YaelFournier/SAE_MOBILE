import 'package:flutter/material.dart';
import 'package:sae_mobile/UI/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ypnakqgcqnzjbrekfrfl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlwbmFrcWdjcW56amJyZWtmcmZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczODUxMDgsImV4cCI6MjA1Mjk2MTEwOH0.MYRbjw8A1O-Y3rttQLHNVBobEKQZPRXBy0QTyYVO98Q',
  );

  runApp( RestO());
}

class RestO extends StatelessWidget {
  const RestO({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Rest'O",
        home: Home()
    );
  }
}
