import 'package:bennit/features/auth/controller/auth_controller.dart';
import 'package:bennit/features/home/drawers/community_list_drawer.dart';
import 'package:bennit/features/post/screens/add_post_screen.dart';
import 'package:bennit/theme/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../feed/feed_screen.dart';
import '../delegates/search_community_delegate.dart';
import '../drawers/profile_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int sort = 1;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onSortChanged(int page) {
    setState(() {
      sort = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              if (isGuest) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You need to be logged in to do that'),
                  ),
                );
              } else {
                navigateToAddPost(context);
              }
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.sort, color: Colors.white),
            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Pallete.redColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Top Voted")
                  ],
                ),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 2,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Pallete.redColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Newly Added")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.assist_walker_rounded, color: Pallete.redColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Oldest")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 4,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.trending_down, color: Pallete.redColor),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Top Downvoted")
                  ],
                ),
              ),
            ],
            offset: const Offset(50, 50),
            color: Colors.black,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              if (value == 1) {
                onSortChanged(1);
              }
              if (value == 2) {
                onSortChanged(2);
              }
              if (value == 3) {
                onSortChanged(3);
              }
              if (value == 4) {
                onSortChanged(4);
              }
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          }),
        ],
      ),
      body: FeedScreen(sort: sort),
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
    );
  }
}
