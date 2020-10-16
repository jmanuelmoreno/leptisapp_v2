import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_actions.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_selectors.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class BookEventsPageViewModel {
  BookEventsPageViewModel({
    @required this.status,
    @required this.bookEvents,
    @required this.refreshBookEvents,
  });

  final LoadingStatus status;
  final List<BookEvent> bookEvents;
  final Function refreshBookEvents;

  static BookEventsPageViewModel fromStore(
    Store<AppState> store,
    BookEventListType type,
  ) {
    return BookEventsPageViewModel(
      status: store.state.bookEventState.loadingStatus,
      bookEvents: bookEventsSelector(store.state, type),
      refreshBookEvents: () => store.dispatch(RefreshBookEventsAction()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEventsPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          bookEvents == other.bookEvents &&
          refreshBookEvents == other.refreshBookEvents;

  @override
  int get hashCode =>
      status.hashCode ^ bookEvents.hashCode ^ refreshBookEvents.hashCode;
}
