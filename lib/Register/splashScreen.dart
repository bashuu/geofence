// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    callDelay(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.darkerWhite,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          )),
      child: const Text(
        'Welcome',
        textAlign: TextAlign.center,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future callDelay(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 5000), () {})
        .then((value) {
      Navigator.pushNamed(context, "/loginPage");
    });
  }
}
