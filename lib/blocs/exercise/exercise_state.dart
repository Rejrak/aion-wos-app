
import 'package:wos/models/exercise.dart';

abstract class ExerciseTypeState {}

class ExerciseTypeInitial extends ExerciseTypeState {}

class ExerciseTypeLoading extends ExerciseTypeState {}

class ExerciseTypeLoaded extends ExerciseTypeState {
  final List<ExerciseType> exerciseTypes;

  ExerciseTypeLoaded(this.exerciseTypes);
}

class ExerciseTypeError extends ExerciseTypeState {
  final String error;

  ExerciseTypeError(this.error);
}
