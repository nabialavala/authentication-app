import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'authentication_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              onPressed: () async {
                await authService.changePassword("newPassword123");
              },
              child: const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
