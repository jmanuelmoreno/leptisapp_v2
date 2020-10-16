import 'dart:collection';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/redux/app/app_state.dart';

List<Regularity> regularitySelector(AppState state) {
  List<Regularity> regularity = state.regularityState.allRegularity;

  var uniqueRegularity = _uniqueRegularity(regularity);

  if (state.searchQuery == null) {
    return uniqueRegularity;
  }

  return _regularityWithSearchQuery(state, uniqueRegularity);
}

List<Regularity> _uniqueRegularity(List<Regularity> original) {
  var uniqueRegularityMap = LinkedHashMap<String, Regularity>();
  original.forEach((regularity) {
    uniqueRegularityMap[regularity.fullname] = regularity;
  });

  return uniqueRegularityMap.values.toList();
}

List<Regularity> _regularityWithSearchQuery(AppState state, List<Regularity> original) {
  var searchQuery = RegExp(state.searchQuery, caseSensitive: false);

  return original.where((regularity) {
    return regularity.fullname.contains(searchQuery);
  }).toList();
}

Regularity firstPositionSelector(AppState state) {
  List<Regularity> original = state.regularityState.allRegularity;
  original.sort((a, b) => a.score.compareTo(b.score));

  return original.first;
}
