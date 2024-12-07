import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wos/blocs/training_plan/training_plan_bloc.dart';
import 'package:wos/blocs/training_plan/training_plan_event.dart';
import 'package:wos/blocs/training_plan/training_plan_repository.dart';
import 'package:wos/blocs/training_plan/training_plan_state.dart';
import 'package:wos/models/user_model.dart';
import 'package:wos/screens/workout_list_screen.dart';
import 'create_training_plan_screen.dart';

class TrainingPlansListScreen extends StatelessWidget {
  const TrainingPlansListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = UserSession().userId;

    return Scaffold(
      appBar: AppBar(title: const Text('Training Plans')),
      body: BlocProvider(
        create: (context) =>
        TrainingPlanBloc(repository: TrainingPlanRepository())
          ..add(FetchTrainingPlans(userId!)), // Usa lo userId dalla sessione
        child: BlocBuilder<TrainingPlanBloc, TrainingPlanState>(
          builder: (context, state) {
            if (state is TrainingPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TrainingPlansLoaded) {
              return ListView.builder(
                itemCount: state.plans.length,
                itemBuilder: (context, index) {
                  final plan = state.plans[index];
                  return ListTile(
                    title: Text(plan.name),
                    subtitle: Text(
                        'Assigned: ${plan.assignedDate.toLocal().toString().split(' ')[0]} - Type: ${plan.trainingType.name}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkoutListScreen(trainingPlan: plan),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is TrainingPlanError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('No training plans available.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTrainingPlanScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
