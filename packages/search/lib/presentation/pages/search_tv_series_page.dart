import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';

import '../bloc/tv_search/tv_search_bloc.dart';
import '../bloc/tv_search/tv_search_event.dart';
import '../bloc/tv_search/tv_search_state.dart';

class SearchTVSeriesPage extends StatelessWidget {
  static const routeName = searchTvRoute;

  const SearchTVSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<TVSearchBloc>().add(OnTVQueryChanged(query));
              },
              onSubmitted: (query) {
                context.read<TVSearchBloc>().add(OnTVQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search, color: mikadoYellow),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mikadoYellow),
                ),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: heading6),
            BlocBuilder<TVSearchBloc, TVSearchState>(
              builder: (context, state) {
                if (state is SearchTVLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchTVLoaded) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return TVSeriesCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTVError) {
                  return Center(
                    key: const Key('error_message'),
                    child: Text(state.message),
                  );
                } else {
                  return const Expanded(child: SizedBox());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

typedef SearchTvSeriesPage = SearchTVSeriesPage;
