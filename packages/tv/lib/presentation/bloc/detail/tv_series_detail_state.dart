import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object?> get props => [];
}

class TvSeriesDetailEmpty extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;

  const TvSeriesDetailLoaded(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
