import 'package:flutter/cupertino.dart';

class itemWidget extends StatelessWidget {
  String image;

  itemWidget({required this.image});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Stack(children: [Image.asset(image)]));
  }
}
