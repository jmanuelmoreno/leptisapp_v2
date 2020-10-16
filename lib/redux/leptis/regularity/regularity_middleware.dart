import 'dart:async';
import 'package:leptisapp/ui/regularity/regularity_add_list.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

import 'package:leptisapp/data/networking/leptis/leptis_api.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_actions.dart';

class RegularityMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('RegularityMiddleware');

  RegularityMiddleware(this.leptisApi);
  final LeptisApi leptisApi;

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine("RegularityMiddleware.call - Start");

    next(action);

    if (action is FetchRegularityAction) {
      await _fetchRegularity(action.season, store.state, next);
    } else if (action is RefreshRegularityAction) {
      await _fetchRegularity(store.state.regularityState.currentSeason, store.state, next);
    } else if (action is AddPointRegularityAction) {
      await _addPointRegularity(action.membersCheckList, store.state.regularityState.currentSeason, action.day, store.state, next);
    }
  }

  Future<Null> _fetchRegularity(String season, AppState state, NextDispatcher next) async {
    log.fine("RegularityMiddleware._fetchRegularity - Start");

    next(RequestingRegularityAction());

    try {
      var allRegularity = await leptisApi.getRegularity(season, state.authState.currentUser.sessionToken);
      log.fine("RegularityMiddleware._fetchRegularity: $allRegularity");

      next(ReceivedRegularityAction(
        allRegularity: allRegularity,
        currentSeason: season,
      ));

    } catch (e) {
      log.severe("RegularityMiddleware._fetchRegularity - Error: $e");
      next(ErrorLoadingRegularityAction());
    }
  }

  Future<Null> _addPointRegularity(List<MemberItemCheckList> membersCheckList, String season, String day, AppState state, NextDispatcher next) async {
    log.fine("RegularityMiddleware._addPointRegularity - Start");

    next(AddingPointRegularityAction());

    try {
      log.fine('membersCheckList: ${membersCheckList.toString()}');
      log.fine('season: $season');
      log.fine('day: $day');

      await leptisApi.saveNewRegularity(membersCheckList, season, day, state.authState.currentUser.sessionToken);
      log.info('Regularidad actualizada correctamente.');

      next(AddedPointRegularityAction());
    } catch (e) {
      log.severe("RegularityMiddleware._addPointRegularity - Error: ${e.toString()}");
      next(ErrorAddingPointRegularityAction());
    }
  }
}
