import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'authentication_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  //change password  logic
  void _showChangePasswordDialog(BuildContext context, AuthService authService) {
    final TextEditingController _newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "New Password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPassword = _newPasswordController.text.trim();

                if(newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password maust be at least 6 characters."),
                    ),
                  );
                  return;
                }

                try {
                  await authService.changePassword(newPassword);
                  if (!context.mounted) return;

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password updated."),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Email: ${authService.currentUser?.email ?? 'No user'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: () async {
                await authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AuthenticationScreen(),
                  ),
                );
              },
              child: const Text("Logout"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showChangePasswordDialog(context, authService);
              },
              child: const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
