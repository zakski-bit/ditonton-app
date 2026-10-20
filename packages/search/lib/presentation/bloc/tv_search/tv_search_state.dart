import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object?> get props => [];
}

class SearchTvEmpty extends TvSearchState {}

class SearchTvLoading extends TvSearchState {}

class SearchTvLoaded extends TvSearchState {
  final List<TvSeries> result;

  const SearchTvLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchTvError extends TvSearchState {
  final String message;

  const SearchTvError(this.message);

  @override
  List<Object?> get props => [message];
}
