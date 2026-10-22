import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_tv_series_detail.dart';
import 'tv_series_detail_event.dart';
import 'tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TVSeriesDetailState> {
  final GetTVSeriesDetail getTvSeriesDetail;

  TVSeriesDetailBloc({required this.getTvSeriesDetail})
    : super(TVSeriesDetailEmpty()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TVSeriesDetailLoading());
      final result = await getTvSeriesDetail.execute(event.id);
      result.fold(
        (failure) => emit(TVSeriesDetailError(failure.message)),
        (data) => emit(TVSeriesDetailLoaded(data)),
      );
    });
  }
}

typedef TvSeriesDetailBloc = TVSeriesDetailBloc;
