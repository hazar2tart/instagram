import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/domain/entities/app_user.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/post/domain/entities/comment.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authcubit = context.read<AuthCubits>();
    currentUser = authcubit.currentUser;
    isOwnPost = widget.comment.userId == currentUser!.uid;
  }

  void showOptions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delte comment"),
              actions: [
                //canc
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("cancel")),
                //dele
                TextButton(
                    onPressed: () {
                      context.read<PostCubit>().deleteComment(
                          widget.comment.postId, widget.comment.id);
                      Navigator.of(context).pop();
                    },
                    child: Text("delete")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          //name
          Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: 10,
          ),
          //cmnt text
          Text(widget.comment.text),
          const Spacer(),
          //delet button
          if (isOwnPost)
            GestureDetector(
                onTap: showOptions,
                child: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ))
        ],
      ),
    );
  }
}
