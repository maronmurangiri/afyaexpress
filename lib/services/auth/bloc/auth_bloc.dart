import 'package:afyaexpress/views/otp_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:afyaexpress/services/auth/auth_provider.dart' as auth;
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(auth.AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    //forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot-password screen
      }

      // user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final role = event.role;
      try {
        await provider.createUser(
          role: role,
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      final role = user?.role;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else if (role == 'Patient') {
        emit(
          AuthStateLoggedInAsPatient(user: user, isLoading: false),
        );
      } else if (role == 'Medic') {
        emit(
          AuthStateLoggedInAsMedic(user: user, isLoading: false),
        );
      } else {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );

        if (role == 'Patient') {
          emit(
            AuthStateLoggedInAsPatient(user: user, isLoading: false),
          );
        } else if (role == 'Medic') {
          emit(
            AuthStateLoggedInAsMedic(user: user, isLoading: false),
          );
        }
      }

      /*emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));*/
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        final role = user.role;

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else if (role == 'Patient') {
          emit(
            AuthStateLoggedInAsPatient(user: user, isLoading: false),
          );
        } else if (role == 'Medic') {
          emit(
            AuthStateLoggedInAsMedic(user: user, isLoading: false),
          );
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );

          if (role == 'Patient') {
            emit(
              AuthStateLoggedInAsPatient(user: user, isLoading: false),
            );
          } else if (role == 'Medic') {
            emit(
              AuthStateLoggedInAsMedic(user: user, isLoading: false),
            );
          }
        }

        //else {
        /*emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));*/
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    //navigate to login
    on<AuthEventNavigateToLogin>((event, emit) async {
      emit(const AuthStateNavigateToLogin(isLoading: false));
    });

    // verify phone number
    on<AuthEventVerifyPhoneNumber>((event, emit) async {
      emit(const AuthStateLoading(isLoading: true));

      try {
        await provider.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            final user = await provider.signInWithPhoneCredential(credential);
            emit(AuthStateLoggedInAsPatient(user: user, isLoading: false));
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(AuthStateError(exception: e, isLoading: false));
          },
          codeSent: (String verificationId, int? resendToken) {
            /*verificationId = verificationId;
            emit(AuthStateCodeSent(
                verificationId: verificationId, isLoading: false));*/
            Navigator.push(
              event.context,
              MaterialPageRoute(
                  builder: (context) =>
                      OTPView(verificationId: verificationId)),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            emit(AuthStateCodeAutoRetrievalTimeout(
                verificationId: verificationId, isLoading: false));
          },
        );
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateError(exception: e, isLoading: false));
        } else {
          // Handle other cases or rethrow if necessary
          throw e;
        }
      }
    });

    // sign in with phone credential
    on<AuthEventSignInWithPhoneCredential>((event, emit) async {
      try {
        final user = await provider.signInWithPhoneCredential(event.credential);
        emit(AuthStateLoggedInAsPatient(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateError(exception: e, isLoading: false));
      }
    });

    // submit OTP
    on<AuthEventSubmitOTP>((event, emit) async {
      emit(const AuthStateLoading(isLoading: true));
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.smsCode,
        );
        final user = await provider.signInWithPhoneCredential(credential);
        emit(AuthStateLoggedInAsPatient(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateError(exception: e, isLoading: false));
      }
    });

    //google sign in
    on<AuthEventSignInWithGoogle>((event, emit) async {
      emit(const AuthStateGoogleSignIn(isLoading: true));
      try {
        final user = await provider.signInWithGoogle();
        emit(AuthStateLoggedInAsPatient(user: user, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateError(exception: e, isLoading: false));
      }
    });

    //view doctor profile
    on<AuthEventViewDoctorProfile>((event, emit) async {
      emit(const AuthStateViewDoctorProfile(isLoading: false));
    });

    //view patient profile
    on<AuthEventViewPatientProfile>((event, emit) async {
      emit(const AuthStateViewPatientProfile(isLoading: false));
    });
  }
}
