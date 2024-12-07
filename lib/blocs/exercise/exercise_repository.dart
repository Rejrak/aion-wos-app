import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wos/models/exercise.dart';

class ExerciseTypeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ExerciseType>> fetchExerciseTypes() async {
    final snapshot = await _firestore.collection('exerciseTypes').get();
    return snapshot.docs
        .map((doc) => ExerciseType.fromJson(doc.data()))
        .toList();
  }
}
