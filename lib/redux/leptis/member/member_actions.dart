import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/member.dart';

class FetchMemberAvatarsAction {
  FetchMemberAvatarsAction(this.bookEvent);
  final BookEvent bookEvent;
}

class MembersUpdatedAction {
  MembersUpdatedAction(this.members);
  final List<Member> members;
}

class ReceivedMemberAvatarsAction {
  ReceivedMemberAvatarsAction(this.members);
  final List<Member> members;
}
