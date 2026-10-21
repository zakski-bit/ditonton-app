import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_movie_detail.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({required this.getMovieDetail}) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await getMovieDetail.execute(event.id);
      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movieDetail) => emit(MovieDetailLoaded(movieDetail)),
      );
    });
  }
}
