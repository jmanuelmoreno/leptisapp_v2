import 'package:flutter/foundation.dart';
import 'package:leptisapp/data/models/leptis/leptis_user.dart';

class LogInAction {
  LogInAction({ @required this.username, @required this.password});
  final String username;
  final String password;

  @override
  String toString() {
    return 'LogInAction { username: $username, password: $password }';
  }
}

class LogInSuccessfulAction {
  LogInSuccessfulAction({ @required this.user});
  final LeptisUser user;

  @override
  String toString() {
    return 'LogIn{user: $user}';
  }
}

class LogInFailAction {
  LogInFailAction(this.error);
  final dynamic error;

  @override
  String toString() {
    return 'LogIn{ There was an error loggin in: $error}';
  }
}

class LogOutAction {}

class LogOutSuccessfulAction {
  LogOutSuccessfulAction({@required this.user});
  final LeptisUser user;

  @override
  String toString() {
    return 'LogOut{user: $user}';
  }
}