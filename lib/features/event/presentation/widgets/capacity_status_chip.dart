import 'package:flutter/material.dart';
import '../../domain/entities/event.dart';

/// Widget to display capacity status as a chip
class CapacityStatusChip extends StatelessWidget {
  final Event event;
  final double? fontSize;

  const CapacityStatusChip({
    Key? key,
    required this.event,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (!event.hasCapacityLimit) {
      return Chip(
        label: Text(
          'ไม่จำกัดจำนวน',
          style: TextStyle(
            color: isDarkMode ? Colors.blue[300] : Colors.blue[800],
            fontSize: fontSize ?? 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.blue[900] : Colors.blue[100],
        side: BorderSide.none,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }

    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    if (event.isFull) {
      backgroundColor = isDarkMode ? Colors.red[900]! : Colors.red[100]!;
      textColor = isDarkMode ? Colors.red[300]! : Colors.red[800]!;
      text = 'เต็มแล้ว';
      icon = Icons.block;
    } else if (event.isNearlyFull) {
      backgroundColor = isDarkMode ? Colors.orange[900]! : Colors.orange[100]!;
      textColor = isDarkMode ? Colors.orange[300]! : Colors.orange[800]!;
      text = 'เหลือ ${event.availableSpots}';
      icon = Icons.warning_rounded;
    } else {
      backgroundColor = isDarkMode ? Colors.green[900]! : Colors.green[100]!;
      textColor = isDarkMode ? Colors.green[300]! : Colors.green[800]!;
      text = '${event.availableSpots} ที่นั่ง';
      icon = Icons.check_circle;
    }

    return Chip(
      avatar: Icon(
        icon,
        size: (fontSize ?? 12) + 4,
        color: textColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}