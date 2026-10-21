import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class WatchlistTvSeriesState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final List<TvSeries> watchlistTvSeries;
  final RequestState watchlistState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const WatchlistTvSeriesState({
    this.watchlistTvSeries = const [],
    this.watchlistState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  WatchlistTvSeriesState copyWith({
    List<TvSeries>? watchlistTvSeries,
    RequestState? watchlistState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return WatchlistTvSeriesState(
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    watchlistTvSeries,
    watchlistState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
