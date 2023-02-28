import 'package:bennit/core/common/error_text.dart';
import 'package:bennit/core/common/loader.dart';
import 'package:bennit/features/auth/controller/auth_controller.dart';
import 'package:bennit/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMod() {
    ref.read(communityConrollerProvider.notifier).addMods(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMod,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];

                  return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member)) {
                          uids.add(member);
                        }
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                      loading: () => const Loader());
                },
              ),
          error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
          loading: () => const Loader()),
    );
  }
}
