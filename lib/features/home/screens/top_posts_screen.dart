import 'package:bennit/core/constants/constants.dart';
import 'package:bennit/features/auth/controller/auth_controller.dart';
import 'package:bennit/features/home/drawers/community_list_drawer.dart';
import 'package:bennit/theme/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feed/top_screen.dart';
import '../delegates/search_community_delegate.dart';
import '../drawers/profile_drawer.dart';

class TopPostScreen extends ConsumerStatefulWidget {
  const TopPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TopPostScreenState();
}

class TopPostScreenState extends ConsumerState<TopPostScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Posts'),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          })
        ],
      ),
      body: const TopScreen(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
    );
  }
}
