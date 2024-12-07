import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:wos/models/training_plan.dart';

abstract class TrainingPlanEvent {}

class FetchTrainingPlans extends TrainingPlanEvent {
  final String userId;

  FetchTrainingPlans(this.userId);
}

class AddTrainingPlan extends TrainingPlanEvent {
  final String userId;
  final TrainingPlan plan;

  AddTrainingPlan({required this.userId, required this.plan});
}

class DeleteTrainingPlan extends TrainingPlanEvent {
  final String userId;
  final String planName;

  DeleteTrainingPlan({required this.userId, required this.planName});
}

class CreateTrainingPlan extends TrainingPlanEvent {
  final TrainingPlan trainingPlan;

  CreateTrainingPlan(this.trainingPlan);
}