import 'package:flutter/material.dart';
import '/enums/menu_action.dart';
import '/services/auth/bloc/auth_bloc.dart';
import '/services/auth/bloc/auth_event.dart';
import '/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

//extension Count<T extends Iterable> on Stream<T> {
// Stream<int> get getLength => map((event) => event.length);
//}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          /*IconButton(
            onPressed: () {
              //Navigator.of(context).pushNamed(createRoute);
            },
            //icon: const Icon(Icons.add),
          ),*/
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      // body:
    );
  }
}
