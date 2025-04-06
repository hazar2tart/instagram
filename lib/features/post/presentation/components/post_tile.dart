import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_text_field.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/auth/profiel/presentation/pages/profiel_page.dart';
import 'package:my_ui/features/post/domain/entities/post.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';
import 'package:my_ui/features/post/presentation/components/comment_tile.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';
import 'package:my_ui/features/post/presentation/cubits/post_states.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
//cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfielCubit>();
  bool isownpost = true;
  //curent user
  AppUser? currentUser;
  //prof
  ProfielUser? postUser;
  Post? post;
  @override

  // TODO: implement ==
  void initState() {
    super.initState();
    getCurentUser();
    fetchPostUser();
    //  fetchAllPosts();
  }

  void fetchAllPosts() {
    if (postCubit.state is! PostLoaded) {
      postCubit.fetchAllPosts();
    }
  }

  void getCurentUser() {
    final authCubit = context.read<AuthCubits>();
    currentUser = authCubit.currentUser;
    // isownpost = widget.post.userId == currentUser!.uid;
    if (currentUser != null && widget.post.userId != null) {
      isownpost = widget.post.userId == currentUser!.uid;
    }
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      print("Fetched user: $fetchUser");
      if (!mounted) return;
      setState(() {
        postUser = fetchUser;
      });
      print("PostUser: $postUser");
    }
  }

  void toggleLikesPost() {
    //current likes
    final isLikes =
        currentUser != null && widget.post.likes.contains(currentUser!.uid);
    if (!mounted) return;
    setState(() {
      if (isLikes) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    //upfadte
    postCubit
        .toogleLikesPost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      if (!mounted) return;
      setState(() {
        if (isLikes) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

//coment
  final commentTextcontroller = TextEditingController();
  //oopen cmnt box
  void openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              //  title: Text("Add a new comment "),
              content: MyTextField(
                  controller: commentTextcontroller,
                  hinText: "Type a comment",
                  obscureText: false),
              actions: [
                // cancel button

                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel")),
                //save button
                TextButton(
                    onPressed: () {
                      addComment();
                      Navigator.of(context).pop();
                    },
                    child: const Text("done")),
              ],
            ));
  }

  void addComment() {
    // craet a new cmnt
    final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: widget.post.id,
        text: commentTextcontroller.text,
        timestamp: DateTime.now(),
        // userId: widget.post.userId,
        userId: currentUser!.uid,
        //  userName: widget.post.userName
        userName: currentUser!.name);
    // ad cmnt using cubit
    if (commentTextcontroller.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextcontroller.dispose();
    super.dispose();
  }

//show options for delete
  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delte post "),
              actions: [
                //canc
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("cancel")),
                //dele
                TextButton(
                  onPressed: () async {
                    print("Delete button pressed");

                    try {
                      widget.onDeletePressed!();
                      print("Delete operation completed");
                    } catch (e) {
                      print("Error during delete: $e");
                    }

                    Navigator.of(context).pop(); // إغلاق النافذة بعد الحذف
                  },
                  child: Text("Delete"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const CircularProgressIndicator();
    }
    print("PostUser: $postUser");
    if (postUser == null) {
      print("PostUser is still null, not rendering yet.");
      return const SizedBox(); // أو return CircularProgressIndicator();
    }
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //top sec , profile , name , delety
          //name

          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfielPage(uid: widget.post.userId))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postUser?.profielImageUrl != null &&
                          postUser!.profielImageUrl.isNotEmpty
                      ? Flexible(
                          child: CachedNetworkImage(
                              imageUrl: postUser!.profielImageUrl,
                              errorWidget: (context, url, error) {
                                print(
                                    "Image URL: ${postUser?.profielImageUrl}");

                                // Debugging the error
                                print("Error loading image: $url, $error");
                                return const Icon(Icons.person);
                              },
                              imageBuilder: (context, imageProvider) {
                                // Debugging the image URL
                                print(
                                    "Loading image URL: ${postUser!.profielImageUrl}");
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                );
                              }),
                        )
                      : Icon(Icons.person),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  const SizedBox(
                    width: 260,
                  ),
                  //delet
                  if (isownpost)
                    GestureDetector(
                        onTap: showOptions,
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.primary,
                        ))
                ],
              ),
            ),
          ),
          //image
          widget.post.imageUrl.isNotEmpty &&
                  Uri.tryParse(widget.post.imageUrl)?.isAbsolute == true
              ? CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  height: 430,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 430,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : const Icon(Icons.person),

          //buttons > likes ., comment , timestamp
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    //lo
                    SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: toggleLikesPost,
                              child: Icon(
                                widget.post.likes.contains(currentUser!.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    widget.post.likes.contains(currentUser!.uid)
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.post.likes.length.toString(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //com
                    GestureDetector(
                        onTap: openNewCommentBox, child: Icon(Icons.comment)),
                    Text(widget.post.comments.length.toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Spacer(),
                    //timest
                    Text(widget.post.timestamp.toString()),
                  ],
                ),
              ),
              //vcapt
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      widget.post.userName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.post.text)
                  ],
                ),
              ),
              //cmnt section
              BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
                //loaded
                if (state is PostLoaded) {
                  //final
                  final post = state.posts
                      .firstWhere((post) => (post.id == widget.post.id));
                  if (post.comments.isNotEmpty) {
                    int showCommentCount = post.comments.length;
                    //comnt sec
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: showCommentCount,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          //cmnt tirl
                          return CommentTile(
                            comment: comment,
                          );
                        });
                  }
                }
                if (state is PostLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //erer
                else if (state is PostError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return const Center(
                    child: Text("Somenthing went wrong,.."),
                  );
                }
              })
            ],
          )
        ],
      ),
    );
  }
}
