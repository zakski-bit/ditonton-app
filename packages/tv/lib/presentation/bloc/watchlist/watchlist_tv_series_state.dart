import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class WatchlistTVSeriesState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final List<TVSeries> watchlistTvSeries;
  final RequestState watchlistState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const WatchlistTVSeriesState({
    this.watchlistTvSeries = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  WatchlistTVSeriesState copyWith({
    List<TVSeries>? watchlistTvSeries,
    RequestState? watchlistState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return WatchlistTVSeriesState(
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

typedef WatchlistTvSeriesState = WatchlistTVSeriesState;
