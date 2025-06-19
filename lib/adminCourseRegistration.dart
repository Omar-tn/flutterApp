import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/itemwidget.dart';
import 'dart:convert';
import 'package:local/root.dart';

class AdminCourseRegistration extends StatefulWidget {
  static const String routName = '/admin-course-offering';

  final String firebaseUid;

  const AdminCourseRegistration({Key? key, required this.firebaseUid})
    : super(key: key);

  @override
  _AdminCourseRegistrationState createState() =>
      _AdminCourseRegistrationState();
}

class _AdminCourseRegistrationState extends State<AdminCourseRegistration> {
  List<dynamic> enrollmentRequests = [];
  List<dynamic> withdrawalRequests = [];
  bool isLoading = false;

  List<dynamic> courseStudents = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
    //_fetchCourseStudents();
  }

  Future<void> fetchRequests() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${root.domain()}api/course-requests'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          enrollmentRequests =
              data.where((request) => request['type'] == 'enroll').toList();
          withdrawalRequests =
              data.where((request) => request['type'] == 'withdraw').toList();
        });
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      print('Error fetching requests: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchCourseStudents(String courseId) async {
    isLoading = true;
    try {
      final response = await http.get(
        Uri.parse('${root.domain()}api/course-students?courseId=$courseId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          courseStudents = data;
          isLoading = false;
        });

        // Process the data as needed
      } else {
        throw Exception('Failed to load course students');
      }
    } catch (e) {
      print('Error fetching course students: $e');
    } finally {
      setState(() {});
    }
  }

  Future<void> handleEnrollmentRequest(String requestId, bool approved) async {
    try {
      final response = await http.put(
        Uri.parse('${root.domain()}api/course-requests/$requestId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type': 'enroll',
          'status': approved ? 'approved' : 'rejected',
          'processedBy': widget.firebaseUid,
        }),
      );

      if (response.statusCode == 200) {
        await fetchRequests();
      } else {
        throw Exception('Failed to update request ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error handling enrollment request: $e')),
      );
      print('Error handling enrollment request: $e');
    }
  }

  Future<void> handleWithdrawalRequest(String requestId, bool approved) async {
    try {
      final response = await http.put(
        Uri.parse('${root.domain()}api/course-requests/$requestId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type': 'withdraw',
          'status': approved ? 'approved' : 'rejected',
          'processedBy': widget.firebaseUid,
        }),
      );

      if (response.statusCode == 200) {
        await fetchRequests();
      } else {
        throw Exception('Failed to update request ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error handling withdrawal request: $e')),
      );
      print('Error handling withdrawal request: $e ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Course Management')
        leading: IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncedCourseScreen(),
                ),
              ),
          icon: Icon(Icons.menu_book_rounded),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.45,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Enrollment Requests',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 16),
                                _buildRequestsList(enrollmentRequests, true),
                              ],
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.45,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Withdrawal Requests',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 16),
                                _buildRequestsList(withdrawalRequests, false),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildRequestsList(List<dynamic> requests, bool isEnrollment) {
    return requests.length == 0
        ? Center(
          child: Card(
            child: ListTile(
              title: Text(
                'No ${isEnrollment ? 'enrollment' : 'withdrawal'} requests available.',
              ),
            ),
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            print(
              ':' +
                  (request['reason']?.isEmpty ?? true
                      ? 'empty'
                      : request['reason'].toString()) +
                  ':',
            );
            return Container(
              child: Card(
                child: ListTile(
                  // titleAlignment: ListTileTitleAlignment.center,
                  title: Center(child: Text('Course: ${request['title']}')),
                  subtitle: Column(
                    children: [
                      Text('Student: ${request['name']}'),
                      Text('ID: ${request['userId']}'),

                      request['max_participants'] != null
                          ? Text(
                            'Participants: ${request['Participants'] ?? 0} / ${request['max_participants']}',
                          )
                          : SizedBox.shrink(),
                      // Text('Request ID: ${request['id']}'),
                      //     request['reason'] == null ||
                      request['reason']?.isEmpty
                          ? Text('No reason provided')
                          : Text('Reason: ${request['reason']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed:
                            () =>
                                isEnrollment
                                    ? handleEnrollmentRequest(
                                      request['id'].toString(),
                                      true,
                                    )
                                    : handleWithdrawalRequest(
                                      request['id'].toString(),
                                      true,
                                    ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed:
                            () =>
                                isEnrollment
                                    ? handleEnrollmentRequest(
                                      request['id'].toString(),
                                      false,
                                    )
                                    : handleWithdrawalRequest(
                                      request['id'].toString(),
                                      false,
                                    ),
                      ),
                    ],
                  ),
                  onLongPress: () {
                    //navigate to course students
                    _fetchCourseStudents(request['courseId'].toString());
                    //add delay to ensure data is fetched before navigating
                    Future.delayed(Duration(milliseconds: 500), () {});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CourseStudentsScreen(
                              context,
                              request['courseId'].toString(),
                            ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
  }
}

//create course screen
class AnnouncedCourseScreen extends StatefulWidget {
  @override
  State<AnnouncedCourseScreen> createState() => _AnnouncedCourseScreenState();
}

class _AnnouncedCourseScreenState extends State<AnnouncedCourseScreen> {
  List<dynamic> courses = [];

  bool isloading = false;

  @override
  void initState() {
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      isloading = true;
      final response = await http.get(
        Uri.parse('${root.domain()}courses_announce'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courses = data;
          isloading = false;
        });

        // Process the data as needed
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    // gridbuilder
    Scaffold(
      appBar: AppBar(
        title: Text('Announced Courses'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child:
            isloading
                ? Center(child: CircularProgressIndicator())
                : courses.isEmpty
                ? Center(child: Text('No courses available.'))
                : Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: my_Grid(context),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            // Navigate to course details or actions
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CourseStudentsScreen(
                                      context,
                                      course['id'].toString(),
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course['title'] + ' ${course['time'] ?? ''}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 8),
                                course['status'] == 'open'
                                    ? Icon(
                                      Icons.lock_open_rounded,
                                      color: Colors.green,
                                    )
                                    : Icon(
                                      Icons.lock_rounded,
                                      color: Colors.red,
                                    ),

                                Text('ID: #${course['id']}'),
                                Text(
                                  'type: ${course['type']}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Participants: ${course['participants'] ?? 0} / ${course['max_participants'] ?? '∞'}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}

//create a new screen to show course students
class CourseStudentsScreen extends StatefulWidget {
  final String courseId;

  CourseStudentsScreen(BuildContext context, this.courseId);

  @override
  _CourseStudentsScreenState createState() => _CourseStudentsScreenState();
}

class _CourseStudentsScreenState extends State<CourseStudentsScreen> {
  List<dynamic> courseStudents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourseStudents(widget.courseId);
  }

  Future<void> _fetchCourseStudents(String courseId) async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${root.domain()}api/course-students?courseId=$courseId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courseStudents = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load course students');
      }
    } catch (e) {
      print('Error fetching course students: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = courseStudents;
    //_fetchCourseStudents(courseId);
    print(widget.courseId);

    return Scaffold(
      appBar: AppBar(title: Text('Course Students')),
      body: Center(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : courseStudents.length == 0
                ? ListTile(
                  title: Center(
                    child: Text('No students enrolled in this course.'),
                  ),
                )
                : Column(
                  children: [
                    SizedBox(height: 16),
                    Card(
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        title: Center(
                          child: Text('Course: ${courseStudents[0]['title']}'),
                        ),
                        subtitle: Center(
                          child: Text('Total Students: ${students.length}'),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = courseStudents[index];
                            return Card(
                              child: ListTile(
                                title: Text(student['name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${student['firebase_uid']}'),
                                    Text(
                                      student['email'] ?? 'No email provided',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

// screen of courses
