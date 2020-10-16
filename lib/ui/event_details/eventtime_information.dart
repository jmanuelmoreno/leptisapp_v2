import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/event.dart';
import 'package:intl/intl.dart';
import 'package:leptisapp/utils/widget_utils.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

@visibleForTesting
Function(String) launchTicketsUrl = (url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
};

class EventtimeInformation extends StatelessWidget {
  static final weekdayFormat = DateFormat("d 'de' MMMM 'de' y");
  static final weekdayShortFormat = DateFormat("d 'de' MMM 'de' y");
  static final hourFormat = DateFormat("hh:mm a");

  EventtimeInformation(this.event);
  final Event event;

  Widget _buildDateInformation() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: _dateInformation(),
    );
  }

  Widget _dateInformation() {
    String dateInfo = event.endDate == null?
      weekdayFormat.format(event.startDate) : "Del ${weekdayShortFormat.format(event.startDate)} al ${weekdayShortFormat.format(event.endDate)}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.calendar_today,
                color: Colors.black87,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    dateInfo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInformation() {
    if (event.hasHour) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 0.0,
        ),
        child: _timeInformation(),
      );
    }
    return null;
  }

  Widget _timeInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.access_time,
                color: Colors.black87,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    hourFormat.format(event.hour),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      _buildDateInformation(),
    ];

    addIfNonNull(_buildTimeInformation(), content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content
    );
  }
}
