import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_watchlist_status_tv.dart';
import '../../../domain/usecases/get_watchlist_tv_series.dart';
import '../../../domain/usecases/remove_watchlist_tv.dart';
import '../../../domain/usecases/save_watchlist_tv.dart';
import 'watchlist_tv_series_event.dart';
import 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final GetWatchlistStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const WatchlistTvSeriesState()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.Loading));
      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (failure) => emit(state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        )),
        (tvSeries) => emit(state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: tvSeries,
        )),
      );
    });

    on<LoadWatchlistTvSeriesStatus>((event, emit) async {
      final result = await getWatchListStatusTv.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });

    on<AddWatchlistTvSeries>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tvSeries);
      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) => emit(state.copyWith(
          watchlistMessage: successMessage,
          isAddedToWatchlist: true,
        )),
      );
    });

    on<RemoveWatchlistTvSeries>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tvSeries);
      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) => emit(state.copyWith(
          watchlistMessage: successMessage,
          isAddedToWatchlist: false,
        )),
      );
    });
  }
}
