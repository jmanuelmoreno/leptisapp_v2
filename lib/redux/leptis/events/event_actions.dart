import 'package:flutter/foundation.dart';
import 'package:leptisapp/data/models/leptis/event.dart';


class RefreshEventAction {}

class FetchEventAction {}

class RequestingEventAction {}

class ReceivedEventAction {
  ReceivedEventAction({
    @required this.allEvents,
  });

  final List<Event> allEvents;
}

class ErrorLoadingEventAction {}
