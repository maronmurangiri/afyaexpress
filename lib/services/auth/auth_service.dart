import 'package:afyaexpress/services/auth/auth_provider.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

import '/services/auth/auth_user.dart';
import '/services/auth/firebase_auth_provider.dart';

class AuthService implements auth.AuthProvider {
  final auth.AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String role,
  }) =>
      provider.createUser(
        role: role,
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) =>
      provider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

  @override
  Future<AuthUser> signInWithPhoneCredential(PhoneAuthCredential credential) =>
      provider.signInWithPhoneCredential(credential);

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();
}
