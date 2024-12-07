import 'package:flutter/material.dart';
import 'package:wos/models/exercise.dart';
import 'package:wos/models/training_plan.dart';

class TrainingTypeSearchDropdown extends StatefulWidget {
  final TrainingType selectedType;
  final Function(TrainingType) onChanged;

  const TrainingTypeSearchDropdown({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TrainingTypeSearchDropdownState createState() =>
      _TrainingTypeSearchDropdownState();
}

class _TrainingTypeSearchDropdownState extends State<TrainingTypeSearchDropdown> {
  late List<TrainingType> _filteredTypes;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredTypes = TrainingType.values; // Mostra tutto inizialmente
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearchDialog() async {
    final selectedType = await showDialog<TrainingType>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Training Type',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _filteredTypes = TrainingType.values
                        .where((type) =>
                        type.name.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: _filteredTypes.length,
                  itemBuilder: (context, index) {
                    final type = _filteredTypes[index];
                    return ListTile(
                      title: Text(type.name),
                      onTap: () => Navigator.of(context).pop(type),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedType != null) {
      widget.onChanged(selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openSearchDialog,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Training Type',
          border: OutlineInputBorder(),
        ),
        child: Text(widget.selectedType.name),
      ),
    );
  }
}


class ExerciseTypeSearchDropdown extends StatefulWidget {
  final ExerciseType? selectedExerciseType;
  final List<ExerciseType> exerciseTypes;
  final Function(ExerciseType) onChanged;

  const ExerciseTypeSearchDropdown({
    Key? key,
    required this.selectedExerciseType,
    required this.exerciseTypes,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ExerciseTypeSearchDropdownState createState() =>
      _ExerciseTypeSearchDropdownState();
}

class _ExerciseTypeSearchDropdownState
    extends State<ExerciseTypeSearchDropdown> {
  late List<ExerciseType> _filteredExerciseTypes;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredExerciseTypes = widget.exerciseTypes;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearchDialog() async {
    final selectedType = await showDialog<ExerciseType>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Exercise Type',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _filteredExerciseTypes = widget.exerciseTypes
                        .where((type) => type.name
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: _filteredExerciseTypes.length,
                  itemBuilder: (context, index) {
                    final type = _filteredExerciseTypes[index];
                    return ListTile(
                      title: Text(type.name),
                      subtitle: Text('Muscle group: ${type.muscleGroup}'),
                      onTap: () => Navigator.of(context).pop(type),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedType != null) {
      widget.onChanged(selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openSearchDialog,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Exercise Type',
          border: OutlineInputBorder(),
        ),
        child: Text(
          widget.selectedExerciseType?.name ?? 'Select an Exercise Type',
        ),
      ),
    );
  }
}
