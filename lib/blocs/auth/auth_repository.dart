import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wos/models/user_model.dart';
import 'package:wos/utils/crypto_utils.dart';

class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(User user) async {
    try {
      final hashedUser = User(
        userId: user.userId,
        password: hashPassword(user.password),
      );

      final userRef = _firestore.collection('users').doc(hashedUser.userId);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        throw Exception('User ID already exists');
      }

      await userRef.set(hashedUser.toMap());
    } catch (e) {
      rethrow;
    }
  }


  Future<User?> loginUser(String userId, String password) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final docSnapshot = await userRef.get();

      if (!docSnapshot.exists) {
        throw Exception('User not found');
      }

      final user = User.fromMap(docSnapshot.data()!);

      if (user.password != hashPassword(password)) {
        throw Exception('Invalid password');
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }


}