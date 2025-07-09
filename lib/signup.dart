import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/root.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static final String routName = 'signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;

  final List<String> _roles = ['student', 'admin'];

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      // validate email to the role
      if (_emailController.text.trim().endsWith('@stu.najah.edu')) {
        if (_selectedRole == 'admin') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Admin role is not allowed for student email'),
            ),
          );
          return;
        }
      } else if (_emailController.text.trim().endsWith('@najah.edu')) {
        if (_selectedRole == 'student') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Student role is not allowed for staff email'),
            ),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email must be from najah.edu or stu.najah.edu'),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        // Create user with email and password
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

        // Check if the user is verified

        // Update user profile with display name
        await userCredential.user?.updateDisplayName(_nameController.text);

        var name = _nameController.text.trim();
        var email = _emailController.text.trim();
        var id = _idController.text.trim();
        var role = _selectedRole ?? 'student';

        // Store additional user data (role)

        final uid = userCredential.user?.uid;
        await userCredential.user?.sendEmailVerification();
        /* final response = await http.post(
          Uri.parse(root.domain() + 'register_user'),
          body: {
            'uid': uid,
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'role': _selectedRole ?? 'Student',
            'id': _idController.text.trim(), // Placeholder for ID input
          },
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'User registered successfully')),
          );
          print("User saved to MySQL");
          await userCredential.user?.sendEmailVerification();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign up successful!')));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EmailVerificationScreen(
            uid : uid, name: name, email: email, role: role, id: id
    )),
          );


        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving user data: ${response.body}')),
          );
          print("Error saving to MySQL: ${response.body}");
        }*/

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => EmailVerificationScreen(
                  uid: uid,
                  name: name,
                  email: email,
                  role: role,
                  id: id,
                ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? 'Sign up failed')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        print("Error: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SizedBox(
          width:
              kIsWeb
                  ? MediaQuery.of(context).size.width * 0.4
                  : double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'Please enter your name'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                        /*value?.isEmpty ?? true
                                ? 'Please enter your email'
                                : null,*/
                        validateEmail(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            (value?.length ?? 0) < 6
                                ? 'Password too short'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => _selectedRole = value),
                    validator:
                        (value) =>
                            value == null ? 'Please select a role' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _idController, // Placeholder for ID input
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'Please enter your ID'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        root.initialRoute,
                      );
                    },
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    //check ends with najah.edu
    if (!value.endsWith('najah.edu')) {
      return 'Email must from najah.edu';
    }

    return null;
  }
}

class EmailVerificationScreen extends StatefulWidget {
  final String name, id, role, email;

  final String? uid;

  const EmailVerificationScreen({
    Key? key,
    required String? this.uid,
    required String this.name,
    required String this.email,
    required this.id,
    required this.role,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startChecking();
  }

  Future<void> storeuser() async {
    final response = await http.post(
      Uri.parse(root.domain() + 'register_user'),
      body: {
        'uid': widget.uid,
        'name': widget.name,
        'email': widget.email,
        'role': widget.role,
        'id': widget.id, // Placeholder for ID input
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'User registered successfully'),
        ),
      );
      print("User saved to MySQL");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign up successful!')));
      Navigator.pushReplacementNamed(context, root.initialRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user data: ${response.body}')),
      );
      print("Error saving to MySQL: ${response.body}");
    }
  }

  void _startChecking() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        _timer?.cancel();

        // Navigate to your homepage/dashboard
        await storeuser(); // 🔁 replace with your route
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 60, color: Colors.blue),
            const SizedBox(height: 20),
            Center(
              child: Center(
                child: Text("Please check your email and verify your address."),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Verification email re-sent")),
                );
              },
              child: const Text("Resend Email"),
            ),
          ],
        ),
      ),
    );
  }
}
