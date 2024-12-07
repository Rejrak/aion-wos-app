// blocs/training_plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wos/blocs/training_plan_state.dart';
import 'training_plan_event.dart';
import '../repositories/training_plan_repository.dart';

class TrainingPlanBloc extends Bloc<TrainingPlanEvent, TrainingPlanState> {
  final TrainingPlanRepository repository;

  TrainingPlanBloc({required this.repository}) : super(TrainingPlanInitial());

}
