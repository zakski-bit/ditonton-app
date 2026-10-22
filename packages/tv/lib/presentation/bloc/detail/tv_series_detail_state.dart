import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TVSeriesDetailState extends Equatable {
  const TVSeriesDetailState();

  @override
  List<Object?> get props => [];
}

class TVSeriesDetailEmpty extends TVSeriesDetailState {}

class TVSeriesDetailLoading extends TVSeriesDetailState {}

class TVSeriesDetailLoaded extends TVSeriesDetailState {
  final TVSeriesDetail tvSeriesDetail;

  const TVSeriesDetailLoaded(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class TVSeriesDetailError extends TVSeriesDetailState {
  final String message;

  const TVSeriesDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef TvSeriesDetailState = TVSeriesDetailState;
typedef TvSeriesDetailEmpty = TVSeriesDetailEmpty;
typedef TvSeriesDetailLoading = TVSeriesDetailLoading;
typedef TvSeriesDetailLoaded = TVSeriesDetailLoaded;
typedef TvSeriesDetailError = TVSeriesDetailError;
