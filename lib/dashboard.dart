import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/adminCourseActions.dart';
import 'package:local/adminCourseRegistration.dart';
import 'package:local/adminOfferingCourses.dart';
import 'dart:convert';

import 'package:local/itemwidget.dart';
import 'package:local/root.dart';

class AdminDashboard extends StatefulWidget {
  static final String routName = 'adminDashboard';
  final String apiBaseUrl;
  final String firebaseUid;

  const AdminDashboard({
    Key? key,
    required this.apiBaseUrl,
    required this.firebaseUid,
  }) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalStudents = 0;
  int totalSupervisors = 0;
  int pendingRequests = 0;
  int totalProjects = 0;
  int activeGroups = 0;
  int completedProjects = 0;
  List<dynamic> supervisors = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
    _fetchSupervisors();
  }

  Future<void> _fetchStatistics() async {
    try {
      final studentsRes = await http.get(Uri.parse('${widget.apiBaseUrl}'));
      final supervisorsRes = await http.get(
        Uri.parse('${widget.apiBaseUrl}supervisors'),
      );
      final pendingRes = await http.get(
        Uri.parse(
          '${widget.apiBaseUrl}partners/requests?uid=${widget.firebaseUid}',
        ),
      );
      final projectsRes = await http.get(
        Uri.parse('${widget.apiBaseUrl}projects'),
      );
      final groupsRes = await http.get(
        Uri.parse('${widget.apiBaseUrl}groups/active'),
      );

      setState(() {
        totalStudents = json
            .decode(studentsRes.body)
            .length;
        totalSupervisors = json
            .decode(supervisorsRes.body)
            .length;
        pendingRequests = json
            .decode(pendingRes.body)
            .length;
        totalProjects = json
            .decode(projectsRes.body)
            .length;
        activeGroups = json
            .decode(groupsRes.body)
            .length;
        completedProjects = json
            .decode(projectsRes.body)
            .where((p) => p['status'] == 'approved')
            .length;
      });
    } catch (e) {
      print('Error fetching stats: \$e');
    }
  }

  Future<void> _fetchSupervisors() async {
    try {
      final res = await http.get(Uri.parse('${widget.apiBaseUrl}supervisors'));
      supervisors = json.decode(res.body);

      setState(() {});
    } catch (e) {
      print('Error fetching supervisor requests: \$e');
    }
  }

  /*Future<void> _handleSupervisionAction(int requestId, String action) async {
    try {
      final res = await http.post(
        Uri.parse('${widget.apiBaseUrl}supervisor/request/action'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'request_id': requestId, 'action': action}),
      );
      if (res.statusCode == 200) {
        _fetchSupervisorRequests();
        _fetchStatistics();
      }
    } catch (e) {
      print('Error processing action: \$e');
    }
  }
*/
  Widget _buildStats() {
    return Center(
      child: Container(
        // width: MediaQuery.of(context).size.width *.8,
        // constraints: BoxConstraints(maxWidth: 800),
        child: GridView.count(
          crossAxisCount: (getAxisCount(context, 200) / 1.5).toInt(),
          childAspectRatio: 1.5,
          padding: const EdgeInsets.all(16),
          children: [
            _StatCard(label: 'Students', value: totalStudents.toString()),
            _StatCard(label: 'Supervisors', value: totalSupervisors.toString()),
            _StatCard(
              label: 'Pending Requests',
              value: pendingRequests.toString(),
            ),
            _StatCard(label: 'Total Project Requests',
                value: totalProjects.toString()),
            _StatCard(label: 'Active Groups', value: activeGroups.toString()),
            _StatCard(label: 'Approved Projects',
                value: completedProjects.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSupervisions() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: my_Grid(context, 350, 2),
      itemCount: supervisors.length,
      itemBuilder: (context, index) {
        final supervisor = supervisors[index];
        return Card(
          elevation: 25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 40),

                const SizedBox(height: 8),
                Text(
                  supervisor['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SupervisorDetailsPage(
                                    supervisorId: supervisor['firebase_uid'],
                                    supervisorName: supervisor['name'],
                                    subject: 'GP1',
                                    apiBaseUrl: widget.apiBaseUrl,
                                  ),
                            ),
                          ),

                      child: Text('GP1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder:
                                  (context) => SupervisorDetailsPage(
                                    supervisorId: supervisor['firebase_uid'],
                                    supervisorName: supervisor['name'],
                                    subject: 'GP2',
                                    apiBaseUrl: widget.apiBaseUrl,
                                  ),
                            ),
                          ),

                      child: Text('GP2'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                if (supervisor['status'] == 'approved')
                  Chip(
                    label: Text('Approved'),
                    backgroundColor: Colors.green[100],
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
    var firebaseUid = root
        .userId; //"firebase"; // REPLACED: Replace with actual Firebase UID
    final screens = [
      _buildStats(),
      _buildSupervisions(),
      AdminOfferingCourses(firebaseUid: firebaseUid),
      AdminCourseRegistration(firebaseUid: firebaseUid),
    ];
    final titles = [
      'Overview',
      'Supervisor Projects',
      'Courses Offering',
      'Course Registration',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Admin Menu', style: TextStyle(fontSize: 24)),
            ),
            ListTile(
              title: const Text('Overview'),
              leading: const Icon(Icons.dashboard),
              selected: _selectedIndex == 0,
              onTap:
                  () => setState(() {
                    _selectedIndex = 0;
                    Navigator.pop(context);
                  }),
            ),
            ListTile(
              title: const Text('Supervisor Approvals'),
              leading: const Icon(Icons.person_add),
              selected: _selectedIndex == 1,
              onTap:
                  () => setState(() {
                    _selectedIndex = 1;
                    Navigator.pop(context);
                  }),
            ),

            ListTile(
              title: const Text('Courses Offering'),
              leading: const Icon(Icons.auto_stories_rounded),
              selected: _selectedIndex == 2,
              onTap:
                  () => setState(() {
                    _selectedIndex = 2;
                    Navigator.pop(context);
                  }),
            ),
            ListTile(
              title: const Text('Course Registration'),
              leading: const Icon(Icons.assignment),
              selected: _selectedIndex == 3,
              onTap:
                  () => setState(() {
                    _selectedIndex = 3;
                    Navigator.pop(context);
                  }),
            ),

            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                // Handle logout logic here

                FirebaseAuth.instance.signOut();

                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  root.initialRoute, // ReplaceD with your login route
                );


              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:http/http.dart' as http;

class SupervisorDetailsPage extends StatefulWidget {
  final String supervisorId;
  final String supervisorName;
  final String subject;
  final String apiBaseUrl;

  const SupervisorDetailsPage({
    Key? key,
    required this.supervisorId,
    required this.supervisorName,
    required this.subject,
    required this.apiBaseUrl,
  }) : super(key: key);

  @override
  _SupervisorDetailsPageState createState() => _SupervisorDetailsPageState();
}

class _SupervisorDetailsPageState extends State<SupervisorDetailsPage> {
  List<dynamic> supervisionRequests = [];
  bool isLoading = true;
  String? error;
  List<dynamic> pendingSupervisors = [];
  List<dynamic> approvedSupervisors = [];
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    _fetchSupervisionRequests();
  }

  Future<void> _fetchSupervisionRequests() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${widget.apiBaseUrl}supervisor/requests?supervisorId=${widget.supervisorId}&subject=${widget.subject}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          requests = json.decode(response.body);
          approvedSupervisors =
              requests.where((s) => s['status'] == 'approved').toList();
          pendingSupervisors =
              requests.where((s) => s['status'] != 'pending').toList();
          supervisionRequests = [...approvedSupervisors, ...pendingSupervisors];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load requests';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _handleRequestAction(String requestId, String action) async {
    try {
      final response = await http.post(
        Uri.parse('${widget.apiBaseUrl}supervisor/request/action'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'requestId': requestId, 'action': action}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body)));
        _fetchSupervisionRequests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process request: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      setState(() => error = 'Error processing request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supervision Details and Approvals')),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      widget.supervisorName[0],
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.supervisorName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Supervisor ID: ${widget.supervisorId}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Subject: ${widget.subject}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              if (isLoading)
                CircularProgressIndicator()
              else if (error != null)
                Text(error!, style: TextStyle(color: Colors.red))
              else if (requests.isEmpty)
                Text('No supervision requests found.')
              else
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: my_Grid(context, 950),
                            itemCount: requests.length,
                            //approvedSupervisors.length,
                            itemBuilder: (context, index) {
                              final request = requests[index];
                              var count = 1;

                              if (request['status'] == 'approved') {
                                return Container(
                                  constraints: BoxConstraints(maxWidth: 100),
                                  child: Card(
                                    color: Colors.green.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Group #${count++}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text('Student #1'),
                                                    SizedBox(height: 8),
                                                    Text(request['name1']),
                                                    SizedBox(height: 8),
                                                    Text(request['id1']),
                                                    SizedBox(height: 8),
                                                    Text(request['email1']),
                                                  ],
                                                ),
                                              ),

                                              // Spacer(),
                                              // SizedBox(width: 55),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text('Student #2'),
                                                    SizedBox(height: 8),
                                                    Text(request['name2']),
                                                    SizedBox(height: 8),
                                                    Text(request['id2']),
                                                    SizedBox(height: 8),
                                                    Text(request['email2']),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                          Text(
                                              'description: ${request['description']}'),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [

                                              ElevatedButton(
                                                onPressed:
                                                    () => _handleRequestAction(
                                                      request['id'].toString(),
                                                      'remove',
                                                    ),
                                                child: Text('Delete'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                // Skip non-approved requests
                              }
                              var count2 = 1;

                              return Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: Card(
                                  color: Colors.yellow.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Request #${count2++}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text('Student #1'),
                                                  SizedBox(height: 8),
                                                  Text(request['name1']),
                                                  SizedBox(height: 8),
                                                  Text(request['id1']),
                                                  SizedBox(height: 8),
                                                  Text(request['email1']),
                                                ],
                                              ),
                                            ),

                                            // Spacer(),
                                            // SizedBox(width: 55),

                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text('Student #2'),
                                                  SizedBox(height: 8),
                                                  Text(request['name2']),
                                                  SizedBox(height: 8),
                                                  Text(request['id2']),
                                                  SizedBox(height: 8),
                                                  Text(request['email2']),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 25),
                                        Text(
                                            'description: ${request['description']}'),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed:
                                                  () => _handleRequestAction(
                                                    request['id'].toString(),
                                                    'approve',
                                                  ),
                                              child: Text('Approve'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed:
                                                  () => _handleRequestAction(
                                                    request['id'].toString(),
                                                    'reject',
                                                  ),
                                              child: Text('Reject'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              //approvedSupervisors[index];
                            },
                          ),
                        ),

                        /*Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: kIsWeb ? 3 : 1,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              if (requests[index]['status'] == 'approved') {
                                return SizedBox.shrink(); // Skip approved requests
                              }
                              final request = requests[index];

                            },
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
