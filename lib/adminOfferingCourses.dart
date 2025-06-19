import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/root.dart';

class AdminOfferingCourses extends StatefulWidget {
  static const String routName = '/adminOfferingCourses';
  final String firebaseUid;

  AdminOfferingCourses({required this.firebaseUid});

  @override
  _AdminOfferingCoursesState createState() => _AdminOfferingCoursesState();
}

class _AdminOfferingCoursesState extends State<AdminOfferingCourses> {
  final TextEditingController _courseTimeController = TextEditingController();
  final TextEditingController _courseMaxController = TextEditingController();
  List<dynamic> _announcedCourses = [
    {'course_id': 'CS101', 'course_name': 'Intro to CS'},
    {'course_id': 'MATH201', 'course_name': 'Calculus I'},
    {'course_id': 'PHY101', 'course_name': 'Physics I'},
  ];
  List<dynamic> Courses = [];
  bool _loading = false;

  // // TODO: Replace with actual MySQL fetch logic
  // await Future.delayed(Duration(milliseconds: 500));
  bool isSelected = false;
  var type;

  Map<String, dynamic>? selectedCourse = null;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncedCourses();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final res = await http.get(Uri.parse('${root.domain()}courses'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          Courses = data;
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchAnnouncedCourses() async {
    setState(() => _loading = true);

    try {
      final res = await http.get(Uri.parse('${root.domain()}coursesAnnounced'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _announcedCourses = data;
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _announceCourse(String courseId) async {
    try {
      final res = await http.post(
        Uri.parse('${root.domain()}courses_announce'),
        body: {
          'courseId': courseId,
          'id': '1002', // Replace with actual course ID
          'time': _courseTimeController.text.trim(),
          'max_participants': _courseMaxController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course announced successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to announce course: ${res.body}')),
        );
        print('Failed to announce course: ${res.body}');
      }
      if (res.statusCode != 200) {
        throw Exception('Failed to announce course: ${res.body}');
      }

      setState(() {
        _fetchAnnouncedCourses();
        _loading = false;
        _courseTimeController.clear();
        _courseMaxController.clear();
        selectedCourse = null;
        isSelected = false;
      });
    } catch (e) {
      print('Error announcing course: $e');
      setState(() => _loading = false);
      return;
    }
  }

  Future<void> _makeCourseOfficial(String courseId) async {
    setState(() => _loading = true);

    // change the course type to official
    try {
      final res = await http.post(
        Uri.parse('${root.domain()}courses_announce/changeType'),
        // headers: {'Content-Type': 'application/json'},
        body: {'courseId': courseId, 'type': 'official'},
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course made official successfully')),
        );
        setState(() {
          _fetchAnnouncedCourses();
          _loading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to make course official' + res.body)),
        );
        print('Failed to make course official: ${res.body}');
        setState(() => _loading = false);
      }
    } catch (e) {
      print('Error making course official: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteCourse(String courseId) async {
    setState(() => _loading = true);

    print('Deleting course with ID: $courseId');
    try {
      final res = await http.delete(
        Uri.parse('${root.domain()}courses_announce/delete'),
        // headers: {'Content-Type': 'application/json'},
        body: {'courseId': courseId},
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Course deleted  successfully')));
        setState(() {
          _fetchAnnouncedCourses();
          _loading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course ' + res.body)),
        );
        print('Failed to delete course official: ${res.body}');
        setState(() => _loading = false);
      }
    } catch (e) {
      print('Error deleting course : $e');
      setState(() => _loading = false);
    }
  }

  Widget _buildAnnouncedCoursesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: _announcedCourses.length,
      itemBuilder: (context, index) {
        final course = _announcedCourses[index];
        return Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  course['course_id'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course['course_name'],
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _makeCourseOfficial(course['id']),
                  child: const Text('Make Official'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalCourses =
        _announcedCourses
            .where((course) => course['type'] == 'announce')
            .length;
    int count = 0;
    int mosts = 0;
    double maxs = 0;
    double percent = (maxs * count) == 0 ? 0 : ((mosts / (maxs * count)) * 100);
    int participants = 0;
    for (var c in _announcedCourses.where(
      (course) => course['type'] == 'announce',
    )) {
      count++;
      int most =
          (c['participants'] ?? 0) > (c['votes'] ?? 0)
              ? c['participants'] as int
              : c['votes'] as int;
      mosts += most;
      participants += c['participants'] as int;

      maxs +=
          c['max_participants'] != null ? c['max_participants'] as int : most;
      percent = most / maxs * 100;
    }

    percent = count * maxs == 0 ? 0 : (participants / (maxs * count) * 100);

    return Scaffold(
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              DropdownButtonFormField<Map<String, dynamic>>(
                                value: selectedCourse,
                                items:
                                    Courses.map(
                                      (course) => DropdownMenuItem<
                                        Map<String, dynamic>
                                      >(
                                        value: course,
                                        child: Text('${course['title']}'),
                                      ),
                                    ).toList(),

                                onChanged: (value) {
                                  if (value != null) {
                                    type = value['type'];
                                    selectedCourse = value;

                                    setState(() {
                                      isSelected = true;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Course',
                                ),
                              ),

                              SizedBox(height: 8),
                              TextField(
                                controller: _courseTimeController,
                                decoration: InputDecoration(
                                  labelText: 'time',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _courseMaxController,
                                decoration: InputDecoration(
                                  labelText: 'Max Participants',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed:
                              isSelected
                                  ? () => _announceCourse(
                                    selectedCourse!['id'].toString(),
                                  )
                                  : null,
                          child: Text('Announce Course'),
                        ),
                        Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Announced Courses: $totalCourses'),
                            Text('Percent: ${percent.toStringAsFixed(2)}%'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                _announcedCourses
                                    .where(
                                      (course) => course['type'] == 'announce',
                                    )
                                    .length ??
                                0,
                            itemBuilder: (context, index) {
                              // Filter announced courses
                              final announcedCourses =
                                  _announcedCourses
                                      .where(
                                        (course) =>
                                            course['type'] == 'announce',
                                      )
                                      .toList();

                              final course = announcedCourses[index];
                              final max = course['max_participants'] ?? 0;
                              final enrolled = course['participants'] ?? 0;
                              final vote = course['votes'] ?? 0;
                              final higher = enrolled > vote ? enrolled : vote;
                              final dvider =
                                  max > 0
                                      ? max
                                      : higher; // Avoid division by zero
                              final percent =
                                  dvider == 0
                                      ? 0
                                      : (higher / dvider * 100).toStringAsFixed(
                                        1,
                                      );

                              var enrollPerc =
                                  higher == 0
                                      ? 0
                                      : (enrolled / higher * 100)
                                          .toStringAsFixed(1);
                              var votePerc =
                                  higher == 0
                                      ? 0
                                      : (vote / higher * 100).toStringAsFixed(
                                        1,
                                      );
                              var details =
                                  'Participants: $enrolled(${enrollPerc}%)\nVotes: $vote(${votePerc}%)';
                              max > 0
                                  ? details =
                                      'Max: $max\nPercent: $percent%\n' +
                                      details
                                  : '';

                              return ListTile(
                                leading: Icon(Icons.hourglass_empty_rounded),
                                title: Text('${course['title']}'),
                                subtitle: Text(
                                  'Status: ${course['status']}\n' +
                                      (course['time'] != null
                                          ? '${course['time']}\n' + details
                                          : details),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          () => _makeCourseOfficial(
                                            course['id'].toString(),
                                          ),
                                      child: Text('Make Official'),
                                    ),
                                    SizedBox(height: 8),
                                    IconButton(
                                      onPressed:
                                          () => _deleteCourse(
                                            course['id'].toString(),
                                          ),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),

                                      //child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
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
