import 'package:bennit/core/constants/firebase_constants.dart';
import 'package:bennit/core/failure.dart';
import 'package:bennit/core/providers/firebase_providers.dart';
import 'package:bennit/core/type_def.dart';
import 'package:bennit/models/comment_model.dart';
import 'package:bennit/models/community_model.dart';
import 'package:bennit/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Post>> fetchTopPosts(List<Community> communities) {
    return _posts.orderBy('voteCount', descending: true).snapshots().map(
        (event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(1),
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(1),
      });
    }
  }

  void upvoteComment(Comment comment, String userId) async {
    if (comment.downvotes.contains(userId)) {
      _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
      _comments.doc(comment.id).update({
        'voteCount': FieldValue.increment(1),
      });
    }

    if (comment.upvotes.contains(userId)) {
      _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
      _posts.doc(comment.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    } else {
      _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
      _comments.doc(comment.id).update({
        'voteCount': FieldValue.increment(1),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(1),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
      _posts.doc(post.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    }
  }

  void downvoteComment(Comment comment, String userId) async {
    if (comment.upvotes.contains(userId)) {
      _comments.doc(comment.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
      _comments.doc(comment.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    }

    if (comment.downvotes.contains(userId)) {
      _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
      _comments.doc(comment.id).update({
        'voteCount': FieldValue.increment(1),
      });
    } else {
      _comments.doc(comment.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
      _comments.doc(comment.id).update({
        'voteCount': FieldValue.increment(-1),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
