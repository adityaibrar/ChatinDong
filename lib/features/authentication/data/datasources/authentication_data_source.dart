import 'dart:developer';

import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource(this._firebaseAuth, this._firestore);

  Future<UserModel> authRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _firestore.collection("users").doc(user.uid).set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('Password terlalu pendek');
      } else if (e.code == 'email-already-in-use') {
        throw ('Email Sudah Digunakan');
      } else {
        throw Exception('Terjadi Kesalahan ${e.message}');
      }
    }
  }

  Future<UserModel> authLogin({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid ?? '')
          .get();

      if (!doc.exists) {
        throw ('Pengguna tidak ditemukan, Silahkan registrasi terlebih dahulu!');
      }
      log(doc.data().toString());
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw ('Pengguna tidak ditemukan');
      }
      return UserModel.fromJson(data);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password yang anda gunakan salah');
      } else if (e.code == 'user-not-found') {
        throw Exception(
            'Pengguna tidak ditemukan, Silahkan registrasi terlebih dahulu');
      } else {
        print(e.message);
        throw Exception('Terjadi Kesalahan angjay${e.message}');
      }
    }
  }

  Future<void> authSignOut() async {
    await _firebaseAuth.signOut();
  }
}
