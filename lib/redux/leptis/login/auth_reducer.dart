import 'package:leptisapp/redux/leptis/login/auth_actions.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

// This is a built in method for creating type safe reducers.
// The alternative is building something the way we did with
// the counter reducer -- a simple method.
//
// This is the preferred method and it allows us to create
// modular functions that are safer.
//
//final authReducer = combineTypedReducers<LeptisUser>([
final authReducer = combineReducers<AuthState>([
  // create a reducer binding for each possible reducer--
  // generally thered be one for each possible action a user
  // will take.
  // We'll pass in what a method, which takes a piece of
  // application state and an action.
  // In this case, auth methods take a user as the piece
  // of state
  //
  new TypedReducer<AuthState, LogInAction>(_logIn),
  new TypedReducer<AuthState, LogInSuccessfulAction>(_logInSuccessful),
  new TypedReducer<AuthState, LogInFailAction>(_logInFail),
  new TypedReducer<AuthState, LogOutSuccessfulAction>(_logOut),
]);

// Create the actual reducer methods:
//
// this is dispatched from the LogIn middleware,
// That middleware passes in the user and the action.
// All the reducer needs to do is replace the slice of state
// That handles user.
//
// *NB -- We haven't actually added a user to the state yet.
AuthState _logIn(AuthState state, LogInAction action) {
  print("authReducer._logIn - Start");
  return AuthState();
}

AuthState _logInSuccessful(AuthState state, LogInSuccessfulAction action) {
  Logger('AuthReducer').fine("authReducer._logInSuccessful - Start");

  return AuthState(
    status: AuthStatus.authenticated,
    currentUser: action.user
  );
}

AuthState _logInFail(AuthState state, LogInFailAction action) {
  Logger('AuthReducer').fine("authReducer._logInFail - Start");

  return AuthState(
    status: AuthStatus.fail,
    msg: action.error
  );
}

// This will just replace the user slice of state with null.
AuthState _logOut(AuthState state, LogOutSuccessfulAction action) {
  Logger('AuthReducer').fine("authReducer._logOut - Start");

  return AuthState(
    status: AuthStatus.no_authenticated,
  );
}