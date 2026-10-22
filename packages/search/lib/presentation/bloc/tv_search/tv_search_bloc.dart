import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/search_tv_series.dart';
import '../event_transformer.dart';
import 'tv_search_event.dart';
import 'tv_search_state.dart';

class TVSearchBloc extends Bloc<TVSearchEvent, TVSearchState> {
  final SearchTVSeries searchTvSeries;

  TVSearchBloc({required this.searchTvSeries}) : super(SearchTVEmpty()) {
    on<OnTVQueryChanged>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(SearchTVEmpty());
        return;
      }

      emit(SearchTVLoading());
      final result = await searchTvSeries.execute(query);
      result.fold(
        (failure) => emit(SearchTVError(failure.message)),
        (data) => emit(SearchTVLoaded(data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

typedef TvSearchBloc = TVSearchBloc;
