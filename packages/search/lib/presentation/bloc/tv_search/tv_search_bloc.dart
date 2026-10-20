import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_tv_series.dart';
import '../event_transformer.dart';
import 'tv_search_event.dart';
import 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSearchBloc({required this.searchTvSeries}) : super(SearchTvEmpty()) {
    on<OnTvQueryChanged>(
      (event, emit) async {
        final query = event.query;
        if (query.isEmpty) {
          emit(SearchTvEmpty());
          return;
        }

        emit(SearchTvLoading());
        final result = await searchTvSeries.execute(query);
        result.fold(
          (failure) => emit(SearchTvError(failure.message)),
          (data) => emit(SearchTvLoaded(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
