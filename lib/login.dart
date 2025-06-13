import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local/home.dart';
import 'package:local/themeData.dart';

import 'homepage.dart';

class login extends StatelessWidget {
  static const String routName = 'login';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(

                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,

                  decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 20),
              TextField(
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, homePage.routName);
              }, child: Text('Login')),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signup');
                },
                child: Text('Don’t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
