import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<void> signOut();
}