import 'dart:io';
import 'package:bennit/core/enums/enums.dart';
import 'package:bennit/core/providers/storage_repository_provider.dart';
import 'package:bennit/core/utils.dart';
import 'package:bennit/features/auth/controller/auth_controller.dart';
import 'package:bennit/features/post/repository/post_repository.dart';
import 'package:bennit/features/user_profile/controller/user_profile_controller.dart';
import 'package:bennit/models/comment_model.dart';
import 'package:bennit/models/community_model.dart';
import 'package:bennit/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postConrollerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchUserPosts(communities);
});
final topuserPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchTopUserPosts(communities);
});

final olduserPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchOldUserPosts(communities);
});

final bottomuserPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchBottomUserPosts(communities);
});

final topPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchTopPosts(communities);
});

final getPostByIDProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postConrollerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String desciption,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: desciption,
      voteCount: 0,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Post shared successfully');
      Routemaster.of(context).push('/');
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
      voteCount: 0,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Post shared successfully');
      Routemaster.of(context).push('/');
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
        voteCount: 0,
      );
      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Post shared successfully');
        Routemaster.of(context).push('/');
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(
        communities,
      );
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchTopUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchTopUserPosts(
        communities,
      );
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchOldUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchOldUserPosts(
        communities,
      );
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchBottomUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchBottomUserPosts(
        communities,
      );
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchTopPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchTopPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold((l) => null, (r) => showSnackBar(context, 'Post deleted'));
  }

  void deleteComment(Comment comment, BuildContext context) async {
    final res = await _postRepository.deleteComment(comment);
    res.fold((l) => null, (r) => showSnackBar(context, 'comment deleted'));
  }

  void upvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void upvoteComment(Comment comment) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvoteComment(comment, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  void downvoteComment(Comment comment) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvoteComment(comment, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
      upvotes: [],
      downvotes: [],
      voteCount: 0,
    );
    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
