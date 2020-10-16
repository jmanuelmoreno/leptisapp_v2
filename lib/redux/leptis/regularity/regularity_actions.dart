import 'package:flutter/foundation.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/ui/regularity/regularity_add_list.dart';

class RefreshRegularityAction {}

class FetchRegularityAction {
  FetchRegularityAction({
    @required this.season
  });
  final String season;
}

class RequestingRegularityAction {}

class ReceivedRegularityAction {
  ReceivedRegularityAction({
    @required this.allRegularity,
    @required this.currentSeason,
  });

  final List<Regularity> allRegularity;
  final String currentSeason;
}

class AddingPointRegularityAction {}

class AddPointRegularityAction {
  AddPointRegularityAction({
    @required this.membersCheckList,
    @required this.day,
  });
  final List<MemberItemCheckList> membersCheckList;
  final String day;
}

class AddedPointRegularityAction {}

class ErrorLoadingRegularityAction {}

class ErrorAddingPointRegularityAction {}