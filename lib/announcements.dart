import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:local/root.dart';

class CourseAnnouncementsScreen extends StatefulWidget {
  @override
  _CourseAnnouncementsScreenState createState() =>
      _CourseAnnouncementsScreenState();
}

class _CourseAnnouncementsScreenState extends State<CourseAnnouncementsScreen> {
  List<dynamic> courses = [];
  String userId = "firebase"; // Replace with actual UID from Firebase Auth

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse(root.domain() + 'coursesAnnounced/only'),
      );
      if (response.statusCode == 200) {
        setState(() {
          courses = json.decode(response.body);
        });
      } else {
        print('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Future<void> enrollCourse(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse(root.domain() + 'courses_announce/$courseId/enroll'),
        body: {'student_id': userId},
      );
      if (response.statusCode == 200) {
        fetchCourses();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body)));
      } else {
        print('Failed to enroll:');
        print(response.body);
      }
    } catch (e) {
      print('Error enrolling in course: $e');
    }
  }

  //

  Future<void> voteCourse(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse(root.domain() + 'courses_announce/$courseId/vote'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': userId}),
      );
      if (response.statusCode == 200) {
        fetchCourses();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body)));
      } else {
        print(response.body);

        print('Failed to vote');
      }
    } catch (e) {
      // Handle error, e.g., network issues or server errors
      print('Error voting for course: $e');

      // print('Error getting user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Announcements'), leading: Container()),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        // shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: courses.length ?? 5,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('title course : ${course['title']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\nTime: ${course['time'] ?? 'N/A'}'),
                      Row(
                        children: [
                          Text('Status: '),
                          course['status'] == 'open'
                              ? Icon(
                                Icons.lock_open_rounded,
                                color: Colors.green,
                              )
                              : Icon(Icons.lock, color: Colors.red),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Votes: ${course['votes']}\nParticipants: ${course['participants']}',
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.thumb_up, size: 40),
                        label: Text('Maybe', style: TextStyle(fontSize: 20)),

                        onPressed: () => voteCourse(course['id'].toString()),
                      ),

                      TextButton.icon(
                          icon: Icon(Icons.group_add, size: 40),
                          label: Text('Enroll', style: TextStyle(fontSize: 20)),
                          onPressed: () => enrollCourse(course['id'].toString())
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
