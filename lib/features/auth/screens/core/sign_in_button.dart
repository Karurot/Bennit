import 'package:bennit/core/constants/constants.dart';
import 'package:bennit/features/auth/controller/auth_controller.dart';
import 'package:bennit/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogIn;
  const SignInButton({super.key, this.isFromLogIn = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogIn);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
          icon: Image.asset(
            Constants.googlePath,
            width: 35,
          ),
          label: const Text('Continue with google',
              style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.greyColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
    );
  }
}
