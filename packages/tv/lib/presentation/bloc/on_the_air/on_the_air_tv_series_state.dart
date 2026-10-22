import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class OnTheAirTVSeriesState extends Equatable {
  const OnTheAirTVSeriesState();

  @override
  List<Object?> get props => [];
}

class OnTheAirTVSeriesEmpty extends OnTheAirTVSeriesState {}

class OnTheAirTVSeriesLoading extends OnTheAirTVSeriesState {}

class OnTheAirTVSeriesLoaded extends OnTheAirTVSeriesState {
  final List<TVSeries> tvSeries;

  const OnTheAirTVSeriesLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class OnTheAirTVSeriesError extends OnTheAirTVSeriesState {
  final String message;

  const OnTheAirTVSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef OnTheAirTvSeriesState = OnTheAirTVSeriesState;
typedef OnTheAirTvSeriesEmpty = OnTheAirTVSeriesEmpty;
typedef OnTheAirTvSeriesLoading = OnTheAirTVSeriesLoading;
typedef OnTheAirTvSeriesLoaded = OnTheAirTVSeriesLoaded;
typedef OnTheAirTvSeriesError = OnTheAirTVSeriesError;
