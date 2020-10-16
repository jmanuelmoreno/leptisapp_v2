import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_state.dart';
import 'package:leptisapp/redux/leptis/escort/escort_state.dart';
import 'package:leptisapp/redux/leptis/events/event_state.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_state.dart';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  AppState({
    @required this.searchQuery,

    /*@required this.actorsByName,
    @required this.theaterState,
    @required this.showState,
    @required this.eventState,*/

    @required this.escortState,
    @required this.bookEventState,
    @required this.membersByName,
    @required this.mapCoversByBookEvent,
    @required this.authState,
    @required this.regularityState,
    @required this.regularityHistoryState,
    @required this.weathersByBookEvent,
    @required this.eventState,
  });

  final String searchQuery;

  /*final Map<String, Actor> actorsByName;
  final TheaterState theaterState;
  final ShowState showState;
  final EventState eventState;*/

  final EscortState escortState;
  final BookEventState bookEventState;
  final Map<String, Member> membersByName;
  final Map<String, String> mapCoversByBookEvent;
  final AuthState authState;
  final RegularityState regularityState;
  final RegularityHistoryState regularityHistoryState;
  final Map<DateTime, Weather> weathersByBookEvent;
  final EventState eventState;

  factory AppState.initial() {
    return AppState(
      searchQuery: null,

      /*actorsByName: <String, Actor>{},
      theaterState: TheaterState.initial(),
      showState: ShowState.initial(),
      eventState: EventState.initial(),*/

      escortState: EscortState.initial(),
      bookEventState: BookEventState.initial(),
      membersByName: <String, Member>{},
      mapCoversByBookEvent: <String, String>{},
      authState: AuthState.initial(),
      regularityState: RegularityState.initial(),
      regularityHistoryState: RegularityHistoryState.initial(),
      weathersByBookEvent: <DateTime, Weather>{},
      eventState: EventState.initial(),
    );
  }

  AppState copyWith({
    String searchQuery,

    /*Map<String, Actor> actorsByName,
    TheaterState theaterState,
    ShowState showState,
    EventState eventState,*/

    EscortState escortState,
    BookEventState bookEventState,
    Map<String, Member> membersByName,
    Map<String, String> mapCoversByBookEvent,
    AuthState authState,
    RegularityState regularityState,
    RegularityHistoryState regularityHistoryState,
    Map<String, Weather> weathersByBookEvent,
    EventState eventState,
  }) {
    return AppState(
      searchQuery: searchQuery ?? this.searchQuery,

      /*actorsByName: actorsByName ?? this.actorsByName,
      theaterState: theaterState ?? this.theaterState,
      showState: showState ?? this.showState,
      eventState: eventState ?? this.eventState,*/

      escortState: escortState ?? this.escortState,
      bookEventState: bookEventState ?? this.bookEventState,
      membersByName: membersByName ?? this.membersByName,
      mapCoversByBookEvent: mapCoversByBookEvent ?? this.mapCoversByBookEvent,
      authState: authState ?? this.authState,
      regularityState: regularityState ?? this.regularityState,
      regularityHistoryState: regularityHistoryState ?? this.regularityHistoryState,
      weathersByBookEvent: weathersByBookEvent ?? this.weathersByBookEvent,
      eventState: eventState ?? this.eventState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              searchQuery == other.searchQuery &&

              /*actorsByName == other.actorsByName &&
              theaterState == other.theaterState &&
              showState == other.showState &&
              eventState == other.eventState &&*/

              escortState == other.escortState &&
              bookEventState == other.bookEventState &&
              membersByName == other.membersByName &&
              mapCoversByBookEvent == other.mapCoversByBookEvent &&
              regularityState == other.regularityState &&
              regularityHistoryState == other.regularityHistoryState &&
              weathersByBookEvent == other.weathersByBookEvent &&
              eventState == other.eventState &&
              authState == other.authState
  ;

  @override
  int get hashCode =>
      searchQuery.hashCode ^

      /*actorsByName.hashCode ^
      theaterState.hashCode ^
      showState.hashCode ^
      eventState.hashCode ^*/

      escortState.hashCode ^
      bookEventState.hashCode ^
      membersByName.hashCode ^
      mapCoversByBookEvent.hashCode ^
      regularityState.hashCode ^
      regularityHistoryState.hashCode ^
      weathersByBookEvent.hashCode ^
      eventState.hashCode ^
      authState.hashCode
  ;

  @override
  String toString() {
    return '''AppState{
      searchQuery: $searchQuery,
      escortState: $escortState,
      bookEventState: $bookEventState,
      membersByName: $membersByName,
      mapCoversByBookEvent: $mapCoversByBookEvent,
      regularityState: $regularityState,
      regularityHistoryState: $regularityHistoryState,
      weathersByBookEvent: $weathersByBookEvent,
      eventState: $eventState,
      authState: $authState,
    }''';
  }
}
