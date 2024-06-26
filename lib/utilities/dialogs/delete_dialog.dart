import 'package:flutter/material.dart';
import '/extensions/buildcontext/loc.dart';
import '/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Delete',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
