import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TVSearchState extends Equatable {
  const TVSearchState();

  @override
  List<Object?> get props => [];
}

class SearchTVEmpty extends TVSearchState {}

class SearchTVLoading extends TVSearchState {}

class SearchTVLoaded extends TVSearchState {
  final List<TVSeries> result;

  const SearchTVLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchTVError extends TVSearchState {
  final String message;

  const SearchTVError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef TvSearchState = TVSearchState;
typedef SearchTvEmpty = SearchTVEmpty;
typedef SearchTvLoading = SearchTVLoading;
typedef SearchTvLoaded = SearchTVLoaded;
typedef SearchTvError = SearchTVError;
