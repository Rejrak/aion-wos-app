import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart'; // For hashing the password
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wos/models/training_plan.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String userId, String password) async {
    try {
      // Hash the password for security
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Save the user data
      await _firestore.collection('users').doc(userId).set({
        'password': hashedPassword,
      });

      print("User registered successfully!");
    } catch (e) {
      throw Exception("Failed to register user: $e");
    }
  }

  Future<bool> authenticateUser(String userId, String password) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc['password'] == hashedPassword) {
        print("User authenticated successfully!");
        return true;
      } else {
        print("Invalid user ID or password.");
        return false;
      }
    } catch (e) {
      throw Exception("Failed to authenticate user: $e");
    }
  }

  Future<void> saveTrainingPlanForUser(String userId, TrainingPlan plan) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainingPlans')
          .add(plan.toJson());

      print("TrainingPlan saved for user: $userId");
    } catch (e) {
      throw Exception("Failed to save training plan: $e");
    }

  }


  Future<void> saveUserCredentials(String userId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('password', password);
  }


  Future<List<TrainingPlan>> getTrainingPlansForUser(String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('trainingPlans')
          .get();

      return snapshot.docs.map((doc) => TrainingPlan.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Failed to fetch training plans: $e");
    }
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'password': prefs.getString('password'),
    };
  }

  Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('password');
  }



}
