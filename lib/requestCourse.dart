import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewRequestPage extends StatelessWidget {
  TextEditingController sectionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          backgroundColor: Colors.teal,

          title: Text('New Request')),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,

                restorationId: 'password',
                controller: sectionController,
                decoration: InputDecoration(
                    labelText: 'Enter course section',


                ),



              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String sect = sectionController.text.trim();
                  String password = passwordController.text.trim();

                  final response = await http.post(
                    Uri.parse("http://10.0.2.2:3000/requestSection"),
                    body: {"msg": sect, "password": password},
                  );

                  if (response.statusCode == 200) {
                    final data = json.decode(response.body)['res'];
                    sectionController.text = data;
                    print("Login successful: ${data}");

                    // Navigate to home page or save token
                  } else {
                    print("Login failed: ${response.body}");
                  }
                },
                child: Text('Request Course'),
              ),
              Container(

                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.teal,
                    borderRadius: BorderRadius.horizontal(left: Radius.elliptical(99,33)),
                    border: Border.all(

                      color: Colors.greenAccent,
                      width: 20,
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}