// main.dart (updated)
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:wos/utils/init_exercise_type.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const String apiKeyGemini = "AIzaSyBblsFPgtDfu0uDD98fiK9HRymWIuyZbfg";
  Gemini.init(apiKey: apiKeyGemini);

  runApp(MyApp());

}