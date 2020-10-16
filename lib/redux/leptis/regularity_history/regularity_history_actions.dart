import 'package:flutter/foundation.dart';
import 'package:leptisapp/data/models/leptis/regularity_history.dart';

class FetchRegularityHistoryAction {
  FetchRegularityHistoryAction({
    @required this.season,
    @required this.memberId,
  });
  final String season;
  final String memberId;
}

class RequestingRegularityHistoryAction {}

class ReceivedRegularityHistoryAction {
  ReceivedRegularityHistoryAction({
    @required this.allRegularityHistory,
    @required this.season,
    @required this.memberId,
  });

  final List<RegularityHistory> allRegularityHistory;
  final String season;
  final String memberId;
}

class ErrorLoadingRegularityHistoryAction {}