import 'package:leptisapp/data/models/actor.dart';
import 'package:leptisapp/data/models/event.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/escort.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/data/models/theater.dart';

class InitAction {}

class InitCompleteAction {
  InitCompleteAction(
    this.theaters,
    this.selectedTheater,
  );

  final List<Theater> theaters;
  final Theater selectedTheater;
}
class InitComplete2Action {
  InitComplete2Action({this.escorts, this.weathers});

  final List<Escort> escorts;
  final List<Weather> weathers;
}

class ChangeCurrentTheaterAction {
  ChangeCurrentTheaterAction(this.selectedTheater);
  final Theater selectedTheater;
}

/*class ChangeCurrentBookEventAction {
  ChangeCurrentBookEventAction(this.selectedBookEvent);
  final BookEvent selectedBookEvent;
}*/

class UpdateActorsForEventAction {
  UpdateActorsForEventAction(this.event, this.actors);

  final Event event;
  final List<Actor> actors;
}

class UpdateMembersForBookEventAction {
  UpdateMembersForBookEventAction(this.bookEvent, this.members);

  final BookEvent bookEvent;
  final List<Member> members;
}

class UpdateEscortForBookEventAction {
  UpdateEscortForBookEventAction(this.bookEvent, this.escort);

  final BookEvent bookEvent;
  final List<Member> escort;
}

class UpdateMapCoverForBookEventAction {
  UpdateMapCoverForBookEventAction(this.bookEvent, this.mapCoverUrl);

  final BookEvent bookEvent;
  final String mapCoverUrl;
}

class UpdateWeatherForBookEventAction {
  UpdateWeatherForBookEventAction({this.bookEvent, this.weather});

  final BookEvent bookEvent;
  final Weather weather;
}