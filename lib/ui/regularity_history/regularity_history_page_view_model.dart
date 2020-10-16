import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/regularity_history.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_selectors.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';


class RegularityHistoryPageViewModel {
  RegularityHistoryPageViewModel({
    @required this.status,
    @required this.regularityHistory,
  });

  final LoadingStatus status;
  final List<RegularityHistory> regularityHistory;

  static RegularityHistoryPageViewModel fromStore(
    Store<AppState> store
  ) {
    return RegularityHistoryPageViewModel(
      status: store.state.regularityState.loadingStatus,
      regularityHistory: regularityHistorySelector(store.state),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegularityHistoryPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          regularityHistory == other.regularityHistory;

  @override
  int get hashCode =>
      status.hashCode ^ regularityHistory.hashCode;
}
