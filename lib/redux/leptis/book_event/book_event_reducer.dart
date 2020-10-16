import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_actions.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_state.dart';
import 'package:redux/redux.dart';

final bookEventReducer = combineReducers<BookEventState>([
  TypedReducer<BookEventState, RequestingBookEventsAction>(_requestingBookEvents),
  TypedReducer<BookEventState, ReceivedBookEventsAction>(_receivedBookEvents),
  TypedReducer<BookEventState, ErrorLoadingBookEventsAction>(_errorLoadingBookEvents),
  TypedReducer<BookEventState, UpdateMembersForBookEventAction>(_updateEscortForBookEvent),
  TypedReducer<BookEventState, UpdateMapCoverForBookEventAction>(_updateMapCoverForBookEvent),
  TypedReducer<BookEventState, UpdateWeatherForBookEventAction>(_updateWeatherForBookEvent),
]);

final mapCoverReducer = combineReducers<Map<String, String>>([
  TypedReducer<Map<String, String>, MapCoverUpdatedAction>(_mapCoverUpdated),
  TypedReducer<Map<String, String>, ReceivedMapCoverAction>(_receivedMapCover),
]);

final weatherReducer = combineReducers<Map<DateTime, Weather>>([
  TypedReducer<Map<DateTime, Weather>, WeatherUpdatedAction>(_weatherUpdated),
  TypedReducer<Map<DateTime, Weather>, ReceivedWeatherAction>(_receivedWeather),
]);


BookEventState _requestingBookEvents(BookEventState state, RequestingBookEventsAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.loading);
}

BookEventState _receivedBookEvents(BookEventState state, ReceivedBookEventsAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    inSeasonBookEvents: action.inSeasonBookEvents,
    inAlternativeBookEvents: action.inAlternativeBookEvents,
    inNextDayBookEvent: action.inNextDayBookEvent,
    currentSeason: action.currentSeason,
  );
}

BookEventState _errorLoadingBookEvents(
    BookEventState state, ErrorLoadingBookEventsAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.error);
}

BookEventState _updateEscortForBookEvent(BookEventState state, UpdateMembersForBookEventAction action) {
  var bookEvent = action.bookEvent;
  bookEvent.escort = action.members;

  return state.copyWith(
    inSeasonBookEvents: _replaceBookEventIfFound(state.inSeasonBookEvents, bookEvent),
  );
}

BookEventState _updateMapCoverForBookEvent(BookEventState state, UpdateMapCoverForBookEventAction action) {
  var bookEvent = action.bookEvent;
  bookEvent.routeMapCoverUrl = action.mapCoverUrl;

  return state.copyWith(
    inSeasonBookEvents: _replaceBookEventIfFound(state.inSeasonBookEvents, bookEvent),
    inAlternativeBookEvents: _replaceBookEventIfFound(state.inAlternativeBookEvents, bookEvent),
    inNextDayBookEvent: state.inNextDayBookEvent.id == bookEvent.id ? bookEvent : state.inNextDayBookEvent
  );
}

Map<String, String> _mapCoverUpdated(Map<String, String> mapCoversByBookEvent, dynamic action) {
  var mapCovers = <String, String>{}..addAll(mapCoversByBookEvent);
  mapCovers.putIfAbsent(action.bookEvent.id.toString(), () => action.mapCoverUrl);
  return mapCovers;
}

Map<String, String> _receivedMapCover(Map<String, String> mapCoversByBookEvent, dynamic action) {
  var mapCovers = <String, String>{}..addAll(mapCoversByBookEvent);
  mapCovers[action.bookEvent.id.toString()] = action.mapCoverUrl;
  return mapCovers;
}

BookEventState _updateWeatherForBookEvent(BookEventState state, UpdateWeatherForBookEventAction action) {
  var bookEvent = action.bookEvent;
  bookEvent.weather = action.weather;

  return state.copyWith(
      inSeasonBookEvents: _replaceBookEventIfFound(state.inSeasonBookEvents, bookEvent),
      inNextDayBookEvent: state.inNextDayBookEvent.id == bookEvent.id ? bookEvent : state.inNextDayBookEvent
  );
}

Map<DateTime, Weather> _weatherUpdated(Map<DateTime, Weather> weathersByBookEvent, WeatherUpdatedAction action) {
  var weathers = <DateTime, Weather>{}..addAll(weathersByBookEvent);
  weathers.putIfAbsent(action.bookEvent.start, () => action.weather);
  return weathers;
}

Map<DateTime, Weather> _receivedWeather(Map<DateTime, Weather> weathersByBookEvent, ReceivedWeatherAction action) {
  var weathers = <DateTime, Weather>{}..addAll(weathersByBookEvent);
  weathers[action.bookEvent.start] = action.weather;
  return weathers;
}

List<BookEvent> _replaceBookEventIfFound(List<BookEvent> originalEvents, BookEvent replacement,) {
  var newEvents = <BookEvent>[]..addAll(originalEvents);
  var positionToReplace = originalEvents.indexWhere((candidate) {
    return candidate.id == replacement.id;
  });

  if (positionToReplace > -1) {
    newEvents[positionToReplace] = replacement;
  }

  return newEvents;
}