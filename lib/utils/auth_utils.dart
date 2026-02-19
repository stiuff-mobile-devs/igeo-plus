import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igeo/models/user.dart';

class AuthUtils {
  final auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthUtils();

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      return googleUser != null
          ? await _signIn(googleUser)
          : false;
    } catch (e) {
      debugPrint("Error on sign in with google: $e");
      return false;
    }
  }

  // Future<bool> signInSilently() async {
  //   try {
  //     final googleUser = await googleSignIn.signInSilently();
  //     return googleUser != null
  //         ? await _signIn(googleUser)
  //         : false;
  //   } catch (e) {
  //     debugPrint("Error on sign in silently with google: $e");
  //     return false;
  //   }
  // }

  Future<bool> _signIn(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      User? user = getFirebaseAuthUser();
      if (user != null) {
        await _saveUser(user);
      }
      debugPrint("Usuário logado");
      return true;
    } catch (e) {
      debugPrint("ERRO ao logar: $e");
      return false;
    }
  }

  signOut() async {
    try {
      await auth.signOut();
      googleSignIn.disconnect();
      debugPrint('Deslogado');
    } catch (e) {
      debugPrint("ERRO deslogando:\n$e");
    }
  }

  User? getFirebaseAuthUser() {
    final firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      return User.fromFirebaseUser(firebaseUser);
    }
    return null;
  }

  bool isLoggedIn() {
    return getFirebaseAuthUser() != null;
  }

  _saveUser(User user) async {
    if (await get(user.id) == null) {
      await create(user);
    }
  }

  Future<void> create(User user) async {
    await _firestore.doc("users/${user.id}").set(user.toJson());
  }

  Future<User?> get(String id) async {
    try {
      var doc = await _firestore.doc("users/$id").get();
      if (!doc.exists) return null;
      return User.fromJson(doc.data()!, doc.id);
    } catch (e) {
      return null;
    }
  }
}
