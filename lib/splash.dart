import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  @override
  void initState() {
    gotologin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 67, 67),
      body: Padding(
        padding: const EdgeInsets.only(top: 330.0),
        child: Column(
          children: [
            Center(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: 150,
                height: 150,
                child: Lottie.network(
                    'https://assets8.lottiefiles.com/private_files/lf30_eo1qtidn.json'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotologin() async {
    await Future.delayed(const Duration(seconds: 5));
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const HomePage(),
    ));
  }
}
