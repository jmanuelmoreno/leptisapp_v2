import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_actions.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_status.dart';
import 'package:redux/redux.dart';

final regularityReducer = combineReducers<RegularityState>([
  TypedReducer<RegularityState, RequestingRegularityAction>(_requestingRegularity),
  TypedReducer<RegularityState, ReceivedRegularityAction>(_receivedRegularity),
  TypedReducer<RegularityState, ErrorLoadingRegularityAction>(_errorLoadingRegularity),

  TypedReducer<RegularityState, AddingPointRegularityAction>(_addingPointRegularity),
  TypedReducer<RegularityState, AddedPointRegularityAction>(_addedPointRegularity),
  TypedReducer<RegularityState, ErrorAddingPointRegularityAction>(_errorAddingPointRegularity),
]);

RegularityState _requestingRegularity(RegularityState state, RequestingRegularityAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    regularityStatus: RegularityStatus.none
  );
}

RegularityState _receivedRegularity(RegularityState state, ReceivedRegularityAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    regularityStatus: RegularityStatus.none,
    allRegularity: action.allRegularity,
    currentSeason: action.currentSeason,
  );
}

RegularityState _errorLoadingRegularity(RegularityState state, ErrorLoadingRegularityAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.error);
}

RegularityState _addingPointRegularity(RegularityState state, AddingPointRegularityAction action) {
  return state.copyWith(regularityStatus: RegularityStatus.adding);
}

RegularityState _addedPointRegularity(RegularityState state, AddedPointRegularityAction action) {
  return state.copyWith(
    regularityStatus: RegularityStatus.added,
  );
}

RegularityState _errorAddingPointRegularity(RegularityState state, ErrorAddingPointRegularityAction action) {
  return state.copyWith(regularityStatus: RegularityStatus.error);
}