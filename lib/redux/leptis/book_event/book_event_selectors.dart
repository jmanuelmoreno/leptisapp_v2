import 'dart:collection';

import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/utils/clock.dart';

List<BookEvent> bookEventsSelector(AppState state, BookEventListType type) {
  List<BookEvent> bookEvents = type == BookEventListType.inAlternative
      ? state.bookEventState.inAlternativeBookEvents : state.bookEventState.inSeasonBookEvents;

  var uniqueEvents = _uniqueBookEvents(bookEvents);

  if (state.searchQuery == null) {
    return uniqueEvents;
  }

  return _bookEventsWithSearchQuery(state, type, uniqueEvents);
}

List<BookEvent> _uniqueBookEvents(List<BookEvent> original) {
  var uniqueBookEventMap = LinkedHashMap<String, BookEvent>();
  original.forEach((bookEvent) {
    uniqueBookEventMap[bookEvent.id.toString()] = bookEvent;
  });

  print("uniqueBookEventMap size: ${uniqueBookEventMap.length}");
  return uniqueBookEventMap.values.toList()
    ..sort((a, b) {
      if(a.hasEventDay && b.hasEventDay)
        return a.eventDay.compareTo(b.eventDay);
      return a.id.compareTo(b.id);
  });
}

List<BookEvent> _bookEventsWithSearchQuery(AppState state, BookEventListType type, List<BookEvent> original) {
  var searchQuery = RegExp(state.searchQuery, caseSensitive: false);

  return original.where((bookEvent) {
    return type == BookEventListType.inSeason ?
      bookEvent.title.contains(searchQuery)
        || Clock.getDateTimeFormatted(bookEvent.eventDay, 'dd/MM').contains(searchQuery)
        || Clock.getDateTimeFormatted(bookEvent.eventDay, 'MMMM').contains(searchQuery)
    :
      bookEvent.title.contains(searchQuery)
    ;
  }).toList();
}

String mapCoverForBookEventSelector(AppState state, BookEvent bookEvent) {
  return state.mapCoversByBookEvent.values
      .firstWhere((mapCoverUrl) => bookEvent.routeMapCoverUrl == mapCoverUrl, orElse: () => null);
}

Weather weatherForBookEventSelector(AppState state, BookEvent bookEvent) {
  return state.weathersByBookEvent.values
      .firstWhere((Weather weather) => (weather != null && bookEvent.hasEventDay) ? bookEvent.start.isAtSameMomentAs(weather.day) : false, orElse: () => null);
}