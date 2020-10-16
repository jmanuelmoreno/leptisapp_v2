import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_status.dart';
import 'package:meta/meta.dart';

@immutable
class RegularityState {
  RegularityState({
    @required this.loadingStatus,
    @required this.allRegularity,
    @required this.currentSeason,
    @required this.regularityStatus,
  });

  final LoadingStatus loadingStatus;
  final RegularityStatus regularityStatus;
  final List<Regularity> allRegularity;
  final String currentSeason;


  factory RegularityState.initial() {
    return RegularityState(
      loadingStatus: LoadingStatus.loading,
      allRegularity: <Regularity>[],
      currentSeason: '',
      regularityStatus: null
    );
  }

  RegularityState copyWith({
    LoadingStatus loadingStatus,
    List<Regularity> allRegularity,
    String currentSeason,
    RegularityStatus regularityStatus,
  }) {
    return RegularityState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      allRegularity: allRegularity ?? this.allRegularity,
      currentSeason: currentSeason ?? this.currentSeason,
      regularityStatus: regularityStatus ?? this.regularityStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RegularityState &&
              runtimeType == other.runtimeType &&
              loadingStatus == other.loadingStatus &&
              allRegularity == other.allRegularity &&
              currentSeason == other.currentSeason &&
              regularityStatus == other.regularityStatus;

  @override
  int get hashCode =>
      loadingStatus.hashCode ^
      allRegularity.hashCode ^
      currentSeason.hashCode ^
      regularityStatus.hashCode;

  @override
  String toString() {
    return '''RegularityState {
      loadingStatus: $loadingStatus,       
      allRegularity: ${allRegularity.length},       
      currentSeason: $currentSeason,
      regularityStatus: $regularityStatus
     }''';
  }
}
