import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

@visibleForTesting
Function(String) launchTicketsUrl = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

class BookEventTimeInformation extends StatelessWidget {
  static const Key ticketsButtonKey = const Key('ticketsButton');
  static final weekdayFormat = DateFormat("E 'a las' hh:mm a");

  BookEventTimeInformation(this.bookEvent);
  final BookEvent bookEvent;

  Widget _buildTimeAndTheaterInformation() {
    var daylightText = (bookEvent.daylight == 'Y') ? "Horario de verano" : "Horario de invierno";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          weekdayFormat.format(bookEvent.start),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          "${bookEvent.startPoint} | $daylightText",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.schedule,
                color: Colors.black87,
              ),
              const SizedBox(width: 8.0),
              _buildTimeAndTheaterInformation(),
            ],
          ),
        ),
        /*const SizedBox(width: 8.0),
        RaisedButton(
          key: ticketsButtonKey,
          onPressed: () => launchTicketsUrl(show.url),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          child: const Text('Tickets'),
        ),*/
      ],
    );
  }
}
