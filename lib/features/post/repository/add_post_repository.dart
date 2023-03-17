import 'package:bennit/core/providers/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityRepositoryProvider = Provider((ref) {
  return AddPostRepository(firestore: ref.watch(firestoreProvider));
});

class AddPostRepository {
  final FirebaseFirestore _firestore;
  AddPostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
}
