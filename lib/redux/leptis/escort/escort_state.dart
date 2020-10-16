import 'package:leptisapp/data/models/leptis/escort.dart';
import 'package:meta/meta.dart';

@immutable
class EscortState {
  EscortState({
    @required this.escorts,
  });

  final List<Escort> escorts;

  factory EscortState.initial() {
    return EscortState(
      escorts: <Escort>[],
    );
  }

  EscortState copyWith({
    List<Escort> escorts,
  }) {
    return EscortState(
      escorts: escorts ?? this.escorts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EscortState &&
              runtimeType == other.runtimeType &&
              escorts == other.escorts;

  @override
  int get hashCode =>
      escorts.hashCode;
}