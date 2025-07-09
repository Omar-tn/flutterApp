import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:local/homepage.dart';
import 'package:local/root.dart';
import 'package:local/signup.dart';

import 'dashboard.dart';
import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const String routName = 'authGate';

  Future<void> storeUserData(User user) async {
    try {
      await user.updateProfile(displayName: user.email?.split('@')[0]);
      await user.reload();
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [EmailAuthProvider()],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                final user = state.user;

                // Check if this is the first time the user signed in
                final isNewUser =
                    user!.metadata.creationTime == user.metadata.lastSignInTime;

                if (isNewUser) {
                  // Redirect to your custom sign-up info page or onboarding page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                } else {
                  // Normal login flow
                  await storeUserData(user);
                }
              }),
            ],
            showAuthActionSwitch: false,
            // initialAuthAction: AuthAction.signIn,
            headerMaxExtent: 200,
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'CE-Bridge',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    kIsWeb
                        ? Image.asset('images/logo.png', height: 120)
                        : Image.asset('assets/images/logo.png', height: 100),
                  ],
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    action == AuthAction.signIn
                        ? const Text('Welcome to FlutterFire, please sign in!')
                        : const Text('Welcome to Flutterfire, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpPage.routName);
                      },
                      child: Text('Don’t have an account? Register'),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      action == AuthAction.signIn
                          ? 'By signing in, you agree to our terms and conditions.'
                          : 'By signing up, you agree to our terms and conditions.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset('images/logo.png'),
                ),
              );
            },
          );
        }
        final firebaseUser = snapshot.data!;
        return FutureBuilder<String>(
          future: root.getUserRole(firebaseUser.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (roleSnapshot.hasError) {
              return Center(
                child: Text('Error loading role: ${roleSnapshot.error}'),
              );
            }

            if (roleSnapshot.hasData) {
              final role = roleSnapshot.data!;
              if (!firebaseUser.emailVerified) {
                // return const EmailVerificationController(auth: FirebaseAuth); // redirect to verification
              }
              Future.delayed(const Duration(seconds: 1), () {
                storeUserData(firebaseUser);
              });

              if (role == 'admin') {
                return AdminDashboard(
                  apiBaseUrl: root.domain(),
                  firebaseUid: root.userId, //firebaseUser.uid,
                );
              } else {
                return homePage(); // student or others
              }
            }

            return const Center(child: Text('No role assigned'));
          },
        );
      },
    );
  }
}

void builder(BuildContext context, AsyncSnapshot<User?> snapshot) {
  // Check user role and redirect accordingly
  /*return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(snapshot.data?.uid)
        .get(),
    builder: (context, userSnapshot) {
      if (userSnapshot.hasData) {
        final userData = userSnapshot.data?.data() as Map<String,
            dynamic>?;
        final userRole = userData?['role'] as String? ?? 'user';

        if (userRole == 'admin') {
          return AdminDashboard();
        }
        return homePage();
      }
      return const Center(child: CircularProgressIndicator());
    },
  );*/
}
