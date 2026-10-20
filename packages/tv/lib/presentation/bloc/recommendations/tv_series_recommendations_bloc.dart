import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_tv_series_recommendations.dart';
import 'tv_series_recommendations_event.dart';
import 'tv_series_recommendations_state.dart';

class TvSeriesRecommendationsBloc
    extends Bloc<TvSeriesRecommendationsEvent, TvSeriesRecommendationsState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc({required this.getTvSeriesRecommendations})
      : super(TvSeriesRecommendationsEmpty()) {
    on<FetchTvSeriesRecommendations>((event, emit) async {
      emit(TvSeriesRecommendationsLoading());
      final result = await getTvSeriesRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TvSeriesRecommendationsError(failure.message)),
        (data) => emit(TvSeriesRecommendationsLoaded(data)),
      );
    });
  }
}
