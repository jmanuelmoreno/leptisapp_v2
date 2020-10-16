import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_actions.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_selectors.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_status.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';


class RegularityPageViewModel {
  RegularityPageViewModel({
    @required this.status,
    @required this.regularityStatus,
    @required this.regularity,
    @required this.currentUser,
    @required this.refreshRegularity,
  });

  final LoadingStatus status;
  final RegularityStatus regularityStatus;
  final List<Regularity> regularity;
  final LeptisUser currentUser;
  final Function refreshRegularity;

  static RegularityPageViewModel fromStore(
    Store<AppState> store
  ) {
    return RegularityPageViewModel(
      status: store.state.regularityState.loadingStatus,
      regularityStatus: store.state.regularityState.regularityStatus,
      regularity: regularitySelector(store.state),
      currentUser: store.state.authState.currentUser,
      refreshRegularity: () => store.dispatch(RefreshRegularityAction()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegularityPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          regularityStatus == other.regularityStatus &&
          regularity == other.regularity &&
          currentUser == other.currentUser &&
          refreshRegularity == other.refreshRegularity;

  @override
  int get hashCode =>
      status.hashCode ^ regularityStatus.hashCode ^ regularity.hashCode ^ currentUser.hashCode ^ refreshRegularity.hashCode;
}
