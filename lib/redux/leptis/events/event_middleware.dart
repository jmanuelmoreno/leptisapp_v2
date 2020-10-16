import 'dart:async';
import 'package:flutter/services.dart';
import 'package:leptisapp/assets.dart';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:leptisapp/redux/leptis/events/event_actions.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

import 'package:leptisapp/redux/app/app_state.dart';

class EventMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('EventMiddleware');

  EventMiddleware(this.bundle);
  final AssetBundle bundle;

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine("EventMiddleware.call - Start");

    next(action);

    if (action is FetchEventAction) {
      await _fetchEvents(store.state, next);
    } else if (action is RefreshEventAction) {
      await _fetchEvents(store.state, next);
    }
  }

  Future<Null> _fetchEvents(AppState state, NextDispatcher next) async {
    log.fine("EventMiddleware._fetchEvents - Start");

    next(RequestingEventAction());

    try {
      var eventsJson = await bundle.loadString(OtherAssets.preloadedEvents);
      var events = Event.parseAll(eventsJson);

      next(ReceivedEventAction(
        allEvents: events
      ));
    } catch (e) {
      log.severe("EventMiddleware._fetchEvents - Error: ${e.toString()}");
      next(ErrorLoadingEventAction());
    }
  }
}
