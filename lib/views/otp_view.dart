import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPView extends StatefulWidget {
  const OTPView({
    super.key,
    required String verificationId,
  });

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  late final TextEditingController _otpController;
  late String verificationId;

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateError) {
            await showErrorDialog(
                context, 'Error occurred: ${state.exception}');
          } else if (state is AuthStateCodeSent) {
            verificationId = state.verificationId;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("OTP"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "Enter the OTP",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    final otp = _otpController.text.trim();

                    context.read<AuthBloc>().add(AuthEventSubmitOTP(
                        verificationId: verificationId, smsCode: otp));
                  },
                  child: const Text("Verify Phone Number"))
            ],
          ),
        ));
  }
}
