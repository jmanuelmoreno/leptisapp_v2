import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/redux/leptis/events/event_actions.dart';
import 'package:leptisapp/redux/leptis/events/event_state.dart';
import 'package:redux/redux.dart';

final eventReducer = combineReducers<EventState>([
  TypedReducer<EventState, RequestingEventAction>(_requestingEvent),
  TypedReducer<EventState, ReceivedEventAction>(_receivedEvent),
  TypedReducer<EventState, ErrorLoadingEventAction>(_errorLoadingEvent),
]);

EventState _requestingEvent(EventState state, RequestingEventAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
  );
}

EventState _receivedEvent(EventState state, ReceivedEventAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    allEvents: action.allEvents,
  );
}

EventState _errorLoadingEvent(EventState state, ErrorLoadingEventAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.error);
}