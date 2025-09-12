import 'package:flutter/material.dart';


class StudyGroupScreen extends StatelessWidget {
  const StudyGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Study Group',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}