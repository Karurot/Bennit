import 'package:bennit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToType(context, 'image'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: const Color.fromRGBO(255, 255, 255, 0.1),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'text'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: const Color.fromRGBO(255, 255, 255, 0.1),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'link'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: const Color.fromRGBO(255, 255, 255, 0.1),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                  color: currentTheme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
