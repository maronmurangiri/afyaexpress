import 'package:flutter/material.dart';
//import '/extensions/buildcontext/loc.dart';
import '/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note!',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
