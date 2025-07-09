import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local/home.dart';
import 'package:local/signup.dart';
import 'package:local/themeData.dart';

import 'homepage.dart';

class login extends StatelessWidget {
  static const String routName = 'login';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: kIsWeb ? MediaQuery
                .of(context)
                .size
                .width * .4 : double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: emailController,

                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,

                    decoration: InputDecoration(labelText: 'Email')),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  if (emailController.text == 'admin') {
                    Navigator.pushNamed(context, 'adminDashboard');
                  } else {
                    Navigator.pushNamed(context, homePage.routName);
                  }
                }, child: Text('Login')),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage()
                        ));
                  },
                  child: Text('Don’t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
