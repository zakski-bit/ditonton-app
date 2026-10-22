import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TVSeriesRecommendationsState extends Equatable {
  const TVSeriesRecommendationsState();

  @override
  List<Object?> get props => [];
}

class TVSeriesRecommendationsEmpty extends TVSeriesRecommendationsState {}

class TVSeriesRecommendationsLoading extends TVSeriesRecommendationsState {}

class TVSeriesRecommendationsLoaded extends TVSeriesRecommendationsState {
  final List<TVSeries> tvSeries;

  const TVSeriesRecommendationsLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class TVSeriesRecommendationsError extends TVSeriesRecommendationsState {
  final String message;

  const TVSeriesRecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef TvSeriesRecommendationsState = TVSeriesRecommendationsState;
typedef TvSeriesRecommendationsEmpty = TVSeriesRecommendationsEmpty;
typedef TvSeriesRecommendationsLoading = TVSeriesRecommendationsLoading;
typedef TvSeriesRecommendationsLoaded = TVSeriesRecommendationsLoaded;
typedef TvSeriesRecommendationsError = TVSeriesRecommendationsError;
