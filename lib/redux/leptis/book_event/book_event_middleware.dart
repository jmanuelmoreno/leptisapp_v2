import 'dart:async';

import 'package:flutter/services.dart';
import 'package:leptisapp/assets.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/season.dart';
import 'package:leptisapp/data/networking/leptis/weather_api.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_actions.dart';
import 'package:leptisapp/utils/clock.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

class BookEventMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('BookEventMiddleware');

  BookEventMiddleware({this.bundle, this.weatherApi});
  final AssetBundle bundle;
  final WeatherApi weatherApi;

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine('BookEventMiddleware.call - Start');

    next(action);

    /*if (action is InitCompleteAction || action is RefreshBookEventsAction) {
      await _fetchBookEvents(next);
    }*/
    if (action is InitComplete2Action || action is RefreshBookEventsAction) {
      await _fetchBookEvents(action, next);
    } /*else if (action is FetchMapCoverAction) {
      await _buildCoverMap(action, next);
    } else if (action is FetchWeatherAction) {
      await _fetchWeather(action, next);
    }*/
  }

  /*Future<Null> _fetchWeather(FetchWeatherAction action, NextDispatcher next) async {
    log.fine('BookEventMiddleware._fetchWeather - Start');

    BookEvent bookEvent = action.bookEvent;
    if(bookEvent.hasEventDay) {
      next(WeatherUpdatedAction(
          bookEvent: bookEvent, weather: bookEvent.weather));

      try {
        Weather weather = await _getWeather(bookEvent.start);

        next(UpdateWeatherForBookEventAction(
            bookEvent: bookEvent, weather: weather));
        next(ReceivedWeatherAction(bookEvent: bookEvent, weather: weather));
      } catch (e) {
        // We don't need to handle this. If fetching actor avatars
        // fails, we don't care: the UI just simply won't display
        // any actor avatars and falls back to placeholder icons
        // instead.
      }
    }
  }*/

  /*Future<Null> _buildCoverMap(FetchMapCoverAction action, NextDispatcher next) async {
    log.fine('BookEventMiddleware._fetchBookEvents - Start');

    BookEvent bookEvent = action.bookEvent;
    if(bookEvent.hasRouteMap) {
      next(MapCoverUpdatedAction(
          bookEvent, bookEvent.routeMapCoverUrl));

      try {
        var mapCoverUrl = await _getMapCover(bookEvent.routeMapUrl);

        next(UpdateMapCoverForBookEventAction(bookEvent, mapCoverUrl));
        next(ReceivedMapCoverAction(bookEvent, mapCoverUrl));
      } catch (e) {
        // We don't need to handle this. If fetching actor avatars
        // fails, we don't care: the UI just simply won't display
        // any actor avatars and falls back to placeholder icons
        // instead.
      }
    }
  }*/

  Future<Null> _fetchBookEvents(InitComplete2Action action, NextDispatcher next,) async {
    log.fine('BookEventMiddleware._fetchBookEvents - Start');

    next(RequestingBookEventsAction());

    try {
      var salidasTemporadaJson = await bundle.loadString(OtherAssets.preloadedSalidasTemporada);
      var salidasAlternativoJson = await bundle.loadString(OtherAssets.preloadedSalidasAlternativo);

      Season temporada = Season.parse(salidasTemporadaJson);
      List<BookEvent> salidasTemporada = BookEvent.parseAll(salidasTemporadaJson);
      List<BookEvent> salidasAlternativo = BookEvent.parseAll(salidasAlternativoJson);

      var inNextDayBookEvent = _getInDayBookEvent(salidasTemporada, Clock.defaultDateTimeGetter());

      next(ReceivedBookEventsAction(
        inSeasonBookEvents: salidasTemporada,
        inAlternativeBookEvents: salidasAlternativo,
        inNextDayBookEvent: inNextDayBookEvent,
        currentSeason: temporada,
      ));
      //next(FetchWeatherAction(inNextDayBookEvent));
    } catch (e) {
      log.severe('BookEventMiddleware._fetchBookEvents - Error: ${e.toString()}');
      next(ErrorLoadingBookEventsAction());
    }
  }

  BookEvent _getInDayBookEvent(List<BookEvent> allBookEvents, DateTime day) {
    log.fine('BookEventMiddleware._getInDayBookEvent - Start');

    BookEvent nextDay = allBookEvents.firstWhere((bookEvent) => bookEvent.eventDay.isAfter(day.subtract(new Duration(days: 1))), orElse: () => allBookEvents.last);
    //log.finest('BookEventMiddleware._getInDayBookEvent: nextDay=$nextDay');
    return nextDay;
  }

  /*Future<String> _getMapCover(String routeMapUrl) async {
    log.fine('BookEventMiddleware._getMapCover - Start');

    if(routeMapUrl != null) {
      log.fine('BookEventMiddleware._getMapCover - routeMapUrl: $routeMapUrl');
      return MapsUtil.staticMapUrl(routeMapUrl);
    }
    return null;
  }*/

  /*Future<Weather> _getWeather(DateTime eventDay) async {
    log.fine('BookEventMiddleware._getWeather - Start');

    if(eventDay != null) {
      log.fine('BookEventMiddleware._getWeather - eventDay: ${eventDay.toString()}');

      var weathers = await weatherApi.getWeatherForecast('41710');
      log.finest('WeatherMiddleware._getWeather -  weathers=${weathers.toString()}');

      Weather weather = weathers.firstWhere((weather) => eventDay.isAtSameMomentAs(weather.day), orElse: () => null);
      log.fine('WeatherMiddleware._getWeather -  eventDay=${eventDay.toString()}, weather=${weather.toString()}');

      return weather;
    }
    return null;
  }*/
}
