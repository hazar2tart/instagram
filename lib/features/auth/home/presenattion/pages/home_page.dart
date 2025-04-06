import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/home/presenattion/pages/components/my_drawer.dart';
import 'package:my_ui/features/post/presentation/components/post_tile.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';
import 'package:my_ui/features/post/presentation/cubits/post_states.dart';
import 'package:my_ui/features/post/presentation/pages/upload_post_pages.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit
  late final postCubit = context.read<PostCubit>();
  //on start
  @override
  void initState() {
    super.initState();

    //fetch all post
    print('Fetching all posts...');
    fetchAllPosts();

    // fetchAllPosts();
  }

  void fetchAllPosts() {
    if (postCubit.state is! PostLoaded) {
      postCubit.fetchAllPosts();
    }
  }

  void deletePost(String postId, String imageUrl) {
    postCubit.deletePosts(postId, imageUrl);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            // onPressed: () {
            //   context.read<AuthCubits>().logout();
            // },
            // icon: Icon(Icons.logout_outlined)

            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadPostPages())),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
        //loading
        if (state is PostLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //loaded
        else if (state is PostLoaded) {
          final allPosts = state.posts;
          if (allPosts == null || allPosts.isEmpty) {
            return const Center(
              child: Text("No posts "),
            );
          }
          return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                //get indi post
                final post = allPosts[index];
                // طباعة debug للمحتويات
                print('Post Index: $index');
                print('Post ID: ${post.id}');
                print('Post UserName: ${post.userName}');
                print('Post ImageURL: ${post.imageUrl}');
                print('Post Likes: ${post.likes}');
                print('Post : ${post}');
                print('Post Comments: ${post.comments}');
                print('Post Timestamp: ${post.timestamp}');
                //return
                return PostTile(
                    post: post,
                    onDeletePressed: () => deletePost(post.id, post.imageUrl));
              });
        }
        //error
        else if (state is PostError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return SizedBox();
        }
      }),
    );
  }
}
