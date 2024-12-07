class ExerciseType {
  final String id;
  final String name;
  final String muscleGroup;

  ExerciseType({
    required this.id,
    required this.name,
    required this.muscleGroup,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'muscleGroup': muscleGroup,
  };

  factory ExerciseType.fromJson(Map<String, dynamic> json) {
    return ExerciseType(
      id: json['id'],
      name: json['name'],
      muscleGroup: json['muscleGroup'],
    );
  }
}



class Exercise {
  final String id;
  final String exerciseTypeID;
  final String exercizeTypeName; // Nome del tipo di esercizio
  final int series;
  final int repetitions;
  final String? notes;

  Exercise({
    required this.id,
    required this.exerciseTypeID,
    required this.exercizeTypeName, // Aggiunto il nome
    required this.series,
    required this.repetitions,
    this.notes,
  });

  // Metodo per convertire in JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'tipoEsercizioId': exerciseTypeID,
    'tipoEsercizioName': exercizeTypeName, // Aggiunto nel JSON
    'series': series,
    'repetitions': repetitions,
    'notes': notes,
  };

  // Metodo per creare da JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      exerciseTypeID: json['tipoEsercizioId'],
      exercizeTypeName: json['tipoEsercizioName'], // Aggiunto nel costruttore
      series: json['series'],
      repetitions: json['repetitions'],
      notes: json['notes'],
    );
  }
}


