import 'package:bennit/core/common/error_text.dart';
import 'package:bennit/core/common/loader.dart';
import 'package:bennit/core/common/post_card.dart';
import 'package:bennit/features/community/controller/community_controller.dart';
import 'package:bennit/features/post/controller/post_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  int sort;
  FeedScreen({super.key, required this.sort});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sort == 2) {
      return ref.watch(userCommunitesProvider).when(
          data: (data) => ref.watch(userPostsProvider(data)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (error, stackTrace) {
                if (kDebugMode) {
                  print(error);
                }
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader()),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    if (sort == 1) {
      return ref.watch(userCommunitesProvider).when(
          data: (data) => ref.watch(topuserPostsProvider(data)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (error, stackTrace) {
                if (kDebugMode) {
                  print(error);
                }
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader()),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    if (sort == 3) {
      return ref.watch(userCommunitesProvider).when(
          data: (data) => ref.watch(olduserPostsProvider(data)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (error, stackTrace) {
                if (kDebugMode) {
                  print(error);
                }
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader()),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    if (sort == 4) {
      return ref.watch(userCommunitesProvider).when(
          data: (data) => ref.watch(bottomuserPostsProvider(data)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (error, stackTrace) {
                if (kDebugMode) {
                  print(error);
                }
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader()),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    return ref.watch(userCommunitesProvider).when(
        data: (data) => ref.watch(userPostsProvider(data)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  var post = data[index];
                  return PostCard(post: post);
                },
              );
            },
            error: (error, stackTrace) {
              if (kDebugMode) {
                print(error);
              }
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader()),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
