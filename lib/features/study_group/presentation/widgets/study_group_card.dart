import 'package:flutter/material.dart';
import '../../../../config/themes/app_color.dart';
import '../../data/models/study_group.dart';

class StudyGroupCard extends StatelessWidget {
  final StudyGroup group;
  final VoidCallback onTap;
  final VoidCallback? onLeaveGroup;

  const StudyGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.onLeaveGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Group Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: group.groupImage != null 
                    ? NetworkImage(group.groupImage!) 
                    : null,
                child: group.groupImage == null 
                    ? Icon(
                        Icons.group,
                        color: AppColors.primary,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              
              // Group Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (group.lastMessageTime != null)
                          Text(
                            _formatTime(group.lastMessageTime!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    if (group.lastMessage != null)
                      Text(
                        group.lastMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (group.description != null)
                      Text(
                        group.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              // Unread Count & Actions
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (group.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  // Leave Group Button (only shown when onLeaveGroup is provided)
                  if (onLeaveGroup != null)
                    IconButton(
                      onPressed: onLeaveGroup,
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}