import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/member.dart';

class UpdateEscortAction {
  UpdateEscortAction(this.bookEvent);
  final BookEvent bookEvent;
}

class EscortUpdatedAction {
  EscortUpdatedAction(this.escort);
  final List<Member> escort;
}