import 'package:flutter/material.dart';

import '../view_models/course_schedule_viewmodel.dart';


class ScheduleListWidget extends StatelessWidget {
  final List<CourseScheduleViewModel> schudules;
  final List<String> instructors;

  const ScheduleListWidget({super.key, required this.schudules, required this.instructors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schudules.length,
      itemBuilder: (BuildContext context, int index) {
        final CourseScheduleViewModel item = schudules[index];

        return Row(
          children: [
            Expanded(child: Text('${item.dayOfWeek} ${item.timeRange}', style: Theme.of(context).textTheme.bodySmall)),
            Expanded(child: Text(item.room, style: Theme.of(context).textTheme.bodySmall)),
            Expanded(child: Text(instructors.join(", "), style: Theme.of(context).textTheme.bodySmall)),
          ],
        );
      },
    );
  }
}
