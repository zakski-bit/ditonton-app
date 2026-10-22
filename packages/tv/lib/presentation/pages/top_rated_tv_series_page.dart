import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/top_rated/top_rated_tv_series_bloc.dart';
import '../bloc/top_rated/top_rated_tv_series_event.dart';
import '../bloc/top_rated/top_rated_tv_series_state.dart';
import '../widgets/tv_series_card_list.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const routeName = topRatedTvRoute;

  const TopRatedTVSeriesPage({super.key});

  @override
  State<TopRatedTVSeriesPage> createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTVSeriesBloc>().add(FetchTopRatedTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTVSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTVSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return TVSeriesCard(tv);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is TopRatedTVSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

typedef TopRatedTvSeriesPage = TopRatedTVSeriesPage;
