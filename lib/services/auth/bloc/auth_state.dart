import 'package:flutter/foundation.dart' show immutable;
import '/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

/*class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}*/

class AuthStateLoggedInAsMedic extends AuthState {
  final AuthUser user;
  const AuthStateLoggedInAsMedic({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedInAsPatient extends AuthState {
  final AuthUser user;
  const AuthStateLoggedInAsPatient({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNavigateToLogin extends AuthState with EquatableMixin {
  const AuthStateNavigateToLogin({
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [isLoading];
}

// New states for phone authentication
class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateError extends AuthState {
  final Exception exception;
  const AuthStateError({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateCodeSent extends AuthState {
  final String verificationId;
  const AuthStateCodeSent(
      {required this.verificationId, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateCodeAutoRetrievalTimeout extends AuthState {
  final String verificationId;
  const AuthStateCodeAutoRetrievalTimeout(
      {required this.verificationId, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateGoogleSignIn extends AuthState {
  final bool isLoading;

  const AuthStateGoogleSignIn({required this.isLoading})
      : super(isLoading: isLoading);

  @override
  List<Object?> get props => [isLoading];
}

//view doctor profile
class AuthStateViewDoctorProfile extends AuthState with EquatableMixin {
  const AuthStateViewDoctorProfile({
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [isLoading];
}

//view patient profile
class AuthStateViewPatientProfile extends AuthState with EquatableMixin {
  const AuthStateViewPatientProfile({
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [isLoading];
}
