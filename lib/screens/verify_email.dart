import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/utilities/dialogs/error_dialog.dart';
import 'package:afyaexpress/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPaasword extends StatefulWidget {
  const ForgotPaasword({Key? key}) : super(key: key);

  @override
  State<ForgotPaasword> createState() => _ForgotPaaswordState();
}

class _ForgotPaaswordState extends State<ForgotPaasword> {
  late final TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            emailController.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.',
            );
          }
        }
      },*/
        Scaffold(
      backgroundColor: IndexPage.primaryBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 25),
              /*const Text(
                'Please input your email address to reset\n your password. A reset link will be sent to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: IndexPage.primaryDark,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 25),*/
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: IndexPage.primaryDanger),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: IndexPage.primaryMuted),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IndexPage.primaryDark, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Send email Verification ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Navigate back to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IndexPage.primaryDark, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
