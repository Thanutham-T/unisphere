import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/announcement_bloc.dart';
import 'announcement_list_screen.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AnnouncementBloc>(),
      child: const AnnouncementListScreen(),
    );
  }
}