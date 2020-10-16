import 'dart:async';

import 'package:flutter/services.dart';
import 'package:leptisapp/data/networking/leptis/leptis_api.dart';
import 'package:leptisapp/data/networking/leptis/weather_api.dart';
import 'package:leptisapp/redux/app/app_reducer.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_middleware.dart';
import 'package:leptisapp/redux/leptis/escort/escort_middleware.dart';
import 'package:leptisapp/redux/leptis/events/event_middleware.dart';
import 'package:leptisapp/redux/leptis/login/auth_middleware.dart';
import 'package:leptisapp/redux/leptis/member/member_middleware.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_middleware.dart';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_middleware.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<Store<AppState>> createStore() async {
  //var tmdbApi = TMDBApi();
  //var finnkinoApi = FinnkinoApi();
  var leptisApi = LeptisApi();
  var weatherApi = WeatherApi();
  var prefs = await SharedPreferences.getInstance();

  return Store(
    appReducer,
    initialState: AppState.initial(),
    distinct: true,
    middleware: [
      AuthMiddleware(leptisApi, prefs),

      //ActorMiddleware(tmdbApi),
      //TheaterMiddleware(rootBundle, prefs),
      //ShowMiddleware(finnkinoApi),
      //EventMiddleware(finnkinoApi),

      EscortMiddleware(rootBundle),
      BookEventMiddleware(bundle: rootBundle, weatherApi: weatherApi),
      MemberMiddleware(leptisApi),
      RegularityMiddleware(leptisApi),
      RegularityHistoryMiddleware(leptisApi),
      EventMiddleware(rootBundle),
    ]
  );
}
