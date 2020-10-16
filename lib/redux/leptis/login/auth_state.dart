import 'package:leptisapp/data/models/leptis/leptis_user.dart';

enum AuthStatus {
  no_authenticated,
  authenticated,
  fail,
}

class AuthState {
  final AuthStatus status;
  final dynamic msg;
  final LeptisUser currentUser;

  AuthState({
    this.status,
    this.msg,
    this.currentUser,
  });

  factory AuthState.initial() {
    return AuthState(
      status: null,
      msg: null,
      currentUser: null,
    );
  }

  AuthState copyWith({AuthStatus status, String msg, LeptisUser currentUser}) {
    return new AuthState(
      status: status,
      msg: msg,
      currentUser: currentUser,
    );
  }

  @override
  String toString() {
    return '''AuthState {
      status: $status, 
      msg: $msg,
      currentUser: ${(currentUser!=null)?currentUser.username:null}
    }''';
  }
}