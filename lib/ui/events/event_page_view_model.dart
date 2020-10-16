import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/events/event_actions.dart';
import 'package:leptisapp/redux/leptis/events/event_selectors.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class EventPageViewModel {
  EventPageViewModel({
    @required this.status,
    @required this.events,
    @required this.refreshEvents,
  });

  final LoadingStatus status;
  final List<Event> events;
  final Function refreshEvents;

  static EventPageViewModel fromStore(
    Store<AppState> store,
  ) {
    return EventPageViewModel(
      status: store.state.bookEventState.loadingStatus,
      events: eventsSelector(store.state),
      refreshEvents: () => store.dispatch(RefreshEventAction()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          events == other.events &&
          refreshEvents == other.refreshEvents;

  @override
  int get hashCode =>
      status.hashCode ^ events.hashCode ^ refreshEvents.hashCode;
}
