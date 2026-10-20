import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import 'movie_recommendations_event.dart';
import 'movie_recommendations_state.dart';

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationsBloc({required this.getMovieRecommendations})
      : super(MovieRecommendationsEmpty()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(MovieRecommendationsLoading());
      final result = await getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(MovieRecommendationsError(failure.message)),
        (movies) => emit(MovieRecommendationsLoaded(movies)),
      );
    });
  }
}
