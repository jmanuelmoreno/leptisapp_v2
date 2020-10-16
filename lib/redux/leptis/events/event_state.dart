import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:meta/meta.dart';

@immutable
class EventState {
  EventState({
    @required this.loadingStatus,
    @required this.allEvents,
  });

  final LoadingStatus loadingStatus;
  final List<Event> allEvents;

  factory EventState.initial() {
    return EventState(
      loadingStatus: LoadingStatus.loading,
      allEvents: <Event>[],
    );
  }

  EventState copyWith({
    LoadingStatus loadingStatus,
    List<Event> allEvents,
  }) {
    return EventState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      allEvents: allEvents ?? this.allEvents,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventState &&
              runtimeType == other.runtimeType &&
              loadingStatus == other.loadingStatus &&
              allEvents == other.allEvents;

  @override
  int get hashCode =>
      loadingStatus.hashCode ^
      allEvents.hashCode;

  @override
  String toString() {
    return '''RegularityState {
      loadingStatus: $loadingStatus,       
      allEvents: ${allEvents.toString()}
     }''';
  }
}
