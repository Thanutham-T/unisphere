import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // นำทางไปหน้า login เมื่อ logout สำเร็จ
            context.go('/login');
          }
          if (state is AuthError) {
            // แสดง error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state is AuthAuthenticated 
                              ? state.user.email
                              : 'ผู้ใช้',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state is AuthAuthenticated) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${state.user.firstName} ${state.user.lastName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Profile Options
                  _buildProfileOption(
                    icon: Icons.edit,
                    title: 'แก้ไขโปรไฟล์',
                    onTap: () {
                      // TODO: Navigate to edit profile
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ฟีเจอร์นี้ยังไม่พร้อมใช้งาน')),
                      );
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: 'การตั้งค่า',
                    onTap: () {
                      // TODO: Navigate to settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ฟีเจอร์นี้ยังไม่พร้อมใช้งาน')),
                      );
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: 'ช่วยเหลือ',
                    onTap: () {
                      // TODO: Navigate to help
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ฟีเจอร์นี้ยังไม่พร้อมใช้งาน')),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('ออกจากระบบ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // App Version
                  Center(
                    child: Text(
                      'Unisphere v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade600),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ออกจากระบบ'),
          content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }
}