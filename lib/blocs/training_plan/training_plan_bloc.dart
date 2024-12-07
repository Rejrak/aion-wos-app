import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wos/blocs/training_plan/training_plan_event.dart';
import 'package:wos/models/training_plan.dart';
import 'training_plan_repository.dart';
import 'training_plan_state.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class TrainingPlanBloc extends Bloc<TrainingPlanEvent, TrainingPlanState> {
  final TrainingPlanRepository repository;

  TrainingPlanBloc({required this.repository}) : super(TrainingPlanLoading()) {
    on<FetchTrainingPlans>(_onFetchTrainingPlans);

    on<CreateTrainingPlan>((event, emit) async {
      emit(TrainingPlanLoading());
      try {
        await repository.saveTrainingPlan(event.trainingPlan.userId,event.trainingPlan);
        emit(TrainingPlanCreated());
      } catch (e) {
        emit(TrainingPlanError(e.toString()));
      }
    });

    // on<AddTrainingPlan>((event, emit) async {
    //   try {
    //     await repository.saveTrainingPlan(event.userId, event.plan);
    //     final updatedPlans = await repository.fetchTrainingPlans(event.userId);
    //     emit(TrainingPlansLoaded(updatedPlans));
    //   } catch (e) {
    //     emit(TrainingPlanError(e.toString()));
    //   }
    // });

    on<DeleteTrainingPlan>((event, emit) async {
      try {
        await repository.deleteTrainingPlan(event.userId, event.planName);
        final updatedPlans = await repository.fetchTrainingPlans(event.userId);
        emit(TrainingPlansLoaded(updatedPlans));
      } catch (e) {
        emit(TrainingPlanError(e.toString()));
      }
    });

  }

  Future<void> _onFetchTrainingPlans(
      FetchTrainingPlans event, Emitter<TrainingPlanState> emit) async {
    emit(TrainingPlanLoading());
    try {
      final plans = await repository.fetchTrainingPlans(event.userId);
      emit(TrainingPlansLoaded(plans));
    } catch (e) {
      emit(TrainingPlanError(e.toString()));
    }
  }

}