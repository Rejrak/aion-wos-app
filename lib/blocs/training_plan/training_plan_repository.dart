import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wos/models/training_plan.dart';
import 'package:dio/dio.dart';


class TrainingPlanRepository {
  final Dio dio = Dio();
  final _firestore = FirebaseFirestore.instance;

  Future<List<TrainingPlan>> fetchTrainingPlans(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('trainingPlans')
        .get();

    return snapshot.docs.map((doc) => TrainingPlan.fromJson(doc.data())).toList();
  }

  Future<void> saveTrainingPlan(String userId, TrainingPlan plan) async {
    final planRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('trainingPlans')
        .doc(plan.name);

    await planRef.set(plan.toJson());
  }

  Future<void> deleteTrainingPlan(String userId, String planName) async {
    final planRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('trainingPlans')
        .doc(planName);

    await planRef.delete();
  }

  Future<TrainingPlan> uploadAndConvertTrainingPlan(String pdfContent) async {

    try {
      final response = await dio.post(
        'https://gemini-ai.com/api/convert-to-training-plan',
        data: {'pdfContent': pdfContent},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return TrainingPlan.fromJson(response.data);
      } else {
        throw Exception('Failed to convert PDF to TrainingPlan: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error while uploading PDF: $e');
    }
  }
}
