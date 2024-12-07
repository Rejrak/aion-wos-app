// app.dart
import 'package:flutter/material.dart';
import 'package:wos/screens/auth_screen.dart';
import 'package:wos/screens/training_plan_list_screen.dart';

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      theme: ThemeData(
        // primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => AuthScreen(),
        '/trainingPlans': (context) => TrainingPlansListScreen(),
      },
    );
  }
}
