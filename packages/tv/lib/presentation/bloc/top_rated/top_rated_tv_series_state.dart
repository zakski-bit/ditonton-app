import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedTVSeriesState extends Equatable {
  const TopRatedTVSeriesState();

  @override
  List<Object?> get props => [];
}

class TopRatedTVSeriesEmpty extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoading extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoaded extends TopRatedTVSeriesState {
  final List<TVSeries> tvSeries;

  const TopRatedTVSeriesLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class TopRatedTVSeriesError extends TopRatedTVSeriesState {
  final String message;

  const TopRatedTVSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef TopRatedTvSeriesState = TopRatedTVSeriesState;
typedef TopRatedTvSeriesEmpty = TopRatedTVSeriesEmpty;
typedef TopRatedTvSeriesLoading = TopRatedTVSeriesLoading;
typedef TopRatedTvSeriesLoaded = TopRatedTVSeriesLoaded;
typedef TopRatedTvSeriesError = TopRatedTVSeriesError;
