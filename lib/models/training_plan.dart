import 'package:wos/models/workout.dart';

enum TrainingType {
  forza,
  ipertrofia,
  resistenzaMuscolare,
  funzionale,
  perditaPeso,
  riabilitazione,
  sportSpecifico,
  principianti,
  avanzato,
  cardio,
  misto,
}

class TrainingPlan {
  final String id;
  final String userId;
  final String name;
  final DateTime assignedDate;
  final TrainingType trainingType;
  final List<Workout> workouts;

  TrainingPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.assignedDate,
    required this.trainingType,
    required this.workouts,
  });

  // Metodo per convertire in JSON (per salvataggio su Firebase)
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'assignedDate': assignedDate.toIso8601String(),
    'trainingType': trainingType.name,
    'workouts': workouts.map((w) => w.toJson()).toList(),
  };

  // Metodo per creare da JSON
  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      assignedDate: DateTime.parse(json['assignedDate']),
      trainingType: TrainingType.values.firstWhere((e) => e.name == json['trainingType']),
      workouts: (json['workouts'] as List).map((w) => Workout.fromJson(w)).toList(),
    );
  }
}
