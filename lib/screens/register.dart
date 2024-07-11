import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/screens/login.dart';
import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phone;
  //String? _selectedRole;
  String? phoneNumber;
  String? verificationId;
  bool showOtpField = false;
  String? otp;
  List<bool> _isSelected = [true, false];
  String _selectedRole = 'Doctor';

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

  final _formKey = GlobalKey<FormState>();

  void _sendOtp() async {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber!,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            await saveUserData();
          },
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(
                msg: 'Failed to verify phone number: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              this.verificationId = verificationId;
              showOtpField = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              this.verificationId = verificationId;
              showOtpField = true;
            });
          },
        );
      } catch (error) {
        Fluttertoast.showToast(msg: 'Error occurred: $error');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enter a valid phone number.');
    }
  }

  void _verifyOtp() async {
    if (otp != null && otp!.isNotEmpty && verificationId != null) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp!,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        await saveUserData();
      } catch (error) {
        Fluttertoast.showToast(msg: 'Error occurred: $error');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enter the OTP.');
    }
  }

  Future<void> saveUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic> userMap = {
        'id': currentUser.uid,
        'phone': phoneNumber ?? '',
      };

      /*DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users');
      await userRef.child(currentUser.uid).set(userMap);*/

      Fluttertoast.showToast(msg: 'Successfully registered');
      Navigator.pushReplacementNamed(context, '/index');
    } else {
      Fluttertoast.showToast(msg: 'Error registering user');
    }
  }

  void _signInWithGoogle() {
    // Implement Google sign-in logic here
  }

  void _launchURL() async {
    const url =
        'https://billtechgenics.co.ke'; //Replace with afya express.com when the domain is ready
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Theme.of(context).brightness == Brightness.dark;

    return /*GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },*/
        BlocListener<AuthBloc, AuthState>(
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
        backgroundColor: IndexPage.primaryBlue,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'AfyaExpress',
                      style: TextStyle(
                        color: IndexPage.primaryDanger,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 2),
                    Text(
                      'Afya Mashinani',
                      style: TextStyle(
                        color: IndexPage.primaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Who are you?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 113, 113, 114),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ToggleButtons(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Text('Doctor'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Text('Patient'),
                                ),
                              ],
                              isSelected: _isSelected,
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < _isSelected.length; i++) {
                                    _isSelected[i] = i == index;
                                  }
                                  _selectedRole =
                                      index == 0 ? 'Doctor' : 'Patient';
                                });
                              },
                              color: Colors.white,
                              selectedColor: IndexPage.primaryBlue,
                              fillColor: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            const SizedBox(height: 27),
                            const Text(
                              "Sign Up with email and password",
                              style: TextStyle(
                                color: Color.fromARGB(255, 113, 113, 114),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255,
                                        255)), // Change text color to sky blue
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                                controller: _password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                )),
                            TextButton(
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                final role = _selectedRole;
                                context.read<AuthBloc>().add(
                                      AuthEventRegister(
                                        email,
                                        password,
                                        role,
                                      ),
                                    );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  //color: Color.fromARGB(255, 113, 113, 114),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Sign up with Phone number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: IntlPhoneField(
                                    onChanged: (phone) {
                                      setState(() {
                                        phoneNumber = phone.completeNumber;
                                      });
                                    },
                                    showCountryFlag: false,
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                      hintStyle: TextStyle(
                                        color: IndexPage.primaryMuted,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      ),
                                    ),
                                    initialCountryCode: 'KE',
                                    validator: (value) {
                                      if (value == null ||
                                          value.number.isEmpty) {
                                        return 'Phone number can\'t be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: IndexPage.primaryDark,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: BorderSide(
                                        width: 1,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.blue,
                                      ),
                                    ),
                                    minimumSize: Size(100, 50),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    if (showOtpField) {
                                      _verifyOtp();
                                    } else {
                                      _sendOtp();
                                    }
                                  },
                                  child: Text(
                                    showOtpField ? 'Verify OTP' : 'Send OTP',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (showOtpField) ...[
                              SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Enter OTP',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme
                                      ? Colors.black45
                                      : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: darkTheme
                                        ? Colors.amber.shade400
                                        : Colors.grey,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'OTP can\'t be empty';
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    otp = text;
                                  });
                                },
                              ),
                            ],
                            SizedBox(height: 20),
                            Divider(height: 1, color: Colors.grey),
                            SizedBox(height: 20),
                            Text(
                              'Or',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                /* context.read<AuthBloc>().add(
                                      AuthEventSignInWithGoogle(),
                                    );*/
                                //_signInWithGoogle(); //sign up with google logic goes here
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: IndexPage.primaryDark,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'images/google.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Sign up with Google',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthEventNavigateToLogin());
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );*/
                                // Handle forgot password logic here
                              },
                              child: Text(
                                'Have an account? Login..',
                                style: TextStyle(
                                  color: IndexPage.primaryMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: IndexPage.primaryDark,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _launchURL,
                child: Text(
                  'Need help?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
