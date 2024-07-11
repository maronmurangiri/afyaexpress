import 'package:afyaexpress/enums/menu_actions.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientView extends StatefulWidget {
  const PatientView({Key? key}) : super(key: key);

  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
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
      listener: (context, state) async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient View'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Welcome to Patient screen"),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventViewPatientProfile(),
                      );
                },
                child: const Text(
                  'Update Profile',
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
