import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/season.dart';
import 'package:meta/meta.dart';

@immutable
class BookEventState {
  BookEventState({
    @required this.loadingStatus,
    @required this.inSeasonBookEvents,
    @required this.inAlternativeBookEvents,
    @required this.inNextDayBookEvent,
    @required this.currentSeason,
  });

  final LoadingStatus loadingStatus;
  final List<BookEvent> inSeasonBookEvents;
  final List<BookEvent> inAlternativeBookEvents;
  final BookEvent inNextDayBookEvent;
  final Season currentSeason;

  factory BookEventState.initial() {
    return BookEventState(
      loadingStatus: LoadingStatus.loading,
      inSeasonBookEvents: <BookEvent>[],
      inAlternativeBookEvents: <BookEvent>[],
      inNextDayBookEvent: null,
      currentSeason: null,
    );
  }

  BookEventState copyWith({
    LoadingStatus loadingStatus,
    List<BookEvent> inSeasonBookEvents,
    List<BookEvent> inAlternativeBookEvents,
    BookEvent inNextDayBookEvent,
    Season currentSeason,
  }) {
    return BookEventState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      inSeasonBookEvents: inSeasonBookEvents ?? this.inSeasonBookEvents,
      inAlternativeBookEvents: inAlternativeBookEvents ?? this.inAlternativeBookEvents,
      inNextDayBookEvent: inNextDayBookEvent ?? this.inNextDayBookEvent,
      currentSeason: currentSeason ?? this.currentSeason,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookEventState &&
              runtimeType == other.runtimeType &&
              loadingStatus == other.loadingStatus &&
              inSeasonBookEvents == other.inSeasonBookEvents &&
              inAlternativeBookEvents == other.inAlternativeBookEvents &&
              inNextDayBookEvent == other.inNextDayBookEvent &&
              currentSeason == other.currentSeason;

  @override
  int get hashCode =>
      loadingStatus.hashCode ^
      inSeasonBookEvents.hashCode ^
      inAlternativeBookEvents.hashCode ^
      inNextDayBookEvent.hashCode ^
      currentSeason.hashCode;

  @override
  String toString() {
    return '''BookEventState {
      loadingStatus: $loadingStatus, 
      inSeasonBookEvents: ${inSeasonBookEvents.length}, 
      inAlternativeBookEvents: ${inAlternativeBookEvents.length},       
      inNextDayBookEvent: ${inNextDayBookEvent.toString()},       
      currentSeason: ${currentSeason.toString()}
     }''';
  }
}
