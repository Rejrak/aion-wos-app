import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:wos/models/exercise.dart';

Future<void> initializeExerciseTypes() async {
  final firestore = FirebaseFirestore.instance;
  final exerciseTypeCollection = firestore.collection('exerciseTypes');
  final uuid = Uuid();

  final exerciseTypes = [
    {"name": "Panca piana", "muscleGroup": "Petto"},
    {"name": "Panca inclinata", "muscleGroup": "Petto"},
    {"name": "Panca declinata", "muscleGroup": "Petto"},
    {"name": "Croci con manubri", "muscleGroup": "Petto"},
    {"name": "Lat machine", "muscleGroup": "Schiena"},
    {"name": "Rematore con bilanciere", "muscleGroup": "Schiena"},
    {"name": "Pull-up", "muscleGroup": "Schiena"},
    {"name": "Deadlift", "muscleGroup": "Schiena"},
    {"name": "Military press", "muscleGroup": "Spalle"},
    {"name": "Alzate laterali", "muscleGroup": "Spalle"},
    {"name": "Alzate frontali", "muscleGroup": "Spalle"},
    {"name": "Shoulder press", "muscleGroup": "Spalle"},
    {"name": "Curl con bilanciere", "muscleGroup": "Bicipiti"},
    {"name": "Hammer curl", "muscleGroup": "Bicipiti"},
    {"name": "Concentration curl", "muscleGroup": "Bicipiti"},
    {"name": "Dip su parallele", "muscleGroup": "Tricipiti"},
    {"name": "Push down con corda", "muscleGroup": "Tricipiti"},
    {"name": "French press", "muscleGroup": "Tricipiti"},
    {"name": "Squat", "muscleGroup": "Gambe"},
    {"name": "Leg press", "muscleGroup": "Gambe"},
    {"name": "Affondi", "muscleGroup": "Gambe"},
    {"name": "Stacchi rumeni", "muscleGroup": "Gambe"},
    {"name": "Crunch", "muscleGroup": "Addominali"},
    {"name": "Russian twist", "muscleGroup": "Addominali"},
    {"name": "Plank", "muscleGroup": "Addominali"},
    {"name": "Leg raises", "muscleGroup": "Addominali"},
    {"name": "Corsa", "muscleGroup": "Cardio"},
    {"name": "Salto con la corda", "muscleGroup": "Cardio"},
    {"name": "Bicicletta", "muscleGroup": "Cardio"},
    {"name": "Vogatore", "muscleGroup": "Cardio"},
    {"name": "Kettlebell swing", "muscleGroup": "Funzionali"},
    {"name": "Burpee", "muscleGroup": "Funzionali"},
    {"name": "Box jump", "muscleGroup": "Funzionali"},
    {"name": "Wall ball", "muscleGroup": "Funzionali"},
  ];

  for (var exercise in exerciseTypes) {
    final exerciseType = ExerciseType(
      id: uuid.v4(),
      name: exercise['name']!,
      muscleGroup: exercise['muscleGroup']!,
    );

    await exerciseTypeCollection.doc(exerciseType.id).set(exerciseType.toJson());
  }

  print("Exercise types initialized successfully!");
}
