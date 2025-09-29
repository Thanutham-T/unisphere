import 'package:flutter/material.dart';
import 'package:unisphere/features/course/presentation/blocs/course_filter_cubit.dart';

Future<void> showFilterSheet(BuildContext context, CourseFilterCubit cubit, List<String> faculties) {
  final colorScheme = Theme.of(context).colorScheme;

  // Initial selection snapshot
  final tempSelected = Set<String>.from(cubit.state.selectedFilter == 'All' ? [] : [cubit.state.selectedFilter]);

  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => SafeArea(
        top: false,
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter Courses",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),

                // Scrollable chips
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: faculties.map((facultyName) {
                        final isSelected = tempSelected.contains(facultyName);
                        return FilterChip(
                          label: Text(facultyName),
                          selected: isSelected,
                          selectedColor: colorScheme.primaryContainer,
                          checkmarkColor: colorScheme.onPrimaryContainer,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                tempSelected.add(facultyName);
                              } else {
                                tempSelected.remove(facultyName);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        setState(() {
                          tempSelected.clear();
                        });
                      },
                      child: const Text("Reset"),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonal(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        if (tempSelected.isEmpty) {
                          cubit.updateFilter('All');
                        } else {
                          cubit.updateFilter(tempSelected.join(', '));
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
