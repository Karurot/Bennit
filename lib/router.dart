import 'package:bennit/features/auth/screens/login_screen.dart';
import 'package:bennit/features/community/screens/community_screen.dart';
import 'package:bennit/features/community/screens/create_community_screen.dart';
import 'package:bennit/features/home/screens/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/b/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
});
