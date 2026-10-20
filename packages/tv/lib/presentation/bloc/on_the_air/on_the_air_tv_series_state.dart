import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class OnTheAirTvSeriesState extends Equatable {
  const OnTheAirTvSeriesState();

  @override
  List<Object?> get props => [];
}

class OnTheAirTvSeriesEmpty extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoading extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoaded extends OnTheAirTvSeriesState {
  final List<TvSeries> tvSeries;

  const OnTheAirTvSeriesLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class OnTheAirTvSeriesError extends OnTheAirTvSeriesState {
  final String message;

  const OnTheAirTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
