import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local/home.dart';

class login extends StatelessWidget {
  static const String routName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('omar login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, home.routName);
            //Navigator.of(context).pushNamed(home.routName);
          },
          child: Text('login'),
        ),
      ),
    );
  }
}
