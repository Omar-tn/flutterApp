import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart'; // REPLACE: Replace with your database package and use it
import 'package:firebase_auth/firebase_auth.dart';

class AdminCourseActions extends StatefulWidget {
  static const String routName = '/admin-course-actions';
  final String firebaseUid;

  AdminCourseActions({required this.firebaseUid});

  @override
  _AdminCourseActionsState createState() => _AdminCourseActionsState();
}

class _AdminCourseActionsState extends State<AdminCourseActions> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Management')),
      body: Text("maintain"),
      /*StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var course = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(course['name'] ?? 'Unnamed Course'),
                  subtitle: Text(course['description'] ?? 'No description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, //TODO: look and use
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _handleEditCourse(course.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _handleDeleteCourse(course.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddCourse,
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleAddCourse() {
    // Add course implementation
  }

  void _handleEditCourse(String courseId) {
    // Edit course implementation
  }

  void _handleDeleteCourse(String courseId) async {
    try {
      //await _firestore.collection('courses').doc(courseId).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Course deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting course: $e')));
    }
  }
}
