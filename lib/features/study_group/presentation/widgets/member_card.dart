import 'package:flutter/material.dart';
import '../../../../config/themes/app_color.dart';
import '../../data/models/group_member.dart';

class MemberCard extends StatelessWidget {
  final GroupMember member;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool showSelection;

  const MemberCard({
    super.key,
    required this.member,
    this.isSelected = false,
    this.onSelectionChanged,
    this.showSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: showSelection ? () => onSelectionChanged?.call(!isSelected) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Member Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: member.profileImage != null 
                        ? NetworkImage(member.profileImage!) 
                        : null,
                    child: member.profileImage == null 
                        ? Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 24,
                          )
                        : null,
                  ),
                  
                  // Online Status Indicator
                  if (member.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (member.isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Admin',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Selection Checkbox
              if (showSelection)
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged?.call(value ?? false),
                  activeColor: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}