import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_top_rated_tv_series.dart';
import 'top_rated_tv_series_event.dart';
import 'top_rated_tv_series_state.dart';

class TopRatedTVSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTVSeriesState> {
  final GetTopRatedTVSeries getTopRatedTvSeries;

  TopRatedTVSeriesBloc({required this.getTopRatedTvSeries})
    : super(TopRatedTVSeriesEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTVSeriesLoading());
      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TopRatedTVSeriesError(failure.message)),
        (data) => emit(TopRatedTVSeriesLoaded(data)),
      );
    });
  }
}

typedef TopRatedTvSeriesBloc = TopRatedTVSeriesBloc;
