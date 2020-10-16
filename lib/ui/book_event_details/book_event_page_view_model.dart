import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_actions.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class BookEventPageViewModel {
  BookEventPageViewModel({
    @required this.status,
    @required this.bookEvent,
    @required this.refreshBookEvents,
  });

  final LoadingStatus status;
  final BookEvent bookEvent;
  final Function refreshBookEvents;

  static BookEventPageViewModel fromStore(
    Store<AppState> store,
  ) {
    Logger('BookEventPageViewModel').fine('BookEventPageViewModel.fromStore - Start');
    return BookEventPageViewModel(
      status: store.state.bookEventState.loadingStatus,
      bookEvent: store.state.bookEventState.inNextDayBookEvent,
      refreshBookEvents: () => store.dispatch(RefreshBookEventsAction()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEventPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          bookEvent == other.bookEvent &&
          refreshBookEvents == other.refreshBookEvents;

  @override
  int get hashCode =>
      status.hashCode ^ bookEvent.hashCode ^ refreshBookEvents.hashCode;
}
