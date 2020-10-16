import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class LoginFormPageViewModel {
  LoginFormPageViewModel({
    @required this.status,
    @required this.currentUser,
    @required this.msg,
  });

  final AuthStatus status;
  final dynamic msg;
  final LeptisUser currentUser;

  static LoginFormPageViewModel fromStore(
    Store<AppState> store,
  ) {
    //print('LoginFormPageViewModel.fromStore - store.state.authState=${store.state.authState.toString()}');
    return LoginFormPageViewModel(
      status: store.state.authState.status,
      msg: store.state.authState.msg,
      currentUser: store.state.authState.currentUser,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginFormPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          msg == other.msg &&
          currentUser == other.currentUser;

  @override
  int get hashCode =>
      status.hashCode ^ msg.hashCode ^ currentUser.hashCode;
}
