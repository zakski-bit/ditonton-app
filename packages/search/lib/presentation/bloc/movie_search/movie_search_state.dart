import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object?> get props => [];
}

class SearchMovieEmpty extends MovieSearchState {}

class SearchMovieLoading extends MovieSearchState {}

class SearchMovieLoaded extends MovieSearchState {
  final List<Movie> result;

  const SearchMovieLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchMovieError extends MovieSearchState {
  final String message;

  const SearchMovieError(this.message);

  @override
  List<Object?> get props => [message];
}
