import 'package:afyaexpress/screens/appointment.dart';
import 'package:afyaexpress/screens/home.dart';
import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/screens/login.dart';
import 'package:afyaexpress/screens/register.dart';
import 'package:afyaexpress/screens/reset_password.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile.dart';
import 'package:afyaexpress/views/home/doctor_view.dart';
import 'package:afyaexpress/views/home/patient_view.dart';
import 'package:afyaexpress/views/home/profile/doctor_profile_view.dart';
import 'package:afyaexpress/views/home/profile/patient_profile_view.dart';
import 'package:afyaexpress/views/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import '/helpers/loading/loading_screen.dart';
import 'services/auth/bloc/auth_bloc.dart';
import 'services/auth/bloc/auth_event.dart';
import 'services/auth/bloc/auth_state.dart';
import 'services/auth/firebase_auth_provider.dart';
import 'views/forgot_password_view.dart';
import 'views/login_view.dart';
import 'views/index_view.dart';
import 'views/home/home_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';

//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // supportedLocales: AppLocalizations.supportedLocales,
      //localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Afya Express',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const Homepage(),
      ),
      routes: {
        //createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        '/login': (context) => const LoginView(),
        '/index': (context) => const IndexView(),
        '/appointment': (context) => const Appointment()
        // '/otp': (context) => const OTPView(verificationId: '',),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedInAsMedic) {
          return const HomePage();
        } else if (state is AuthStateLoggedInAsPatient) {
          return const HomePage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return IndexPage();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPaasword();
        } else if (state is AuthStateRegistering) {
          return const Register();
        } else if (state is AuthStateNavigateToLogin) {
          return const LoginScreen();
        } else if (state is AuthStateViewDoctorProfile) {
          return const DoctorProfileView();
        } else if (state is AuthStateViewPatientProfile) {
          return const PatientProfileView();
        }
        //else if (State is AuthStateCodeSent) {
        // return const OTPView();
        //  }
        else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
