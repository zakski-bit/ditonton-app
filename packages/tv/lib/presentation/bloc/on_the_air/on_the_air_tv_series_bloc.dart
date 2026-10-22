import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_on_the_air_tv_series.dart';
import 'on_the_air_tv_series_event.dart';
import 'on_the_air_tv_series_state.dart';

class OnTheAirTVSeriesBloc
    extends Bloc<OnTheAirTvSeriesEvent, OnTheAirTVSeriesState> {
  final GetOnTheAirTVSeries getOnTheAirTvSeries;

  OnTheAirTVSeriesBloc({required this.getOnTheAirTvSeries})
    : super(OnTheAirTVSeriesEmpty()) {
    on<FetchOnTheAirTvSeries>((event, emit) async {
      emit(OnTheAirTVSeriesLoading());
      final result = await getOnTheAirTvSeries.execute();
      result.fold(
        (failure) => emit(OnTheAirTVSeriesError(failure.message)),
        (data) => emit(OnTheAirTVSeriesLoaded(data)),
      );
    });
  }
}

typedef OnTheAirTvSeriesBloc = OnTheAirTVSeriesBloc;
