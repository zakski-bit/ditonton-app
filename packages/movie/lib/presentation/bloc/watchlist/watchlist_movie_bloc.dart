import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_watchlist_movies.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistMovieState()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.loading));
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            watchlistState: RequestState.error,
            message: failure.message,
          ),
        ),
        (movies) => emit(
          state.copyWith(
            watchlistState: RequestState.loaded,
            watchlistMovies: movies,
          ),
        ),
      );
    });

    on<LoadWatchlistMovieStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });

    on<AddWatchlistMovie>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) => emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: true,
          ),
        ),
      );
    });

    on<RemoveWatchlistMovie>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) => emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: false,
          ),
        ),
      );
    });
  }
}
