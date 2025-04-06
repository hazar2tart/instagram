import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/profiel/presentation/components/bio_box.dart';
import 'package:my_ui/features/auth/profiel/presentation/components/follow_button.dart';
import 'package:my_ui/features/auth/profiel/presentation/components/profile_stats.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_states.dart';
import 'package:my_ui/features/auth/profiel/presentation/pages/edit_profiel_page.dart';
import 'package:my_ui/features/auth/profiel/presentation/pages/follower_page.dart';
import 'package:my_ui/features/post/presentation/components/post_tile.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';
import 'package:my_ui/features/post/presentation/cubits/post_states.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class ProfielPage extends StatefulWidget {
  final String uid;
  const ProfielPage({super.key, required this.uid});

  @override
  State<ProfielPage> createState() => _ProfielPageState();
}

class _ProfielPageState extends State<ProfielPage> {
  //cubits
  late final authCubits = context.read<AuthCubits>();
  late AppUser? currentUser = authCubits.currentUser;
  late final profielCubit = context.read<ProfielCubit>();
  int postCount = 0;
  @override
  void initState() {
    super.initState();
    //load user profiel
    if (profielCubit.state is! ProfielLoaded) {
      profielCubit.fetchUserProfiel(widget.uid);
    }
  }

  void followButtonPressed() {
    final profileState = profielCubit.state;
    if (profileState is! ProfielLoaded) {
      return;
    }
    final profileUser = profileState.profielUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);
    // optim upload ui
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profielCubit.toogleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        //unf
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnPost = (widget.uid == currentUser!.uid);
    // appBar: AppBar(
    return BlocBuilder<ProfielCubit, ProfielStates>(
      builder: (context, state) {
        if (state is ProfielLoaded) {
          //get loa
          final user = state.profielUser;
          print("Profile Image URL: ${user.profielImageUrl}");

          return ConstrainedScaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                //edit pr
                if (isOwnPost)
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilPage(
                                    user: user,
                                  ))),
                      icon: Icon(Icons.settings))
              ],
            ),
            body: ListView(
              children: [
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.secondary,
                //       borderRadius: BorderRadius.circular(12)),
                //   height: 120,
                //   width: 120,
                //   padding: const EdgeInsets.all(25),
                //   child: Center(
                //     child: Icon(
                //       Icons.person,
                //       size: 72,
                //       color: Theme.of(context).colorScheme.primary,
                //     ),
                //   ),
                // ),
                CachedNetworkImage(
                  imageUrl: user.profielImageUrl ?? '',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(), // ✅ Correction
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person, size: 72), // ✅ Correction
                  imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                      child: Image(image: imageProvider)),
                  fit: BoxFit.cover, // ✅ Correction
                ),

                const SizedBox(
                  height: 25,
                ),

                ProfileStats(
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  postCount: postCount,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerPage(
                            followers: user.followers,
                            following: user.following),
                      )),
                ),

                const SizedBox(
                  height: 25,
                ),
                if (!isOwnPost)
                  FollowButton(
                      isFollowing: user.followers.contains(currentUser!.uid),
                      onPressed: followButtonPressed),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Bio',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      //  BioBox(text: user.bio)
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                BioBox(text: user.bio),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      //  BioBox(text: user.bio)
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
//loaded
                  if (state is PostLoaded) {
                    print("widget.uid: ${widget.uid}");
                    print("state.posts: ${state.posts.length}");
                    //filter post by user id
                    final userPosts = state.posts
                        .where((post) => post.userId == widget.uid)
                        .toList();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        postCount = userPosts.length;
                      });
                    });
                    print("postcont : $postCount");

                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postCount,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
                          return PostTile(
                              post: post,
                              onDeletePressed: () => context
                                  .read<PostCubit>()
                                  .deletePosts(post.id, post.imageUrl));
                        });
                  }
//laod
                  else if (state is PostLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Center(child: Text("no jdrij"));
                  }
                }),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          );
        } else if (state is ProfielLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Center(
            child: Text("No profil "),
          );
        }
      },
      //   title: Text(currentUser!.email),
      //   foregroundColor: Theme.of(context).colorScheme.primary,
      // ),
    );
  }
}
