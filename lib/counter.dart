import 'package:flutter/material.dart';

import 'home.dart';

class counter extends StatefulWidget {
  static const String routName = 'counter';
  int cnt = 0;

  // @override
  /* Widget build(BuildContext context) {

  return Scaffold(

  );

  }*/

  @override
  State<StatefulWidget> createState() {
    return counterState();
  }
}

class counterState extends State<counter> {
  int cnt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: ElevatedButton(
            child: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },),
          title: Text('omar counter'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$cnt', style: TextStyle(fontSize: 40)),
            FloatingActionButton(
              onPressed: () {
                cnt++;
                setState(() {});
                print(cnt);
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

/*



 */
