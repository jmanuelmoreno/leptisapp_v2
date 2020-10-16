import 'package:flutter/foundation.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/season.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';

class RefreshBookEventsAction {}

class FetchBookEventsAction {}

class RequestingBookEventsAction {}

class ReceivedBookEventsAction {
  ReceivedBookEventsAction({
    @required this.inSeasonBookEvents,
    @required this.inAlternativeBookEvents,
    @required this.inNextDayBookEvent,
    @required this.currentSeason,
  });

  final List<BookEvent> inSeasonBookEvents;
  final List<BookEvent> inAlternativeBookEvents;
  final BookEvent inNextDayBookEvent;
  final Season currentSeason;
}

class ErrorLoadingBookEventsAction {}

///
/// Cover map actions
///
class FetchMapCoverAction {
  FetchMapCoverAction(this.bookEvent);
  final BookEvent bookEvent;
}

class MapCoverUpdatedAction {
  MapCoverUpdatedAction(this.bookEvent, this.mapCoverUrl);
  final BookEvent bookEvent;
  final String mapCoverUrl;
}

class ReceivedMapCoverAction {
  ReceivedMapCoverAction(this.bookEvent, this.mapCoverUrl);
  final BookEvent bookEvent;
  final String mapCoverUrl;
}

///
/// Weather actions
///
class FetchWeatherAction {
  FetchWeatherAction(this.bookEvent);
  final BookEvent bookEvent;
}

class WeatherUpdatedAction {
  WeatherUpdatedAction({this.bookEvent, this.weather});
  final BookEvent bookEvent;
  final Weather weather;
}

class ReceivedWeatherAction {
  ReceivedWeatherAction({this.bookEvent, this.weather});
  final BookEvent bookEvent;
  final Weather weather;
}