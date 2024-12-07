// blocs/training_plan_state.dart
import 'package:equatable/equatable.dart';

abstract class TrainingPlanState extends Equatable {
  const TrainingPlanState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken.
class TrainingPlanInitial extends TrainingPlanState {}

/// State for when the training plans are being loaded.
class TrainingPlansLoading extends TrainingPlanState {}