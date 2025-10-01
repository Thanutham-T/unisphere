import 'package:flutter/material.dart';

import '../view_models/course_schedule_viewmodel.dart';

class ScheduleListWidget extends StatelessWidget {
  final List<CourseScheduleViewModel> schudules;
  final List<String> instructors;

  const ScheduleListWidget({super.key, required this.schudules, required this.instructors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Day & Time', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: Text('Room', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Instructor', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: schudules.length,
          itemBuilder: (BuildContext context, int index) {
            final CourseScheduleViewModel item = schudules[index];

            return Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 4.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Text('${item.dayOfWeek}\n${item.timeRange}', style: Theme.of(context).textTheme.bodySmall)),
                Expanded(flex: 1, child: Text(item.room, style: Theme.of(context).textTheme.bodySmall)),
                Expanded(flex: 2, child: Text(instructors.join(", "), style: Theme.of(context).textTheme.bodySmall)),
              ],
            ));
          },
        ),
      ],
    );
  }
}
