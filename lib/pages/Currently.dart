import 'package:flutter/material.dart';
import 'package:weatherapp_proj/api/Get.dart';

class Currently extends StatefulWidget {
  String text;
  final textColor;

  String latitude;
  String longitude;
  Currently({
    super.key,
    required this.text,
    this.textColor,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<Currently> createState() => _CurrentlyState();
}

class _CurrentlyState extends State<Currently> {
  //fetch data at the begginin
  String temp = "";
  String windSpeed = "";
  int code = 0;
  // @override
  // void initState() {
  //   getCurrentWeather(widget.longitude, widget.latitude).then((value) {
  //     setState(() {
  //       temp = value["current_weather"]["temperature"].toString();
  //       windSpeed = value["current_weather"]["windspeed"].toString();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getCurrentWeather(widget.longitude, widget.latitude),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 23, 50, 69),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "${snapshot.data!["current_weather"]["temperature"]} °C",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 112, 10),
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      codeToDesc(
                          snapshot.data!["current_weather"]["weathercode"]),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 23, 50, 69), fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Icon(
                      codeToicon(
                          snapshot.data!["current_weather"]["weathercode"]),
                      size: 80,
                      color: const Color.fromARGB(255, 255, 112, 10),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        const Icon(Icons.wind_power_outlined,
                            size: 30, color:Color.fromARGB(255,23, 50, 69),),
                        const SizedBox(width: 10,),
                        Text(
                      "${snapshot.data!['current_weather']['windspeed']} km/h",
                      style: const TextStyle(color:Color.fromARGB(255, 23, 50, 69), fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                      ],
                    ),
                    
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text(
                  "error while connectiong to server",
                  style: TextStyle(color: Colors.red),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
