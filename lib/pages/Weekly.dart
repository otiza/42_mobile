import 'package:flutter/material.dart';
import 'package:weatherapp_proj/api/Get.dart';

class Weekly extends StatelessWidget {
  String text;
  String lat;
  String long;
  final textColor;
   Weekly({super.key,required this.text,this.textColor,required this.lat,required this.long});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
        future: getWeeklyWeather(long, lat),
        builder: (context, snapshot) {
          if(snapshot.hasError)
          {
            return Center(child: Text("Error connection to api",style: TextStyle(color: Colors.red),));
          }
          else if (snapshot.hasData){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(text,style:TextStyle(color: textColor,fontSize: 15) ,),
                  // list of daily weather
                  Center(
                    child: Container(
                      child: ListView.builder(itemCount: snapshot.data!["daily"]["time"].length,shrinkWrap: true,itemExtent: 30,physics: NeverScrollableScrollPhysics(),itemBuilder: (context, index) {
                        //it will be in this format "2023-05-14T00:00"
                        //split it to get hours
                        String time =
                            snapshot.data!["daily"]["time"][index].split("T")[0];
                        
                        return ListTile(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("$time "),
                                Text("${snapshot.data!['daily']['temperature_2m_max'][index]} °C"),
                                Text("${snapshot.data!['daily']['temperature_2m_min'][index]} °C"),
                                Text(codeToDesc(snapshot.data!['daily']['weathercode'][index]))
                              ]
                              //subtitle: Text(snapshot.data[index]["temperature"]),
                              ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      // child: Center(child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text("Weekly",style: TextStyle(color: textColor,fontSize: 30,fontWeight: FontWeight.bold)),
      //     Text(text,style:TextStyle(color: textColor,fontSize: 15) ,),
      //   ],
      // )),
    );
  }
}