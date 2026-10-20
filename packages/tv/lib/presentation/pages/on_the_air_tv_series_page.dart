import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/on_the_air/on_the_air_tv_series_bloc.dart';
import '../bloc/on_the_air/on_the_air_tv_series_event.dart';
import '../bloc/on_the_air/on_the_air_tv_series_state.dart';
import '../widgets/tv_series_card_list.dart';

class OnTheAirTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = ON_THE_AIR_TV_ROUTE;

  const OnTheAirTvSeriesPage({Key? key}) : super(key: key);

  @override
  _OnTheAirTvSeriesPageState createState() => _OnTheAirTvSeriesPageState();
}

class _OnTheAirTvSeriesPageState extends State<OnTheAirTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<OnTheAirTvSeriesBloc>().add(FetchOnTheAirTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
          builder: (context, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return TvSeriesCard(tv);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is OnTheAirTvSeriesError) {
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
