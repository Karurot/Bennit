import 'package:bennit/core/common/error_text.dart';
import 'package:bennit/core/common/loader.dart';
import 'package:bennit/core/common/post_card.dart';
import 'package:bennit/features/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class commentScreen extends ConsumerStatefulWidget {
  final String postId;
  const commentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _commentScreenState();
}

class _commentScreenState extends ConsumerState<commentScreen> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIDProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(
                  post: data,
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment',
                    filled: true,
                    border: InputBorder.none,
                  ),
                )
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
