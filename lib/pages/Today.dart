import 'package:flutter/material.dart';


class Today extends StatelessWidget {
  String text;
  final textColor;
   Today({super.key,required this.text,this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Today",style: TextStyle(color: textColor,fontSize: 30,fontWeight: FontWeight.bold)),
          Text(text,style:TextStyle(color: textColor,fontSize: 15) ,),
        ],
      )),
    );
  }
}