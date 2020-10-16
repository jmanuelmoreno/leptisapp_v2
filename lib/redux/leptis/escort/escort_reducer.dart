import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/leptis/escort/escort_state.dart';
import 'package:redux/redux.dart';

final escortReducer = combineReducers<EscortState>([
  TypedReducer<EscortState, InitComplete2Action>(_initComplete),
]);

EscortState _initComplete(EscortState state, InitComplete2Action action) {
  return state.copyWith(
    escorts: action.escorts,
  );
}