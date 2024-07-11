import 'package:afyaexpress/screens/home.dart';
import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/screens/mainpage.dart';
import 'package:afyaexpress/screens/register.dart';
import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login.dart';
import 'package:afyaexpress/screens/reset_password.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'Cannot find a user with the entered credentials!',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Wrong credentials',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Authentication error',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add image at the top that occupies the entire width
              Container(
                width: double.infinity,
                height: 200, // Adjust height as needed
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/login.jpeg'), // Replace image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Login section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Color(
                                0xFF1CD0D0)), // Change text color to sky blue
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xFF1CD0D0)),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPaasword()),
                            );*/
                            context.read<AuthBloc>().add(
                                  const AuthEventForgotPassword(),
                                );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF1CD0D0),
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventShouldRegister(),
                            );
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );*/
                        // Handle sign up logic here
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Center-aligned Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF0FCECE), // Set the background color of the button to blue
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email,
                                password,
                              ),
                            );
                        /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to MainScreen
                      );*/
                        // Handle login logic here
                      },
                      child: const Text('Log in',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              // Text below "Healthy as a Service"
              Container(
                color: const Color(0xFF1CD0D0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Health as a Service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'You’ve got no reason to worry,\n'
                      'We are bringing health to your doorstep,\n'
                      'one call at a time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: IndexPage.primaryMuted,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
