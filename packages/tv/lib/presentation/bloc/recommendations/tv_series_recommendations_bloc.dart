import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_tv_series_recommendations.dart';
import 'tv_series_recommendations_event.dart';
import 'tv_series_recommendations_state.dart';

class TVSeriesRecommendationsBloc
    extends Bloc<TvSeriesRecommendationsEvent, TVSeriesRecommendationsState> {
  final GetTVSeriesRecommendations getTvSeriesRecommendations;

  TVSeriesRecommendationsBloc({required this.getTvSeriesRecommendations})
    : super(TVSeriesRecommendationsEmpty()) {
    on<FetchTvSeriesRecommendations>((event, emit) async {
      emit(TVSeriesRecommendationsLoading());
      final result = await getTvSeriesRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TVSeriesRecommendationsError(failure.message)),
        (data) => emit(TVSeriesRecommendationsLoaded(data)),
      );
    });
  }
}

typedef TvSeriesRecommendationsBloc = TVSeriesRecommendationsBloc;
