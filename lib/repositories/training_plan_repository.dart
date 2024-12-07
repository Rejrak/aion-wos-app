
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wos/models/training_plan.dart';

class TrainingPlanRepository {
  final String boxName = 'training_plans';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTrainingPlan(TrainingPlan plan) async {
    try {
      await _firestore.collection('trainingPlans').add(plan.toJson());
    } catch (e) {
      throw Exception("Failed to save training plan: $e");
    }
  }

  Future<List<TrainingPlan>> getTrainingPlans() async {
    try {
      final snapshot = await _firestore.collection('trainingPlans').get();
      return snapshot.docs.map((doc) => TrainingPlan.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Failed to fetch training plans: $e");
    }
  }

}
