import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class CustomPageView extends PageViewModel {
  CustomPageView({
    String assetPath = '',
    String? titleParam = 'TITLE',
    String? bodyParam = 'BODY',
  }) : super(
         title: titleParam,
         body: bodyParam,
         image: Padding(
           padding: const EdgeInsets.only(top: 24.0),
           child: SizedBox(
             height: 200,
             child: assetPath.isNotEmpty
                 ? Lottie.asset(assetPath, fit: BoxFit.contain)
                 : const Center(child: Text('LOTTIES')),
           ),
         ),
         decoration: const PageDecoration(
           titleTextStyle: TextStyle(
             fontSize: 28.0,
             fontWeight: FontWeight.w700,
           ),
           bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.black54),
           bodyPadding: EdgeInsets.all(16.0),
           pageColor: Colors.white,
           imagePadding: EdgeInsets.zero,
         ),
       );
}
