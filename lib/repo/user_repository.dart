import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Check if user already exists ─────────────────────
  Future<bool> userExists(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists;
  }

  // ─── Save new user to Firestore ────────────────────────
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // ─── Update user phone ──────────────────────────────────
  Future<void> updatePhone(String uid, String phone) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'phone': phone}, SetOptions(merge: true));
  }

  // ─── Update user name ───────────────────────────────────
  Future<void> updateName(String uid, String name) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set({'name': name}, SetOptions(merge: true));
  }

  // ─── Get user data from Firestore ──────────────────────
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }
}
