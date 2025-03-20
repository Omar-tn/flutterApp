import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local/itemwidget.dart';
import 'package:local/titleWidget.dart';

class home extends StatelessWidget {
  static const String routName = 'home';

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
