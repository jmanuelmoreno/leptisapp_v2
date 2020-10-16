import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/book_event/book_event_reducer.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_reducer.dart';
import 'package:leptisapp/redux/leptis/member/member_reducer.dart';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_reducer.dart';
import 'package:leptisapp/redux/search/search_reducer.dart';
import 'package:leptisapp/redux/leptis/escort/escort_reducer.dart';
import 'package:leptisapp/redux/leptis/events/event_reducer.dart';
import 'package:leptisapp/redux/leptis/login/auth_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    searchQuery: searchQueryReducer(state.searchQuery, action),

    //actorsByName: actorReducer(state.actorsByName, action),
    //theaterState: theaterReducer(state.theaterState, action),
    //showState: showReducer(state.showState, action),
    //eventState: eventReducer(state.eventState, action),

    escortState: escortReducer(state.escortState, action),
    bookEventState: bookEventReducer(state.bookEventState, action),
    membersByName: memberReducer(state.membersByName, action),
    mapCoversByBookEvent: mapCoverReducer(state.mapCoversByBookEvent, action),
    authState: authReducer(state.authState, action),
    regularityState: regularityReducer(state.regularityState, action),
    regularityHistoryState: regularityHistoryReducer(state.regularityHistoryState, action),
    weathersByBookEvent: weatherReducer(state.weathersByBookEvent, action),
    eventState: eventReducer(state.eventState, action),
  );
}
