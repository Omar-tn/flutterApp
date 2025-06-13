  import 'package:flutter/material.dart';
import 'package:local/bookingTab.dart';
import 'package:local/itemwidget.dart';
import 'package:local/titleWidget.dart';

class home extends StatefulWidget {
  static const String routName = 'home';

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/aqsa.jpeg',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(

            title: Text('quran', style: Theme
                .of(context)
                .textTheme
                .bodyLarge,),
            // TextStyle(color: Colors.indigo, fontSize: 40, fontWeight: FontWeight.bold,),),
            centerTitle: true,

            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          bottomNavigationBar: BottomNavigationBar(

              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
                setState(() {

                });
              },

              items: [

                BottomNavigationBarItem(icon: Icon(Icons.home),
                    label: 'home'),
                BottomNavigationBarItem(icon: Icon(Icons.book),
                    label: 'book'),

              ]),


          body: tabs[selectedIndex],

        )


      ],
    );
  }

  List<Widget> tabs = [galarry(), BookingTab()];
}

class galarry extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('omar home'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            iconColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),

          child: Icon(Icons.arrow_back),
        ),
      ),
      // body: Container(
      //   color: Colors.green,
      //   child:Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       Text('omar'),
      //       Text('smeer'),
      //
      //
      //     ],
      //   ),
      //
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('back'),
            ),
            Row(
              children: [
                titlewidget(text: 'meats', color: Colors.red),
                SizedBox(width: 5),

                titlewidget(text: 'vegetbales', color: Colors.green),
              ],
            ),
            Row(

              children: [
                // Expanded(child: Stack(children:[ ])),
                itemWidget(image: 'assets/images/profile.jpg'),
                SizedBox(width: 5),
                Text('data')
              ],

            ),
            Row(
              children: [
                itemWidget(image: 'assets/images/aqsa.jpeg'),

                itemWidget(image: 'assets/images/cup.jpeg'),
              ],
            ),
            Row(
              children: [
                itemWidget(image: 'assets/images/hidden3d.jpeg'),

                itemWidget(image: 'assets/images/lara_tomb.jpg'),
              ],
            ),
            Row(
              children: [
                itemWidget(image: 'assets/images/aqsa.jpeg'),

                itemWidget(image: 'assets/images/cup.jpeg'),
              ],
            ),
            Row(
              children: [
                itemWidget(image: 'assets/images/hidden3d.jpeg'),

                itemWidget(image: 'assets/images/lara_tomb.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



