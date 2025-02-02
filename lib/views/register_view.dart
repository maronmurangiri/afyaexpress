import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/services/auth/auth_exceptions.dart';
import '/services/auth/bloc/auth_bloc.dart';
import '/services/auth/bloc/auth_event.dart';
import '/services/auth/bloc/auth_state.dart';
import '/utilities/dialogs/error_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phone;
  String? _selectedRole;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'The password is weak',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'The email is already in use',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'An error occurred',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email',
            );
          } else if (state is AuthStateCodeSent) {
            // Navigate to OTP view upon successful OTP sending
            Navigator.of(context).pushNamed('/otp');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  hint: Text('Select Role'),
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: <String>['Patient', 'Medic']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  _selectedRole != null
                      ? 'Selected: $_selectedRole'
                      : 'No role selected',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                const Text('Enter your email and password'),
                TextFormField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // hintText: 'Email',
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFF1CD0D0)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    //hintText: 'Password',
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFF1CD0D0)),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          final role = _selectedRole;
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                  role!,
                                ),
                              );
                        },
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
                  ),
                ),
                IntlPhoneField(
                  controller: _phone,
                  showCountryFlag: false,
                  dropdownIcon: Icon(
                    Icons.arrow_drop_down,
                    color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  initialCountryCode: 'KE',
                ),
                Center(
                    child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        //'+254' + phoneNumber.substring(1)
                        final phone = '+254${_phone.text.substring(1)}';
                        //const phone = '0700606978';
                        context.read<AuthBloc>().add(AuthEventVerifyPhoneNumber(
                            phoneNumber: phone, context: context));
                      },
                      child: const Text(
                        'Send OTP',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthEventSignInWithGoogle(),
                            );
                      },
                      child: const Text(
                        'Sign in with google',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      child: const Text(
                        'Account already registered',
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
