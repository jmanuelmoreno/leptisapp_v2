import 'dart:collection';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:leptisapp/redux/app/app_state.dart';

List<Event> eventsSelector(AppState state) {
  List<Event> events = state.eventState.allEvents;

  var uniqueEvents = _uniqueEvents(events);

  if (state.searchQuery == null) {
    return uniqueEvents;
  }

  return _eventsWithSearchQuery(state, uniqueEvents);
}

List<Event> _uniqueEvents(List<Event> original) {
  var uniqueEventMap = LinkedHashMap<String, Event>();
  original.forEach((event) {
    uniqueEventMap[event.title] = event;
  });

  return uniqueEventMap.values.toList();
}

List<Event> _eventsWithSearchQuery(AppState state, List<Event> original) {
  var searchQuery = RegExp(state.searchQuery, caseSensitive: false);

  return original.where((event) {
    return event.title.contains(searchQuery);
  }).toList();
}
