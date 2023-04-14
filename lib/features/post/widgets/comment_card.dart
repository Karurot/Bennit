import 'package:bennit/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/Pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/post_controller.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  void deleteComm(WidgetRef ref, BuildContext context) async {
    ref.read(postConrollerProvider.notifier).deleteComment(comment, context);
  }

  void upvote(WidgetRef ref) async {
    ref.read(postConrollerProvider.notifier).upvoteComment(comment);
  }

  void downvote(WidgetRef ref) async {
    ref.read(postConrollerProvider.notifier).downvoteComment(comment);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  comment.profilePic,
                ),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${comment.username}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(comment.text),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: isGuest ? () {} : () => upvote(ref),
                              icon: Icon(
                                Constants.up,
                                size: 15,
                                color: comment.upvotes.contains(user.uid)
                                    ? Pallete.redColor
                                    : null,
                              ),
                            ),
                            Text(
                              '${comment.upvotes.length - comment.downvotes.length == 0 ? 'Vote' : comment.upvotes.length - comment.downvotes.length}',
                              style: const TextStyle(fontSize: 17),
                            ),
                            IconButton(
                              onPressed: isGuest ? () {} : () => downvote(ref),
                              icon: Icon(
                                Constants.down,
                                size: 15,
                                color: comment.downvotes.contains(user.uid)
                                    ? Pallete.blueColor
                                    : null,
                              ),
                            ),
                            if (comment.username == user.name)
                              IconButton(
                                onPressed: () => deleteComm(ref, context),
                                icon: Icon(
                                  size: 15,
                                  Icons.delete,
                                  color: Pallete.redColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
