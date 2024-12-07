import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wos/blocs/exercise/exercise_event.dart';
import 'package:wos/blocs/exercise/exercise_repository.dart';
import 'package:wos/blocs/exercise/exercise_state.dart';

class ExerciseTypeBloc extends Bloc<ExerciseTypeEvent, ExerciseTypeState> {
  final ExerciseTypeRepository repository;

  ExerciseTypeBloc({required this.repository}) : super(ExerciseTypeInitial()) {
    on<FetchExerciseTypes>(_onFetchExerciseTypes);
  }

  Future<void> _onFetchExerciseTypes(
      FetchExerciseTypes event, Emitter<ExerciseTypeState> emit) async {
    emit(ExerciseTypeLoading());
    try {
      final exerciseTypes = await repository.fetchExerciseTypes();
      emit(ExerciseTypeLoaded(exerciseTypes));
    } catch (e) {
      emit(ExerciseTypeError(e.toString()));
    }
  }
}
