import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local/announcements.dart';
import 'package:local/courseAction.dart';
import 'package:local/feedback.dart';
import 'package:local/itemwidget.dart';
import 'package:local/student_partner.dart';
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

          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Request'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_baseball_outlined), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),



        ],
      ),
    );
  }
}

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Announcements'),
      leading: Container(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Announcement Title'),
                    subtitle: Text(
                        'Apr 23, 2024\nThis is a sample announcement.'),
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

    );
  }
}


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Profile page'),
            SizedBox(height: 20),
            Card(
              
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: kIsWeb? MediaQuery.of(context).size.width *.4 : MediaQuery.of(context).size.width * .8,
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
                              'John Doe',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'johndoe@example.com',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
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
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15)

                      , child: Divider(),
                    ),

                    ProfileCard(title: "Partnership", icon: Icons.group,
                    onTap: () {
                      Navigator.pushNamed(context ,StudentPartnersScreen.routName

                      );
                    },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15)

                    , child: Divider(),
                    ),
                    // Divider(),

                    ProfileCard(title: 'Settings', icon: Icons.settings),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
