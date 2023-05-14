import 'package:flutter/material.dart';
import 'package:weatherapp_proj/api/Get.dart';

class Today extends StatelessWidget {
  String text;
  String lat;
  String long;
  final textColor;
  Today(
      {super.key,
      required this.text,
      this.textColor,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getDailyWeather(long, lat),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text("Error connection to api",style: TextStyle(color: Colors.red),),);
              }
              else if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text(
                        text,
                        style: TextStyle(color: textColor, fontSize: 15),
                      ),
                      // list of daily weather
                      Center(
                        child: Container(
                          child: ListView.builder(itemCount: snapshot.data!["hourly"]["time"].length,shrinkWrap: true,itemExtent: 30,physics: NeverScrollableScrollPhysics(),itemBuilder: (context, index) {
                            //it will be in this format "2023-05-14T00:00"
                            //split it to get hours
                            String time =
                                snapshot.data!["hourly"]["time"][index].split("T")[1];
                            
                            return ListTile(
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("$time "),
                                    Text("${snapshot.data!['hourly']['temperature_2m'][index]} °C"),
                                    Text("${snapshot.data!['hourly']['windspeed_10m'][index]} km/h")
                                  ]
                                  //subtitle: Text(snapshot.data[index]["temperature"]),
                                  ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20,),

                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
        // child: Center(child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Today",style: TextStyle(color: textColor,fontSize: 30,fontWeight: FontWeight.bold)),
        //     Text(text,style:TextStyle(color: textColor,fontSize: 15) ,),
        //   ],
        // )),
        );
  }
}
