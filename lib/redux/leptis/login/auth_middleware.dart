import 'dart:async';

import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/networking/leptis/leptis_api.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/leptis/login/auth_actions.dart';
import 'package:leptisapp/utils/avatar_utils.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('AuthMiddleware');

  static const String kDefaultUsername = 'default_user_name';
  static const String kDefaultUserpassword = 'default_user_password';

  final LeptisApi leptisApi;
  final SharedPreferences preferences;

  AuthMiddleware(this.leptisApi, this.preferences);

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine('AuthMiddleware.call - Start');

    next(action);

    if (action is InitAction) {
      await _init(action, next);
    } else if (action is LogInAction) {
      await _logIn(action, next);
    } else if (action is LogOutAction) {
      await _logOut(action, next);
    }
  }

  Future<Null> _init(InitAction action, NextDispatcher next) async {
    log.fine('AuthMiddleware._init - Start');

    var persistedUsername = preferences.getString(kDefaultUsername);
    var persistedUserpassword = preferences.getString(kDefaultUserpassword);

    try {
      if(persistedUsername != null) {
        String sessionToken = await leptisApi.logIn(persistedUsername, persistedUserpassword);
        log.fine('AuthMiddleware._init - sessionToken=$sessionToken');

        if(sessionToken != null) {
          LeptisUser user = await _buildLeptisUserInfo(sessionToken, persistedUsername, persistedUserpassword);
          log.fine('AuthMiddleware._init - LogIn realizado correctamente.');
          next(new LogInSuccessfulAction(user: user));
        } else {
          log.fine('El Usuario o la Contraseña no son correctos, o no esta dado de alta.');
          next(new LogInFailAction('El Usuario o la Contraseña no son correctos, o no esta dado de alta.'));
        }
      } else {
        log.fine('AuthMiddleware._init - No hay usuario por defecto');
      }
    } catch (error) {
      log.fine('AuthMiddleware._init - Error: ${error.toString()}');
      next(new LogInFailAction(error.toString()));
    }
  }

  Future<Null> _logIn(LogInAction action, NextDispatcher next) async {
    log.fine('AuthMiddleware._logIn - Start');

    try {
      String sessionToken = await leptisApi.logIn(action.username, action.password);
      log.fine('AuthMiddleware._logIn - sessionToken=$sessionToken');

      if( sessionToken != null) {
        LeptisUser user = await _buildLeptisUserInfo(sessionToken, action.username, action.password);

        preferences.setString(kDefaultUsername, user.username);
        preferences.setString(kDefaultUserpassword, user.password);

        log.fine('AuthMiddleware._logIn - LogIn realizado correctamente.');
        next(new LogInSuccessfulAction(user: user));
      } else {
        log.fine('El Usuario o la Contraseña no son correctos, o no esta dado de alta.');
        next(new LogInFailAction('El Usuario o la Contraseña no son correctos, o no esta dado de alta.'));
      }
    } catch (error) {
      log.severe('AuthMiddleware._logIn - Error: ${error.toString()}');
      next(new LogInFailAction(error.toString()));
    }
  }

  Future<Null> _logOut(LogOutAction action, NextDispatcher next) async {
    log.fine('AuthMiddleware._logOut - Start');

    try {
      preferences.remove(kDefaultUsername);
      preferences.remove(kDefaultUserpassword);

      log.fine('AuthMiddleware._logOut - Logged out realizado correctamente.');
      next(new LogOutSuccessfulAction(user: null));
    } catch (error) {
      log.severe('AuthMiddleware._logOut - Error al realizar LogOut: $error');
    }
  }

  Future<LeptisUser> _buildLeptisUserInfo(String sessionToken, String username, String password) async {
    List<Member> members = await leptisApi.getMembers(sessionToken);
    Member member = members.firstWhere((member) => member.username == username);

    LeptisUser user = LeptisUser(
        username: username,
        password: password,
        sessionToken: sessionToken
    );

    if (member != null) {
      user.displayName = '${member.name} ${member.lastname}';
      user.email = member.email;
      user.avatarUrl = getAvatarUrl(
          (member.email != null) ? member.email : "${member.name}@gmail.com");
      user.rol = member.rol;
    }

    log.fine('AuthMiddleware._buildLeptisUserInfo - Usuario: $user');
    return user;
  }
}
