import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/event_details/event_details_page.dart';
import 'package:leptisapp/utils/clock.dart';

class EventList extends StatefulWidget {
  EventList({
    @required this.events,
    @required this.onReloadCallback,
  });
  final List<Event> events;
  final VoidCallback onReloadCallback;

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const Key emptyViewKey = const Key('emptyView');
  static const Key contentKey = const Key('content');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildContent(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (context, position) {
        return Stack(children: <Widget>[
          new Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Image.asset(widget.events[position].coverUrl, fit: BoxFit.cover,)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Expanded(child: Icon(Icons.account_circle, size: 40.0,), flex: 2,),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(widget.events[position].title, style: TextStyle(fontSize: 18.0),),
                              ),
                              Text(Clock.getDefaultDateTimeFormatted(widget.events[position].startDate), style: TextStyle(color: Colors.black54),)
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          flex: 9,
                        ),
                        //Expanded(child: Icon(Icons.more_vert), flex: 1,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          new Positioned.fill(
            child: new Material(
              color: Colors.transparent,
              child: new InkWell(
                onTap: () => Navigator.push<Null>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsPage(widget.events[position]),
                  ),
                ),
          )))
        ]);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (widget.events == null) ?
        InfoMessageView(
          key: emptyViewKey,
          title: 'Todo vacío!',
          description: 'No encuentro información de regularidad. ¯\\_(ツ)_/¯',
          onActionButtonTapped: widget.onReloadCallback,
        )
      :
        _buildContent(context)
    );
  }
}
