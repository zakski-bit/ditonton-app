import 'package:equatable/equatable.dart';

abstract class TVSearchEvent extends Equatable {
  const TVSearchEvent();

  @override
  List<Object?> get props => [];
}

class OnTVQueryChanged extends TVSearchEvent {
  final String query;

  const OnTVQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

typedef TvSearchEvent = TVSearchEvent;
typedef OnTvQueryChanged = OnTVQueryChanged;
