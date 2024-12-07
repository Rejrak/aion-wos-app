import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises; // Lista di oggetti Exercise

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
  });

  // Metodo per convertire l'oggetto in JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  // Metodo per creare l'oggetto da JSON
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}
