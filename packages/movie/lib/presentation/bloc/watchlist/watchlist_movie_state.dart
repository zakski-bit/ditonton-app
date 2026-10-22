import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class WatchlistMovieState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const WatchlistMovieState({
    this.watchlistMovies = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    watchlistMovies,
    watchlistState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
