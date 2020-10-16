import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/assets.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/member/member_actions.dart';
import 'package:leptisapp/redux/leptis/member/member_selectors.dart';

class EscortScroller extends StatelessWidget {
  const EscortScroller(this.bookEvent);
  final BookEvent bookEvent;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Member>>(
      onInit: (store) => store.dispatch(FetchMemberAvatarsAction(bookEvent)),
      converter: (store) => membersForEventSelector(store.state, bookEvent),
      builder: (_, members) => EscortScrollerContent(members),
    );
  }
}

class EscortScrollerContent extends StatelessWidget {
  const EscortScrollerContent(this.members);
  final List<Member> members;

  Widget _buildEscortList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0),
      scrollDirection: Axis.horizontal,
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        var member = members[index];
        return _buildEscortListItem(context, member);
      },
    );
  }

  Widget _buildEscortListItem(BuildContext context, Member member) {
    var escortName = Text(
      member.name,
      style: const TextStyle(fontSize: 12.0),
      textAlign: TextAlign.center,
    );

    return Container(
      width: 90.0,
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: <Widget>[
          _buildEscortAvatar(context, member),
          const SizedBox(height: 8.0),
          escortName,
        ],
      ),
    );
  }

  Widget _buildEscortAvatar(BuildContext context, Member member) {
    var content = <Widget>[
      const Icon(
        Icons.person,
        color: Colors.white,
        size: 26.0,
      ),
    ];

    if (member.avatarUrl != null) {
      content.add(ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: ImageAssets.transparentImage,
          image: member.avatarUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
        ),
      ));
    }

    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (members != null && members.isNotEmpty)? Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: const Text(
              'Acompañamiento',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox.fromSize(
            size: const Size.fromHeight(110.0),
            child: _buildEscortList(context),
          ),
        ],
      ),
    ) : new Container(width: 0.0, height: 0.0);
  }
}
