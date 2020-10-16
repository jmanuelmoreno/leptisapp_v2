import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/utils/clock.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class BookEventGridItem extends StatelessWidget {
  BookEventGridItem({
    @required this.bookEvent,
    @required this.onTapped,
  });

  final BookEvent bookEvent;
  final VoidCallback onTapped;

  //static const double height = 284.0;
  static const double height = 215.0;

  Widget _buildTextualInfo(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline;
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    var content = <Widget>[
      Expanded(
        child: (bookEvent.eventDay != null) ? Text(Clock.getDateTimeFormatted(bookEvent.eventDay, "d ' de ' MMMM"), style: descriptionStyle) : Container(),
      ),
    ];

    var routeDistance = NumberFormat.decimalPattern().format(bookEvent.distance);
    if(bookEvent.hasDistance)
      content.add(Text('$routeDistance Kms', style: theme.textTheme.subhead));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: content,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(bookEvent.title, style: titleStyle.copyWith(fontSize: 20.0), ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return new SafeArea(
      top: false,
      bottom: false,
      child: new Container(
        height: height,
        child: new Card(
          elevation: 8.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // photo and title
                  new SizedBox(
                    //height: 184.0,
                    height: 130.0,
                    child: new Stack(
                      children: <Widget>[
                        new Positioned.fill(
                          child: new Image.asset(
                            bookEvent.coverUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // description and share/explore buttons
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                      child: new DefaultTextStyle(
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionStyle,
                        child: _buildTextualInfo(context),
                      ),
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTapped,
                  child: Container(),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
