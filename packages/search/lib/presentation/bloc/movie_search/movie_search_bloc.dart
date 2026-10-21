import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/search_movies.dart';
import '../event_transformer.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(SearchMovieEmpty()) {
    on<OnMovieQueryChanged>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(SearchMovieEmpty());
        return;
      }

      emit(SearchMovieLoading());
      final result = await searchMovies.execute(query);
      result.fold(
        (failure) => emit(SearchMovieError(failure.message)),
        (data) => emit(SearchMovieLoaded(data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
