import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/regularity_history.dart';

class RegularityHistoryList extends StatefulWidget {
  RegularityHistoryList({
    @required this.regularityHistory,
  });
  final List<RegularityHistory> regularityHistory;

  @override
  _RegularityHistoryListState createState() => _RegularityHistoryListState();
}

class _RegularityHistoryListState extends State<RegularityHistoryList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: widget.regularityHistory.map((data) => new ListTile(
        title: new Center(child: new Text(data.date,
          style: new TextStyle(
              fontWeight: FontWeight.w500, fontSize: 22.0),)),
      )).toList(),
    );
  }
}
