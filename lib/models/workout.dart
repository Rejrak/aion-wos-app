import 'package:wos/models/exercise.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}
