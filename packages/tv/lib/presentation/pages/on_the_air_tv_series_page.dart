import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/on_the_air/on_the_air_tv_series_bloc.dart';
import '../bloc/on_the_air/on_the_air_tv_series_event.dart';
import '../bloc/on_the_air/on_the_air_tv_series_state.dart';
import '../widgets/tv_series_card_list.dart';

class OnTheAirTVSeriesPage extends StatefulWidget {
  static const routeName = onTheAirTvRoute;

  const OnTheAirTVSeriesPage({super.key});

  @override
  State<OnTheAirTVSeriesPage> createState() => _OnTheAirTVSeriesPageState();
}

class _OnTheAirTVSeriesPageState extends State<OnTheAirTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<OnTheAirTVSeriesBloc>().add(FetchOnTheAirTvSeries());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTVSeriesBloc, OnTheAirTVSeriesState>(
          builder: (context, state) {
            if (state is OnTheAirTVSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnTheAirTVSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return TVSeriesCard(tv);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is OnTheAirTVSeriesError) {
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

typedef OnTheAirTvSeriesPage = OnTheAirTVSeriesPage;
