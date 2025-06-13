import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:local/root.dart';

class StudentPartnersScreen extends StatefulWidget {
  static String routName = 'studentPartners';

  @override
  _StudentPartnersScreenState createState() => _StudentPartnersScreenState();
}

class _StudentPartnersScreenState extends State<StudentPartnersScreen> {
  List<dynamic> availableStudents = [];
  final String userId = 'firebase'; // Replace with actual user ID
  List<dynamic> confirmedPartners = [];

  var msg = "none";

  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(root.domain() + 'partners/available?uid=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          msg = data['msg'] ?? "none";
        });

        if (data['msg'] != "none") {
          setState(() {
            confirmedPartners = data['confirmed'] ?? [];
            availableStudents = data['available'] ?? [];
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('You already partners.')));
        } else {
          setState(() {
            availableStudents = data['available'] ?? [];
            confirmedPartners = [];
          });
        }
      } else {
        print('Error fetching students: ' + response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching students: ${response.reasonPhrase}'),
          ),
        );
      }
    } catch (error) {
      print('Error fetching students: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching students. Please try again later.'),
        ),
      );
    }
  }

  //get the available students from the server and display them in a list
  



  /*Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse(root.domain()+'partners/available?uid=$userId'));
    if (response.statusCode == 200) {
      setState(() {

      });
    }
  }
*/
  Future<void> sendRequest(String toId, String Subject) async {
    try {
      final response = await http.post(
        Uri.parse(root.domain() + 'partners/request'),
        body: {'from_id': userId, 'to_id': toId, 'subject': Subject},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Request sent successfully')));

        fetchStudents();
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Partner'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                FutureBuilder<http.Response>(
                  future: getPartnerRequests(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox
                          .shrink(); // Return an empty space while loading
                    } else if (snapshot.hasError) {
                      return SizedBox.shrink(); // Handle any errors (optional)
                    } else if (snapshot.hasData) {
                      final response = snapshot.data!;
                      if (response.statusCode == 200) {
                        final data = json.decode(response.body);
                        if (data.isNotEmpty) {
                          return Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 12, minHeight: 12),
                              child: Text(
                                data.length.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),

              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, NotificationScreen.routName);
            },
          ),


        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {
          //change current body of the scaffold

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_sharp),
            label: 'Supervisor',
          ),
        ],
      ),

      body:
      selectedIndex ==0

      ?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            msg != "none"
                ? Column(
                  children: [
                    Text('Your partners:'),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: confirmedPartners.length,
                      itemBuilder: (context, index) {
                        final partner = confirmedPartners[index];
                        return ListTile(
                          title: Text(partner['name'] ?? 'Unnamed'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(partner['subject'] ?? 'No course'),
                              Text(partner['firebase_uid'] ?? 'No section'),
                              Text(partner['email'] ?? 'No email'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              var id = partner['id'];
                              try {
                                final response = await http.delete(
                                  Uri.parse(
                                    root.domain() + 'partners/request/$id',
                                  ),
                                );
                                if (response.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Partner deleted successfully',
                                      ),
                                    ),
                                  );
                                  fetchStudents();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error deleting request: ${response.reasonPhrase}',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print('Error deleting request: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error deleting request. Please try again later.',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text('Remove'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(thickness: 20, color: Colors.teal),
                    ),
                    SizedBox(height: 50),

                  ],
                )
                : SizedBox.shrink(),

            availableStudents.isEmpty
                ? msg == "full"
                ? Center(child: Text('You have full number of partners',
                style: TextStyle(fontSize: 25,
                    fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                    color: Colors.green)
                ))
                :Center(child: Text('No available students found'))
                : Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableStudents.length,
                    itemBuilder: (context, index) {
                      final student = availableStudents[index];
                      return ListTile(
                        title: Text(student['name'] ?? 'Unnamed'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student['subject'] ?? 'No course'),
                            Text(student['firebase_uid'] ?? 'No section'),
                            Text(student['email'] ?? 'No email'),
                          ],
                        ),

                        trailing: ElevatedButton(
                          onPressed:
                              () => sendRequest(
                                student['firebase_uid'],
                                student['subject'],
                              ),
                          child: Text('Request'),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      )
          : taps[selectedIndex]
    );
  }

  List<dynamic> taps = [SizedBox.shrink(),search(), supervisor()];

}


