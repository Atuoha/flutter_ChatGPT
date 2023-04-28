import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/firestore_ref.dart';
import '../models/custom_error.dart';


class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fbauth.FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseAuth, required this.firebaseFirestore});

  Stream<fbauth.User?> get user => firebaseAuth.userChanges();
  var error = 'Error occurred!';

  // sign up
  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      fbauth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirestoreRef.userRef.doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'username': username,
        'email': email,
        'profileImg':
        'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
        'auth_type': 'email/password'
      });
    } on fbauth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          error = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          error = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          error = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          error = 'Network error!';
        } else {
          error = e.code;
        }
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        errorMsg: error,
        code: 'Exception',
        plugin: 'Firebase/Exception',
      );
    }
  }

  // sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fbauth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          error = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          error = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          error = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          error = 'Network error!';
        } else {
          error = e.code;
        }
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        errorMsg: error,
        code: 'Exception',
        plugin: 'Firebase/Exception',
      );
    }
  }

  // google auth
  Future<void> googleAuth() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      final credential = fbauth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final logCredentials =
      await firebaseAuth.signInWithCredential(credential);
      final user = logCredentials.user;

      FirestoreRef.userRef.doc(user!.uid).set({
        'id': user.uid,
        'email': user.email,
        'username': user.displayName,
        'profileImg': user.photoURL,
        'auth_type': 'GoogleAuth',
      });
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        error = 'Google Sign-In was cancelled by the user';
      } else if (e.code == 'network_error') {
        error = 'A network error occurred while signing in';
      } else if (e.code == 'account_exists_with_different_credential') {
        error =
        'the user already has an account with the same email address but with different sign-in credentials';
      } else if (e.code == 'sign_in_failed') {
        error = 'the sign-in process failed for some reason.';
      } else {
        error = 'Google Sign-In Error: $e';
        // handle other error codes
      }
      throw CustomError(
          code: e.code, errorMsg: error, plugin: 'firebase/exception');
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        errorMsg: error,
        plugin: 'firebase_exception/server_error',
      );
    }
  }

  // forgotPassword
  Future<void> forgotPassword({required String email}) async {
    try {
      await fbauth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on fbauth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, errorMsg: e.message!, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        code: 'Exception',
        errorMsg: e.toString(),
        plugin: 'firebase_exception/server_error',
      );
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        errorMsg: e.toString(),
        plugin: 'firebase_exception/server_error',
      );
    }
  }
}