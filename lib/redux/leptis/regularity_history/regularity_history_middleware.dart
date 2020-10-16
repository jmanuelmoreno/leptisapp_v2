import 'dart:async';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_actions.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

import 'package:leptisapp/data/networking/leptis/leptis_api.dart';
import 'package:leptisapp/redux/app/app_state.dart';

class RegularityHistoryMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('RegularityHistoryMiddleware');

  RegularityHistoryMiddleware(this.leptisApi);
  final LeptisApi leptisApi;

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine("RegularityHistoryMiddleware.call - Start");

    next(action);

    if (action is FetchRegularityHistoryAction) {
      await _fetchRegularityHistory(action.season, action.memberId, store.state, next);
    }
  }

  Future<Null> _fetchRegularityHistory(String season, String memberId, AppState state, NextDispatcher next) async {
    log.fine("RegularityHistoryMiddleware._fetchRegularityHistory - Start");

    next(RequestingRegularityHistoryAction());

    try {
      var allRegularityHistory = await leptisApi.getRegularityHistory(memberId, season, state.authState.currentUser.sessionToken);
      log.fine("RegularityHistoryMiddleware._fetchRegularityHistory: $allRegularityHistory");

      next(ReceivedRegularityHistoryAction(
        allRegularityHistory: allRegularityHistory,
        season: season,
        memberId: memberId
      ));

    } catch (e) {
      log.severe("RegularityHistoryMiddleware._fetchRegularityHistory - Error: $e");
      next(ErrorLoadingRegularityHistoryAction());
    }
  }

}