Future<http.Response> getPartnerRequests(String userId) async {
  final response = await http.get(
      Uri.parse(root.domain() + 'partners/requests?uid=$userId'));
  return response;
}

class NotificationScreen extends StatefulWidget {
  static const routName = '/notifications';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> partnerRequests = [];
  final String userId = 'firebase'; // Replace with actual user ID
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPartnerRequests();
  }

  Future<void> fetchPartnerRequests() async {
    setState(() {
      isLoading = true;
    });
    try {
      http.Response response = await getPartnerRequests(userId);
      if (response.statusCode == 200) {
        setState(() {
          partnerRequests = json.decode(response.body) ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error fetching partner requests: ${response.reasonPhrase}'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching partner requests: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error fetching partner requests. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  Future<void> handleRequest(String requestId, bool isAccepted) async {
    try {
      final response = await http.post(
        Uri.parse(root.domain() + 'partners/requests/action'),
        body: {
          'request_id': requestId,
          'action': isAccepted ? 'accept' : 'reject',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAccepted
                ? 'Request accepted successfully'
                : 'Request rejected successfully'),
          ),
        );
        fetchPartnerRequests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      print('Error processing request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing request. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partner Requests'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : partnerRequests.isEmpty
          ? Center(child: Text('No partner requests found'))
          : Center( // Center aligns the content on the entire screen
        child: ListView.builder(
          shrinkWrap: true, // Ensures ListView doesn't take extra space
          itemCount: partnerRequests.length,
          itemBuilder: (context, index) {
            final request = partnerRequests[index];
            return ListTile(
              title: Text(request['partner_name'] ?? 'Unnamed',
              style: Theme.of(context).textTheme.headlineMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request['subject'] ?? 'No course'),
                  Text(
                    request['partner_email'] ?? 'No email',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => handleRequest(request['id'].toString(), true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Accept'),
                  ),
                  SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () => handleRequest(request['id'].toString(), false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Reject'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

////////////////////notification.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/////////////////////search.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


/////////////////////////////////////////////////////////////////////////////////////////////

class search extends StatefulWidget {
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  String sub = "";

  String field = "Name" ;

  String text = "";

  final String userId = 'firebase'; //REPLACE: Replace with actual user ID
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Subject'),
              items: ['GP1', 'GP2']
                  .map((subject) =>
                  DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  // Update the selected subject
                });
                sub = value! ;
              },
              validator: (value) =>
              value == null ? 'Please select a subject' : null,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Search Type'),
              items: ['Name', 'firebase_uid']
                  .map((searchType) =>
                  DropdownMenuItem<String>(
                    value: searchType,
                    child: Text(searchType),
                  ))
                  .toList(),
              onChanged: (value) {
                field = value!;
              },
              validator: (value) =>
              value == null ? 'Please select a search type' : null,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: "Enter search text",
                helperText: "student name or firebase_uid",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                text = value;
              },
              validator: (value) =>
              value == null || value.isEmpty ? 'Search text required' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate() ?? false) {
                  // Handle validated search button press
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => searchResult(

                        uid: userId,
                        subject: sub ?? 'GP1'   ,
                        field: field ?? 'Name',
                        text: text,
                      ),
                    ),
                  );

                }
              },
              label: Text('Search'),
              icon: Icon(Icons.search),

            ),
            SizedBox(height: 20),
            ElevatedButton(


              onPressed: sub.isEmpty ? null : () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text(
                          'Are you sure you want to make a public request?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            try {
                              final response = await http.post(
                                Uri.parse(root.domain() + 'partners/request'),
                                body: {
                                  'from_id': userId,
                                  'to_id': '',
                                  'subject': sub,
                                },
                              );
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Public request created successfully for $sub')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Error creating public request: ${response
                                          .body}')),
                                );
                              }
                            } catch (e) {
                              print('Error creating public request: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                    'Error creating public request. Please try again later.')),
                              );
                            }
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: sub.isEmpty ? Colors.grey : null,
              ),
              child: Text('Public Request'),
            ),
          ],
        ),
      ),
    );
  }
}


