import 'package:flutter/material.dart';
import '../../domain/entities/event.dart';

/// Widget to display event capacity with progress bar
class CapacityIndicator extends StatelessWidget {
  final Event event;
  final bool showDetails;

  const CapacityIndicator({
    Key? key,
    required this.event,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (!event.hasCapacityLimit) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDarkMode ? Colors.blue[700]! : Colors.blue[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.people,
              color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${event.registrationCount} คน',
              style: TextStyle(
                color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'ไม่จำกัดจำนวน',
              style: TextStyle(
                color: isDarkMode ? Colors.blue[400] : Colors.blue[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    Color progressColor;
    Color backgroundColor;
    
    if (event.isFull) {
      progressColor = Colors.red;
      backgroundColor = isDarkMode ? Colors.red[900]! : Colors.red[50]!;
    } else if (event.isNearlyFull) {
      progressColor = Colors.orange;
      backgroundColor = isDarkMode ? Colors.orange[900]! : Colors.orange[50]!;
    } else {
      progressColor = Colors.green;
      backgroundColor = isDarkMode ? Colors.green[900]! : Colors.green[50]!;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.people,
                color: progressColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'การลงทะเบียน',
                style: TextStyle(
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (event.isFull)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'เต็ม',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          if (showDetails) ...[
            const SizedBox(height: 12),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: event.capacityPercentage,
                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Registration stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${event.registrationCount} / ${event.maxCapacity} คน',
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!event.isFull)
                  Text(
                    'เหลือ ${event.availableSpots} ที่นั่ง',
                    style: TextStyle(
                      color: event.isNearlyFull 
                        ? Colors.orange[700] 
                        : Colors.green[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}