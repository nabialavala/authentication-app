import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    debugPrint('REGISTER BUTTON PRESSED');

    if (!_formKey.currentState!.validate()) {
      debugPrint('REGISTER BLOCKED BY VALIDATION');
      return;
    }

    try {
      debugPrint('TRYING REGISTER FOR: ${_emailController.text.trim()}');

      await _authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      debugPrint('REGISTER SUCCESS');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('REGISTER FIREBASE ERROR: ${e.code} | ${e.message}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: ${e.message ?? e.code}')),
      );
    } catch (e) {
      debugPrint('REGISTER OTHER ERROR: $e');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: $e')),
      );
    }
  }

  Future<void> _signIn() async {
    debugPrint('SIGN IN BUTTON PRESSED');

    if (!_formKey.currentState!.validate()) {
      debugPrint('SIGN IN BLOCKED BY VALIDATION');
      return;
    }

    try {
      debugPrint('TRYING SIGN IN FOR: ${_emailController.text.trim()}');

      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      debugPrint('SIGN IN SUCCESS');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGN IN FIREBASE ERROR: ${e.code} | ${e.message}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: ${e.code}')),
      );
    } catch (e) {
      debugPrint('SIGN IN OTHER ERROR: $e');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email like test@abc.com';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
