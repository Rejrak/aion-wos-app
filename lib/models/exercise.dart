import 'package:wos/models/performance_entry.dart';

class Exercise {
  final String name;
  final int series;
  final int repetitions;
  final Duration? restTime;
  final String? notes;
  final List<PerformanceEntry> performanceEntries;

  Exercise({
    required this.name,
    required this.series,
    required this.repetitions,
    this.restTime,
    this.notes,
    required this.performanceEntries,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'series': series,
    'repetitions': repetitions,
    'restTime': restTime?.inSeconds,
    'notes': notes,
    'performanceEntries': performanceEntries.map((p) => p.toJson()).toList(),
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      series: json['series'],
      repetitions: json['repetitions'],
      restTime: json['restTime'] != null ? Duration(seconds: json['restTime']) : null,
      notes: json['notes'],
      performanceEntries: (json['performanceEntries'] as List)
          .map((p) => PerformanceEntry.fromJson(p))
          .toList(),
    );
  }
}
