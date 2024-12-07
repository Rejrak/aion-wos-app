class PerformanceEntry {
  final DateTime date;
  final double? weight; // Peso utilizzato
  final Duration? time; // Tempo (ad esempio, plank)
  final int? repetitions; // Ripetizioni completate
  final String? notes; // Note aggiuntive

  PerformanceEntry({
    required this.date,
    this.weight,
    this.time,
    this.repetitions,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weight': weight,
    'time': time?.inSeconds,
    'repetitions': repetitions,
    'notes': notes,
  };

  factory PerformanceEntry.fromJson(Map<String, dynamic> json) {
    return PerformanceEntry(
      date: DateTime.parse(json['date']),
      weight: json['weight'],
      time: json['time'] != null ? Duration(seconds: json['time']) : null,
      repetitions: json['repetitions'],
      notes: json['notes'],
    );
  }
}
