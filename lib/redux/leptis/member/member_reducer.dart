import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/redux/leptis/member/member_actions.dart';
import 'package:redux/redux.dart';

final memberReducer = combineReducers<Map<String, Member>>([
  TypedReducer<Map<String, Member>, MembersUpdatedAction>(_membersUpdated),
  TypedReducer<Map<String, Member>, ReceivedMemberAvatarsAction>(
      _receivedAvatars),
]);

Map<String, Member> _membersUpdated(Map<String, Member> membersByName, dynamic action) {
  var members = <String, Member>{}..addAll(membersByName);
  action.members.forEach((Member member) {
    members.putIfAbsent(member.name, () => Member(name: member.name));
  });

  return members;
}

Map<String, Member> _receivedAvatars(Map<String, Member> membersByName, dynamic action) {
  var membersWithAvatars = <String, Member>{}..addAll(membersByName);
  action.members.forEach((Member member) {
    membersWithAvatars[member.name] = Member(
      name: member.name,
      avatarUrl: member.avatarUrl,
    );
  });

  return membersWithAvatars;
}
