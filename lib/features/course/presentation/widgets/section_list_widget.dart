import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../view_models/course_section_viewmodel.dart';
import '../widgets/schedule_list_widget.dart';

class SectionListWidget extends StatelessWidget {
  final List<CourseSectionViewModel> sections;

  const SectionListWidget({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (BuildContext context, int index) {
        final CourseSectionViewModel item = sections[index];

        return Slidable(
          key: ValueKey(index),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete')));
                },
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Section ${item.sectionCode}', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  decoration: BoxDecoration(color: colorScheme.onPrimary, borderRadius: BorderRadius.circular(20.0)),
                  child: Text(item.enrolledText, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Day & Time', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text('Room', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text('Instructor', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                ScheduleListWidget(schudules: item.schedules, instructors: item.instructors),
              ],
            ),
          ),
        );
      },
    );
  }
}
