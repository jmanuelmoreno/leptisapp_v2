import 'package:leptisapp/data/loading_status.dart';
import 'package:redux/redux.dart';

import 'regularity_history_actions.dart';
import 'regularity_history_state.dart';

final regularityHistoryReducer = combineReducers<RegularityHistoryState>([
  TypedReducer<RegularityHistoryState, RequestingRegularityHistoryAction>(_requestingRegularityHistory),
  TypedReducer<RegularityHistoryState, ReceivedRegularityHistoryAction>(_receivedRegularityHistory),
  TypedReducer<RegularityHistoryState, ErrorLoadingRegularityHistoryAction>(_errorLoadingRegularityHistory),
]);

RegularityHistoryState _requestingRegularityHistory(RegularityHistoryState state, RequestingRegularityHistoryAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
  );
}

RegularityHistoryState _receivedRegularityHistory(RegularityHistoryState state, ReceivedRegularityHistoryAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    allRegularityHistory: action.allRegularityHistory,
    season: action.season,
    memberId: action.memberId
  );
}

RegularityHistoryState _errorLoadingRegularityHistory(RegularityHistoryState state, ErrorLoadingRegularityHistoryAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.error);
}