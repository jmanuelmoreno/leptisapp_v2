import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/regularity_history.dart';
import 'package:meta/meta.dart';

@immutable
class RegularityHistoryState {
  RegularityHistoryState({
    @required this.loadingStatus,
    @required this.allRegularityHistory,
    @required this.season,
    @required this.memberId,
  });

  final LoadingStatus loadingStatus;
  final List<RegularityHistory> allRegularityHistory;
  final String season;
  final String memberId;


  factory RegularityHistoryState.initial() {
    return RegularityHistoryState(
      loadingStatus: LoadingStatus.loading,
      allRegularityHistory: <RegularityHistory>[],
      season: null,
      memberId: null
    );
  }

  RegularityHistoryState copyWith({
    LoadingStatus loadingStatus,
    List<RegularityHistory> allRegularityHistory,
    String season,
    String memberId,
  }) {
    return RegularityHistoryState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      allRegularityHistory: allRegularityHistory ?? this.allRegularityHistory,
      season: season ?? this.season,
      memberId: memberId ?? this.memberId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RegularityHistoryState &&
              runtimeType == other.runtimeType &&
              loadingStatus == other.loadingStatus &&
              allRegularityHistory == other.allRegularityHistory &&
              season == other.season &&
              memberId == other.memberId;

  @override
  int get hashCode =>
      loadingStatus.hashCode ^
      allRegularityHistory.hashCode ^
      season.hashCode ^
      memberId.hashCode;

  @override
  String toString() {
    return '''RegularityHistoryState {
      loadingStatus: $loadingStatus,       
      allRegularityHistory: ${allRegularityHistory.length},       
      season: $season,
      memberId: $memberId
     }''';
  }
}
