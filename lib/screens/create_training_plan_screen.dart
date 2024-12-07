import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:wos/blocs/exercise/exercise_bloc.dart';
import 'package:wos/blocs/exercise/exercise_event.dart';
import 'package:wos/blocs/exercise/exercise_repository.dart';
import 'package:wos/blocs/exercise/exercise_state.dart';
import 'package:wos/blocs/training_plan/training_plan_bloc.dart';
import 'package:wos/blocs/training_plan/training_plan_event.dart';
import 'package:wos/models/exercise.dart';
import 'package:wos/models/training_plan.dart';
import 'package:wos/models/user_model.dart';
import 'package:wos/models/workout.dart';
import 'package:wos/widgets/search_drop_down.dart';

class CreateTrainingPlanScreen extends StatefulWidget {
  const CreateTrainingPlanScreen({Key? key}) : super(key: key);

  @override
  State<CreateTrainingPlanScreen> createState() =>
      _CreateTrainingPlanScreenState();
}

class _CreateTrainingPlanScreenState extends State<CreateTrainingPlanScreen> {
  final ExerciseTypeBloc _exerciseBloc =
  ExerciseTypeBloc(repository: ExerciseTypeRepository());

  final TextEditingController _trainingPlanNameController =
  TextEditingController();
  TrainingType _selectedTrainingType = TrainingType.forza;

  final TextEditingController _workoutNameController = TextEditingController();
  final List<Workout> _workouts = [];

  final List<Exercise> _currentExercises = [];
  final TextEditingController _exerciseSeriesController =
  TextEditingController();
  final TextEditingController _exerciseRepetitionsController =
  TextEditingController();
  final TextEditingController _exerciseRestController =
  TextEditingController();
  String? _selectedExerciseTypeId;
  final userId = UserSession().userId;

  @override
  void initState() {
    super.initState();
    _exerciseBloc.add(FetchExerciseTypes());
  }

  @override
  void dispose() {
    _exerciseBloc.close();
    _trainingPlanNameController.dispose();
    _workoutNameController.dispose();
    _exerciseSeriesController.dispose();
    _exerciseRepetitionsController.dispose();
    _exerciseRestController.dispose();
    super.dispose();
  }

  void _addExerciseToWorkout() {
    if (_selectedExerciseTypeId != null &&
        _exerciseSeriesController.text.isNotEmpty &&
        _exerciseRepetitionsController.text.isNotEmpty) {
      setState(() {
        // Recupera il nome del tipo di esercizio
        final selectedExerciseType = (_exerciseBloc.state as ExerciseTypeLoaded)
            .exerciseTypes
            .firstWhere((type) => type.id == _selectedExerciseTypeId);

        _currentExercises.add(
          Exercise(
            id: const Uuid().v4(),
            exercizeTypeName: selectedExerciseType.name,
            exerciseTypeID: selectedExerciseType.id,
            series: int.parse(_exerciseSeriesController.text),
            repetitions: int.parse(_exerciseRepetitionsController.text),
            notes: _exerciseRestController.text,
          ),
        );

        // Resetta i campi
        _exerciseSeriesController.clear();
        _exerciseRepetitionsController.clear();
        _exerciseRestController.clear();
        _selectedExerciseTypeId = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all exercise fields')),
      );
    }
  }

  void _addWorkout() {
    if (_workoutNameController.text.isNotEmpty && _currentExercises.isNotEmpty) {
      setState(() {
        _workouts.add(
          Workout(
            id: const Uuid().v4(),
            name: _workoutNameController.text,
            exercises: List.from(_currentExercises), // Copia gli esercizi correnti
          ),
        );

        // Resetta i campi
        _workoutNameController.clear();
        _currentExercises.clear(); // Pulisce la lista degli esercizi per il prossimo workout
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a name and at least one exercise')),
      );
    }
  }

  void _saveTrainingPlan() {
    if (_trainingPlanNameController.text.isEmpty || _workouts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final newPlan = TrainingPlan(
      id: const Uuid().v4(),
      userId: userId!,
      name: _trainingPlanNameController.text,
      assignedDate: DateTime.now(),
      trainingType: _selectedTrainingType,
      workouts: _workouts,
    );

    context.read<TrainingPlanBloc>().add(CreateTrainingPlan(newPlan));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Training Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Training Plan Section
              TextField(
                controller: _trainingPlanNameController,
                decoration: const InputDecoration(
                  labelText: 'Training Plan Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TrainingTypeSearchDropdown(
                selectedType: _selectedTrainingType,
                onChanged: (type) {
                  setState(() {
                    _selectedTrainingType = type;
                  });
                },
              ),
              const Divider(height: 16),

              // Workout Section
              TextField(
                controller: _workoutNameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addWorkout,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Exercise Section
              BlocConsumer<ExerciseTypeBloc, ExerciseTypeState>(
                bloc: _exerciseBloc,
                listener: (context, state) {
                  if (state is ExerciseTypeError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ExerciseTypeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExerciseTypeLoaded) {
                    ExerciseType? selectedExerciseType;
                    if(_selectedExerciseTypeId != null) {
                      selectedExerciseType = state.exerciseTypes.firstWhere(
                            (type) => type.id == _selectedExerciseTypeId,
                      );
                    }
                    return ExerciseTypeSearchDropdown(
                      selectedExerciseType: selectedExerciseType,
                      exerciseTypes: state.exerciseTypes,
                      onChanged: (selectedType) {
                        setState(() {
                          _selectedExerciseTypeId = selectedType.id;
                        });
                      },
                    );
                  } else {
                    return const Center(child: Text('No exercise types available.'));
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _exerciseSeriesController,
                decoration: const InputDecoration(
                  labelText: 'Series',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _exerciseRepetitionsController,
                decoration: const InputDecoration(
                  labelText: 'Repetitions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _exerciseRestController,
                decoration: const InputDecoration(
                  labelText: 'Rest (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addExerciseToWorkout,
                child: const Text('Add Exercise'),
              ),
              const Divider(height: 32),

              // Workout and Exercise Preview
              Text(
                'Workouts',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  final workout = _workouts[index];
                  return ExpansionTile(
                    title: Text(workout.name),
                    subtitle: Text('Exercises: ${workout.exercises.length}'),
                    children: workout.exercises.map((exercise) {
                      return ListTile(
                        title: Text(exercise.exercizeTypeName),
                        subtitle: Text(
                            'Series: ${exercise.series}, Repetitions: ${exercise.repetitions}'),
                      );
                    }).toList(),
                  );
                },
              ),
              const Divider(height: 32),
              ElevatedButton(
                onPressed: _saveTrainingPlan,
                child: const Text('Save Training Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO FIXARE VISUALIZZAZIONE WORKOUTS
