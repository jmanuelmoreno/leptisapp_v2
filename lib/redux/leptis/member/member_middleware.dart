import 'dart:async';

import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/escort.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/networking/leptis/leptis_api.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/leptis/member/member_actions.dart';
import 'package:leptisapp/utils/avatar_utils.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

class MemberMiddleware extends MiddlewareClass<AppState> {
  final Logger log = new Logger('MemberMiddleware');

  MemberMiddleware(this.leptisApi);
  final LeptisApi leptisApi;

  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    log.fine("MemberMiddleware.call - Start");

    next(action);

    if (action is FetchMemberAvatarsAction) {
      next(MembersUpdatedAction(action.bookEvent.escort));

      try {
        var escort = await _findEscortForBookEvent(store, action.bookEvent);
        var escortWithAvatars = await _findAvatarsForEscort(escort);

        next(UpdateMembersForBookEventAction(action.bookEvent, escortWithAvatars));
        next(ReceivedMemberAvatarsAction(escortWithAvatars));
      } catch (e) {
        // We don't need to handle this. If fetching actor avatars
        // fails, we don't care: the UI just simply won't display
        // any actor avatars and falls back to placeholder icons
        // instead.
      }
    }
  }

  Future<List<Member>> _findEscortForBookEvent(Store<AppState> store, BookEvent bookEvent) async {
    log.fine("MemberMiddleware._findEscortForBookEvent - Start");

    var escorts = store.state.escortState.escorts;

    Escort escort = escorts.firstWhere((escort) => escort.day.compareTo(bookEvent.eventDay)==0, orElse: () => null);
    if(escort!=null) {
      List<Member> escortForBookEvent = <Member>[]..add(
          Member(name: escort.escort1))..add(Member(name: escort.escort2));

      return escortForBookEvent;
    }

    return bookEvent.escort;
  }

  Future<List<Member>> _findAvatarsForEscort(List<Member> escort) async {
    log.fine("MemberMiddleware._findAvatarsForEscort - Start");

    var escortWithAvatars = <Member>[];

    escort.forEach((Member member) {
      var profilePath = getAvatarUrl((member.email != null) ? member.email : "${member.name}@gmail.com");
      escortWithAvatars.add(Member(
        name: member.name,
        avatarUrl: profilePath,
      ));
    });

    return escortWithAvatars;
  }
}
