import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}

class LoadWatchlistTvSeriesStatus extends WatchlistTvSeriesEvent {
  final int id;

  const LoadWatchlistTvSeriesStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlistTvSeries extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  const AddWatchlistTvSeries(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class RemoveWatchlistTvSeries extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  const RemoveWatchlistTvSeries(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}
