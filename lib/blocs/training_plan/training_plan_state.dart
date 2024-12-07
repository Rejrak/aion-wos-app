import 'package:wos/models/training_plan.dart';

abstract class TrainingPlanState {}

class TrainingPlanInitial extends TrainingPlanState {}

class TrainingPlanLoading extends TrainingPlanState {}

class TrainingPlansLoaded extends TrainingPlanState {
  final List<TrainingPlan> plans;
  TrainingPlansLoaded(this.plans);
}

class TrainingPlanError extends TrainingPlanState {
  final String error;
  TrainingPlanError(this.error);
}

class TrainingPlanCreated extends TrainingPlanState {}

class TrainingPlanUploaded extends TrainingPlanState {
  final TrainingPlan newPlan;
  TrainingPlanUploaded(this.newPlan);
}
