import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/popular/popular_tv_series_bloc.dart';
import '../bloc/popular/popular_tv_series_event.dart';
import '../bloc/popular/popular_tv_series_state.dart';
import '../widgets/tv_series_card_list.dart';

class PopularTVSeriesPage extends StatefulWidget {
  static const routeName = popularTvRoute;

  const PopularTVSeriesPage({super.key});

  @override
  State<PopularTVSeriesPage> createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTVSeriesBloc>().add(FetchPopularTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVSeriesBloc, PopularTVSeriesState>(
          builder: (context, state) {
            if (state is PopularTVSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularTVSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return TVSeriesCard(tv);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is PopularTVSeriesError) {
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

typedef PopularTvSeriesPage = PopularTVSeriesPage;
