import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/presentation/components/user_tile.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage(
      {super.key, required this.followers, required this.following});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, "No Followers", context),
            _buildUserList(following, "No Following", context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(
            child: Text(emptyMessage),
          )
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder<ProfielUser?>(
                future: context.read<ProfielCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  } else if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  } else {
                    return const ListTile(
                      title: Text("User not found"),
                    );
                  }
                },
              );
            },
          );
  }
}
