import 'package:flutter/material.dart';
//import '/extensions/buildcontext/loc.dart';
import '/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password reset',
    content:
        'We have now sent you a password reset link. Please check your email for more information.',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
