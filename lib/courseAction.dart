import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/root.dart';
import 'package:local/themeData.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({Key? key}) : super(key: key);

  @override
  _NewRequestPageState createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCourse;
  String? selectedType;
  final TextEditingController _detailsController = TextEditingController();
  bool isLoading = true;
  List<String> courses = [
    'Software Engineering',
    'Data Structures',
    'AI',
    'IoT',
  ];
  List<String> resCourses = [];

  @override
  initState() {
    super.initState();
    // Fetch courses from server
    e();
  }

  Future<List<String>?> e() async {
    // Fetch section from server
    resCourses = courses;
    final response = await http.get(
      Uri.parse(root.domain() + 'coursesAnnounced'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("get courses successful: ${data}");

      resCourses =
          data.map<String>((course) => course['title'] as String).toList();

      print("get courses successful: ${resCourses}");

      // Navigate to home page or save token
    } else {
      print("get courses failed: ${response.body}");
    }
    // delayed();
    setState(() {
      isLoading = false;
    });

    return null;
  }

  void delayed() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  List<String> requestTypes = [
    'Enroll',
    'Withdraw',
    'Request Help',
    'Feedback',
  ];

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Submit request logic (Firebase, API call, etc.)

      void query() async {
        // Simulate a delay for the request submission
        final url = Uri.parse(root.domain() + 'requestSection');
        final requestPayload = {
          'course': selectedCourse,
          'type': selectedType,
          'details': _detailsController.text,
          'user_id': FirebaseAuth.instance.currentUser?.uid ?? 'guest',
        };

        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestPayload),
          );

          if (response.statusCode == 200) {
            // Simulate a successful request submission
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request submitted successfully!')),
            );
          } else {
            // Handle error response
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to submit request: ${response.body}'),
              ),
            );
          }
        } catch (e) {
          // Handle connection errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred while submitting the request.'),
            ),
          );
        }


        setState(() {
          _formKey.currentState!.reset();
          selectedCourse = null;
          selectedType = null;
          _detailsController.clear();

        });

      }

      // Make an HTTP POST request to create the course request


      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Submitting your request...'),
            content: Text('Do you want to proceed in your request?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: themeD.mainColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();


                  query();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: themeD.mainColor),
                ),
              ),
            ],
          );
        },
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final email = user.email;
      // Save to memory/local storage if needed
    } else {
      final uid = 'guest';
      final email = 'sguest@stu.naja.edu';
      // Save to memory/local storage if needed
      print('No user logged in, using guest credentials: $uid, $email');
    }

    return Center(
      child: Container(


        child: Scaffold(
          appBar: AppBar(
            title: const Text('New Course Request'),
            // backgroundColor: Colors.deepPurple,
          ),
          // bottomNavigationBar: BottomAppBar(
          //   color: themeD.mainColor,
          //   child: Padding(
          //     // padding: EdgeInsetsGeometry.zero,
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       '© 2023 Course Request System',
          //       style: TextStyle(color: Colors.white, fontSize: 14),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  // constraints: BoxConstraints(maxWidth: 800),
                  // MediaQuery.of(context).size.width > 800
                  width: kIsWeb? MediaQuery.of(context).size.width* .4 : double.infinity,
                  child: Padding(


                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Select Course',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField<String>(

                            value: selectedCourse,
                            onChanged: (value) => setState(() => selectedCourse = value),

                            items:
                                isLoading
                                    ? [
                                      DropdownMenuItem(
                                        value: null,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text('Loading...'),
                                          ],
                                        ),
                                      ),
                                    ]
                                    : resCourses.map((course) {
                                      return DropdownMenuItem(
                                        value: course,
                                        child: Text(course),
                                      );
                                    }).toList(),

                            validator:
                                (value) => value == null ? 'Please select a course' : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Type of Request',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedType,
                            onChanged: (value) => setState(() => selectedType = value),
                            items:
                                requestTypes.map((type) {
                                  return DropdownMenuItem(value: type, child: Text(type));
                                }).toList(),
                            validator:
                                (value) =>
                                    value == null ? 'Please select request type' : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _detailsController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter additional details...',
                            ),
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? /*'Please enter details'*/ null
                                        : null,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: _submitRequest,
                            icon: const Icon(Icons.send, ),
                            label: const Text('Submit Request'),
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
