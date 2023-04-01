import 'package:bennit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                navigateToUserProfile(context, user.uid);
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            ),
            GestureDetector(
              onTap: () async {
                Uri url = Uri.https('applications.bennett.edu.in');
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                    );
                  } else {
                    throw 'Could not launch $url';
                  }
                } catch (_) {}
              }, // Image tapped
              child: Image.asset(
                'assets/images/bennett-mobile-banner.jpg',
                fit: BoxFit.cover, // Fixes border issues
              ),
            )
          ],
        ),
      ),
    );
  }
}
