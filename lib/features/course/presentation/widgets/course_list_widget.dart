import 'package:flutter/material.dart';

import '../view_models/course_viewmodel.dart';
import '../widgets/section_list_widget.dart';

class CourseListWidget extends StatelessWidget {
  final List<CourseViewModel> courses;

  const CourseListWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        final CourseViewModel item = courses[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            collapsedBackgroundColor: colorScheme.primaryContainer,
            backgroundColor: colorScheme.primaryContainer,
            tilePadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            title: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 76),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    '${item.code} ${item.subjectName}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: Text(item.weight, style: Theme.of(context).textTheme.bodyMedium)),
                      SizedBox(width: 6),
                      Expanded(flex: 2, child: Text(item.faculty, style: Theme.of(context).textTheme.bodyMedium)),
                      SizedBox(width: 6),
                      Expanded(flex: 3, child: Text(item.branch, style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                ],
              ),
            ),
            children: [SectionListWidget(sections: item.sections, isRegister: false,)],
          ),
        );
      },
    );
  }
}
