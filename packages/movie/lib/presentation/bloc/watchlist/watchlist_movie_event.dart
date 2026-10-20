import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {}

class LoadWatchlistMovieStatus extends WatchlistMovieEvent {
  final int id;

  const LoadWatchlistMovieStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlistMovie extends WatchlistMovieEvent {
  final MovieDetail movie;

  const AddWatchlistMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveWatchlistMovie extends WatchlistMovieEvent {
  final MovieDetail movie;

  const RemoveWatchlistMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}
