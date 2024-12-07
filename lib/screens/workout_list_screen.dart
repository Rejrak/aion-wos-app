import 'package:flutter/material.dart';
import 'package:wos/screens/workout_detail_screen.dart';
import '../models/training_plan.dart';

class WorkoutListScreen extends StatelessWidget {
  final TrainingPlan trainingPlan;

  const WorkoutListScreen({Key? key, required this.trainingPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trainingPlan.name)),
      body: ListView.builder(
        itemCount: trainingPlan.workouts.length,
        itemBuilder: (context, index) {
          final workout = trainingPlan.workouts[index];
          return ListTile(
            title: Text(workout.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutDetailScreen(workout: workout),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
