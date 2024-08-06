import 'package:chatin_dong/features/authentication/data/models/user_model.dart';
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
  }

  Future<UserModel> authLogin({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final DocumentSnapshot doc = await _firestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();
    return UserModel.fromJson(doc.data()! as Map<String, dynamic>);
  }

  Future<void> authSignOut() async {
    await _firebaseAuth.signOut();
  }
}
