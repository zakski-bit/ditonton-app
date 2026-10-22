import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_popular_tv_series.dart';
import 'popular_tv_series_event.dart';
import 'popular_tv_series_state.dart';

class PopularTVSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTVSeriesState> {
  final GetPopularTVSeries getPopularTvSeries;

  PopularTVSeriesBloc({required this.getPopularTvSeries})
    : super(PopularTVSeriesEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTVSeriesLoading());
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(PopularTVSeriesError(failure.message)),
        (data) => emit(PopularTVSeriesLoaded(data)),
      );
    });
  }
}

typedef PopularTvSeriesBloc = PopularTVSeriesBloc;
