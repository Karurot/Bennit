import 'package:bennit/core/common/loader.dart';
import 'package:bennit/features/community/controller/community_controller.dart';
import 'package:bennit/features/community/repository/communitory_repositort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityConrollerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
  );
});

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityConrollerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityConrollerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Community name')),
                const SizedBox(height: 10),
                TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                      hintText: 'b/community_name',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                  maxLength: 21,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: createCommunity,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    'Create community',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ]),
            ),
    );
  }
}
