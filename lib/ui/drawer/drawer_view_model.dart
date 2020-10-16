import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/login/auth_actions.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:leptisapp/ui/login/login_form_page.dart';
import 'package:leptisapp/ui/main_page.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class DrawerViewModel {
  DrawerViewModel({
    @required this.status,
    @required this.currentUser,
    this.authOptions,
  });

  final AuthStatus status;
  final LeptisUser currentUser;
  final List<Widget> authOptions;

  static DrawerViewModel fromStore(
    Store<AppState> store,
    BuildContext context,
  ) {
    return DrawerViewModel(
      status: store.state.authState.status,
      currentUser: store.state.authState.currentUser,
      authOptions: (store.state.authState.status == AuthStatus.authenticated) ?
        <Widget>[
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, MainPage.routeName);
              store.dispatch(new LogOutAction());
            },
          )
        ]
      : <Widget>[
        ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Intranet Leptis'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new LoginPage(),
                fullscreenDialog: true,
              ));
            }
        )
      ]
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawerViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          currentUser == other.currentUser;

  @override
  int get hashCode =>
      status.hashCode ^ currentUser.hashCode;
}
