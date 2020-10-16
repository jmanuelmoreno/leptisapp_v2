import 'dart:async';

import 'package:flutter/services.dart';
import 'package:leptisapp/assets.dart';
import 'package:leptisapp/data/models/leptis/escort.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

class EscortMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('EscortMiddleware');

  final AssetBundle bundle;

  EscortMiddleware(this.bundle);

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine("EscortMiddleware.call - Start");

    if (action is InitAction) {
      await _init(action, next);
    } else {
      next(action);
    }
  }

  Future<Null> _init(InitAction action, NextDispatcher next,) async {
    log.fine("EscortMiddleware._init - Start");

    var escortJson = await bundle.loadString(OtherAssets.preloadedEscort);
    var escorts = Escort.parseAll(escortJson);

    next(InitComplete2Action(escorts: escorts));
  }
}
