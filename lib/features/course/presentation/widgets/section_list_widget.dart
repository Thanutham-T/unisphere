import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../view_models/course_section_viewmodel.dart';
import '../widgets/schedule_list_widget.dart';

class SectionListWidget extends StatelessWidget {
  final List<CourseSectionViewModel> sections;
  final bool isRegister;

  const SectionListWidget({super.key, required this.sections, required this.isRegister});

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
                backgroundColor: isRegister ? colorScheme.onPrimary : colorScheme.primaryFixedDim,
                onPressed: (context) {
                  if (isRegister) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enroll')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawn')));
                  }
                },
                icon: isRegister ? Icons.add_box : Icons.delete_forever,
                label: isRegister ? 'Enroll' : 'Withdrawn',
              ),
            ],
          ),
          child: Container(
            color: isRegister ? colorScheme.onPrimary : colorScheme.primaryContainer,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Section ${item.sectionCode}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 60.0,
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    decoration: BoxDecoration(color: colorScheme.inversePrimary, borderRadius: BorderRadius.circular(20.0)),
                    child: Text(item.enrolledText, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  SizedBox(height: 10.0),
                  ScheduleListWidget(schudules: item.schedules, instructors: item.instructors),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
