import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomPageView extends StatelessWidget {
  final String assetPath;
  final String titleParam;
  final String bodyParam;

  const CustomPageView({
    required this.assetPath,
    required this.titleParam,
    required this.bodyParam,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath.isNotEmpty)
            SizedBox(
              height: 200,
              child: Lottie.asset(assetPath, fit: BoxFit.contain),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: Text('LOTTIE')),
            ),
          const SizedBox(height: 24),
          Text(
            titleParam,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            bodyParam,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
