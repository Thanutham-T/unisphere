import 'package:flutter/material.dart';
import 'package:unisphere/config/routes/router_export.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Course',   'action': () => CourseRoute().push(context)},
      {'name': 'Map',      'action': () => MapRoute().push(context)},
      {'name': 'Settings', 'action': () => SettingRoute().push(context)},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return ElevatedButton(
              onPressed: item['action'] as void Function(),
              child: Text(item['name'] as String,
                  style: const TextStyle(fontSize: 18)),
            );
          },
        ),
      ),
    );
  }
}
