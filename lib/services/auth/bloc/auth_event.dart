import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String role;
  const AuthEventRegister(this.email, this.password, this.role);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventNavigateToLogin extends AuthEvent {
  const AuthEventNavigateToLogin();
}

// Phone authentication events
class AuthEventVerifyPhoneNumber extends AuthEvent {
  final String phoneNumber;
  final BuildContext context;

  const AuthEventVerifyPhoneNumber(
      {required this.phoneNumber, required this.context});

  @override
  List<Object?> get props => [phoneNumber, context];
}

class AuthEventSignInWithPhoneCredential extends AuthEvent {
  final PhoneAuthCredential credential;

  const AuthEventSignInWithPhoneCredential({required this.credential});
}

class AuthEventSubmitOTP extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const AuthEventSubmitOTP(
      {required this.verificationId, required this.smsCode});

  @override
  List<Object?> get props => [verificationId, smsCode];
}

class AuthEventOTPVerified extends AuthEvent {
  const AuthEventOTPVerified();
}

// Define AuthEventShowOTPEntry event
class AuthEventShowOTPEntry extends AuthEvent {
  final String verificationId;

  AuthEventShowOTPEntry({required this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class AuthEventSignInWithGoogle extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthEventViewDoctorProfile extends AuthEvent {
  const AuthEventViewDoctorProfile();
}

class AuthEventViewPatientProfile extends AuthEvent {
  const AuthEventViewPatientProfile();
}
