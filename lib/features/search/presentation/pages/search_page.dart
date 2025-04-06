import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/profiel/presentation/components/user_tile.dart';
import 'package:my_ui/features/search/presentation/cubits/search_cubit.dart';
import 'package:my_ui/features/search/presentation/cubits/search_states.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();
  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Search Users",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchStates>(builder: (context, state) {
        //loaded
        if (state is SearchLoaded) {
          //no users
          if (state.users.isEmpty) {
            return const Center(
              child: Text("no usrs "),
            );
          }
          return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              });
        }
        //loadingd

        else if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //error
        else if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        //default
        return const Center(
          child: Text("Start searching for users ...."),
        );
      }),
    );
  }
}