///////////search.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//////////searchResult.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class searchResult extends StatefulWidget {
  static String routName = 'searchResult';
  final String subject;
  final String field;
  final String text;
  final String uid;


  const searchResult({
    required this.uid,
    required this.subject,
    required this.field,
    required this.text,
  });

  @override
  State<searchResult> createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  List<dynamic> searchResults = [];

  Map<String, dynamic> result = {};

  @override
  void initState() {
    super.initState();
    searchStudents();
  }

  // make a function to request students based on uid
  // Function to send a partnership request based on uid
  Future<void> sendPartnershipRequest(String toUid, String subject) async {
    try {
      final response = await http.post(
        Uri.parse(root.domain() + 'partners/request'),
        body: {
          'from_id': 'firebase', // Replace with actual user ID if needed
          'to_id': toUid,
          'subject': subject,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error sending request: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error sending request. Please try again later.')),
      );
    }
  }

  //search for student partners based on subject, field, and text and list the students result
  Future<void> searchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
          root.domain() + 'partners/search?uid=${widget.uid}&subject=${widget
              .subject}&field=${widget.field}&text=${widget.text}',
        ),
      );

      setState(() {

      });

      if (response.statusCode == 200) {
        searchResults = json.decode(response.body);
      }
      else if (response.statusCode == 500) {
        print('you have already partner');
        result = json.decode(response.body);
        print('No students found for the given criteria.');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(result['message']),
          ),
        );
      }
      else {
        print('Error searching students: ${response.reasonPhrase}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
                'Error searching students: ${response.reasonPhrase} ' +
                    response.body),
          ),
        );
      }
    } catch (e) {
      print('Error searching students: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text('Error searching students. Please try again later.'),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body:
      result['hasPartner'] ?? false
          ? Center(child: Text('You have already a partner',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))

          : ListView.builder(
        itemCount: searchResults?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(searchResults[index]['name'] ?? ''),
              subtitle: Text(searchResults[index]['field'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () {
                  sendPartnershipRequest(
                      searchResults[index]['id'], widget.field);
                },
                child: Text('Send Request'),
              ),
            ),
          );
        },
      ),
    );
  }
}

////////////////searchResult.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

///////////////supervisor.dart\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


class supervisor extends StatefulWidget {
  @override
  State<supervisor> createState() => _supervisorState();
}

class _supervisorState extends State<supervisor> {
  String userId = 'firebase'; //REPLACE: Replace with actual user ID 
  List<dynamic> partners = [];
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String? selectedSubject;
  String? selectedDoctor;
  String projectDescription = '';
  List<String> doctors = ['Dr. Ali', 'Dr. Sara', 'Dr. Ahmed'];


  @override
  void initState() {
    super.initState();
    getPartners();
  }

  Future<void> getPartners() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(root.domain() + 'user/partnerships?uid=$userId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          partners = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Error fetching partners: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Error fetching partners: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error fetching partners. Please try again later.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: partners.isEmpty
          ? Text('You have no partners',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Request Supervisor',
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Subject'),
                value: selectedSubject,
                items: partners.map((partner) {
                  return DropdownMenuItem<String>(
                    value: partner['subject'],
                    child: Text(partner['subject'] ?? ''),
                  );
                }).toList(),
                validator: (value) =>
                value == null ? 'Please select a subject' : null,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Supervisor'),
                value: selectedDoctor,
                items: doctors
                    .map((doctor) =>
                    DropdownMenuItem<String>(
                      value: doctor,
                      child: Text(doctor),
                    ))
                    .toList(),
                validator: (value) =>
                value == null ? 'Please select a supervisor' : null,
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                value != null && value.isEmpty
                    ? null
                    : null,
                onChanged: (value) {
                  setState(() {
                    projectDescription = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Handle form submission
                    print('Subject: $selectedSubject');
                    print('Doctor: $selectedDoctor');
                    print('Description: $projectDescription');
                  }
                },
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

