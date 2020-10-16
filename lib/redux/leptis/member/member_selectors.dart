import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/redux/app/app_state.dart';

List<Member> membersForEventSelector(AppState state, BookEvent bookEvent) {
  return state.membersByName.values
      .where((member) => bookEvent.escort.contains(member))
      .toList();
}
