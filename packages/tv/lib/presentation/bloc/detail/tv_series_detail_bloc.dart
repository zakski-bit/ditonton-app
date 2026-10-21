import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_tv_series_detail.dart';
import 'tv_series_detail_event.dart';
import 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailBloc({required this.getTvSeriesDetail})
    : super(TvSeriesDetailEmpty()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());
      final result = await getTvSeriesDetail.execute(event.id);
      result.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (data) => emit(TvSeriesDetailLoaded(data)),
      );
    });
  }
}
