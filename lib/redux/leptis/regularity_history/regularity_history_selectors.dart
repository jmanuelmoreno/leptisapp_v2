import 'package:leptisapp/data/models/leptis/regularity_history.dart';
import 'package:leptisapp/redux/app/app_state.dart';

List<RegularityHistory> regularityHistorySelector(AppState state) {
  List<RegularityHistory> regularityHistory = state.regularityHistoryState.allRegularityHistory;

  //Eliminamos salidas sin puntuación
  regularityHistory.removeWhere((history) => history.points == 0);

  return _sortRegularityHistory(regularityHistory);
}

List<RegularityHistory> _sortRegularityHistory(List<RegularityHistory> original) {
  original.sort((a, b) => a.id.compareTo(b.id));
  return original;
}

