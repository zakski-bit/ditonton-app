import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class PopularTVSeriesState extends Equatable {
  const PopularTVSeriesState();

  @override
  List<Object?> get props => [];
}

class PopularTVSeriesEmpty extends PopularTVSeriesState {}

class PopularTVSeriesLoading extends PopularTVSeriesState {}

class PopularTVSeriesLoaded extends PopularTVSeriesState {
  final List<TVSeries> tvSeries;

  const PopularTVSeriesLoaded(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class PopularTVSeriesError extends PopularTVSeriesState {
  final String message;

  const PopularTVSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}

typedef PopularTvSeriesState = PopularTVSeriesState;
typedef PopularTvSeriesEmpty = PopularTVSeriesEmpty;
typedef PopularTvSeriesLoading = PopularTVSeriesLoading;
typedef PopularTvSeriesLoaded = PopularTVSeriesLoaded;
typedef PopularTvSeriesError = PopularTVSeriesError;
