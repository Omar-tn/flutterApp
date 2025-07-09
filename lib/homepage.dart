import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/announcements.dart';
import 'package:local/courseAction.dart';
import 'package:local/feedback.dart';
import 'package:local/itemwidget.dart';
import 'package:local/root.dart';
import 'package:local/student_partner.dart';
import 'package:local/themeData.dart';
import 'package:local/web.dart';

// import 'package:local/requestCourse.dart';
import 'bookingTab.dart';

class homePage extends StatefulWidget {

  static const String routName = 'homePage';

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var selectedIndex =0;

  List<Widget> tabs = [AnnouncementsPage(), /*NewRequestPage*/NewRequestPage(),FeedbackScreen(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
       tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {
            if (!root.debug)
              print(FirebaseAuth.instance.currentUser!
                  .uid); //REPLACE: for debugging
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Request'),
          BottomNavigationBarItem(
              icon: Icon(Icons.feed_rounded), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),



        ],
      ),
    );
  }
}

class AnnouncementsPage extends StatefulWidget {
  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  // list of announcements
  List<dynamic> announcements = [
    // Sample data
    {
      "title": "Announcement 1",
      "date": "Apr 23, 2024",
      "body": "This is a sample announcement.",
    },
    {
      "title": "Announcement 2",
      "date": "Apr 24, 2024",
      "body": "This is another sample announcement.",
    },
  ];

  bool isloading = true;

  @override
  void initState() {
    super.initState();
    // Fetch announcements from the server
    fetchAnnouncements();
  }

  //funcrion to fetch announcements from server
  Future<void> fetchAnnouncements() async {
    try {
      final response = await http.get(
          Uri.parse(root.domain() + 'announcements'));
      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = response.body.isNotEmpty ?
        jsonDecode(response.body) : [];
        // Update the announcements list
        setState(() {
          announcements = data;
        });
      } else {
        // Handle error
        print('Failed to load announcements: ${response.body}');
        setState(() {
          announcements = [];
        });
      }
    } catch (e) {
      // Handle network error
      print('Error fetching announcements: $e');
      setState(() {

      });
    } finally {
      setState(() {
        isloading = false; // Set loading to false after fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Announcements'),
      leading: Container(),
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb ? MediaQuery
              .of(context)
              .size
              .width * .4 : double.infinity,
          child: Column(
            children: [
              Expanded(
                child: isloading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(announcement['title'] ??
                            'No title provided'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(announcement['body'] ?? 'No body provided'),
                            Text(
                              announcement['time'] ?? 'No time provided',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        // trailing: Container(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),

              Expanded(child: CourseAnnouncementsScreen())
            ],
          ),
        ),
      ),

    );
  }
}


class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var name = '',
      email = '';
  List <dynamic> supervisors = [];

  @override
  void initState() {
    super.initState();
    // Fetch user data when the profile page is initialized
    getUserData();
    getSupervisors();
  }

  //get supervisors
  Future<void> getSupervisors() async {
    try {
      final response = await http.get(
        Uri.parse(root.domain() +
            'supervisorsOf?uid=${root.userId}'),
      );
      if (response.statusCode == 200) {
        supervisors = jsonDecode(response.body);
      } else {
        print('Failed to load supervisors: ${response.body}');
      }
    } catch (e) {
      print('Error fetching supervisors : $e');
    }
  }


  //get the name and email of the user
  Future<void> getUserData() async {
    try {
      final response = await http.get(
        Uri.parse(root.domain() +
            'userData?uid=${FirebaseAuth.instance.currentUser!.uid}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name = data['name'] ?? 'No name provided';
        email = data['email'] ?? 'No email provided';
      } else {
        print('Failed to load user data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        // Update the UI after fetching user data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(

        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // Text('This is the Profile page'),
              // SizedBox(height: 20),
              /*Card(

              ),*/

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: kIsWeb ? MediaQuery
                    .of(context)
                    .size
                    .width * .4 : MediaQuery
                    .of(context)
                    .size
                    .width * .8,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            // backgroundImage: AssetImage(
                            //     'assets/profile.jpg'),
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            ),

                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                email,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      /*Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),

                      ProfileCard(title: 'Phone Number',
                          icon: Icons.phone,
                          subtitle: '+1234567890'),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),

                      ProfileCard(
                        title: 'Location',
                        icon: Icons.location_on,
                        subtitle: 'New York, USA',
                      ),*/
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),

                      ProfileCard(title: "Partnership", icon: Icons.group,
                        onTap: () {
                          Navigator.pushNamed(context,
                              StudentPartnersScreen.routName

                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),
                      // Divider(),

                      //supervisors
                      ProfileCard(
                        title: 'Supervisors',
                        icon: Icons.supervisor_account,
                        onTap: () {
                          //navigate to supervisors screen
                          getSupervisors().then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => supervisorsScreen(),
                              ),
                            );
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),

                      ProfileCard(

                          title: 'Settings', icon: Icons.settings

                          , onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) =>
                                settings(
                                ),
                          ),
                        );
                      }
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15)

                        , child: Divider(),
                      ),

                      ProfileCard(
                        title: 'Logout',
                        icon: Icons.logout,
                        // titleStyle: TextStyle(color: Colors.red),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text('Confirm Logout'),
                                  content: Text(
                                      'Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: themeD.mainColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context).popUntil((
                                            route) => route.isFirst);
                                      },
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                      /*Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(),
                      ),
          */

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

  //services screen that have a feature of changing the theme and other settings
  Widget settings() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text('Change Theme'),
              trailing: Icon(Icons.color_lens),
              onTap: () {
                // Handle theme change
                themeD.changeTheme();
              },
            ),
            ListTile(
              title: Text('About'),
              trailing: Icon(Icons.info),
              onTap: () {
                // Handle about
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('About'),
                        content: Text('This is a sample app.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // supervisors screen 

  Widget supervisorsScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisors'),
      ),
      body: Center(
        child: supervisors.isEmpty
            ? Text('No supervisors found')
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ListView.builder(
                itemCount: supervisors.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final supervisor = supervisors[index];
                  return Card(
                      child: ListTile(
                        title: Text(supervisor['name'] ?? 'No name provided'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                supervisor['subject'] ?? 'No subject provided'),
                            Text(supervisor['email'] ?? 'No email provided'),
                          ],
                        ),
                        trailing: IconButton(

                          icon: Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            // Handle tap on supervisor

                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: Text('Delete Supervisor'),
                                    content: Text(
                                        'Are you sure you want to delete this supervisor?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Handle deletion logic here
                                          // For example, make an API call to delete the supervisor
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                'Supervisor delete requested')),);
                                        },
                                        child: Text('Delete', style: TextStyle(
                                            color: Colors.red)),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ));
                },
              ),
            ),
          ],
        ),

      ),
    );
  }


}
