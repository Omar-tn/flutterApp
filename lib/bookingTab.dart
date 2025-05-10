import 'package:flutter/material.dart';

class BookingTab extends StatelessWidget {
  BookingTab({super.key});

  List<String> words = [
    'i',
    '\'ve',
    'been',
    'reading',
    'books',
    'of',
    'old',
    'the',
    'legend',
    'myth',
    'the',
    'testeman',
    'they',
    'told',
    'hurcles',
    'and',
    'his',
    'fits',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(width: 150),

                    Expanded(
                      flex: 2,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black, thickness: 3);
                        },
                        itemBuilder: (context, index) {
                          return Text(words[index]);
                        },
                        itemCount: words.length,
                      ),
                    ),
                    // SizedBox(width: 50,),
                  ],
                ),
                Text('omar'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
