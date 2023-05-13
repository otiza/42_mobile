import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp_proj/api/Get.dart';

import 'package:weatherapp_proj/pages/Currently.dart';
import 'package:weatherapp_proj/pages/Today.dart';
import 'package:weatherapp_proj/pages/Weekly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    //return Future.error('Location services are disabled.');
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      //return Future.error('Location permissions are denied');
      throw Exception('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
   // return Future.error(
    //  'Location permissions are permanently denied, we cannot request permissions.');
    throw Exception(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class _HomeState extends State<Home> {

  
  String text = "hello";
  Color textColor = Colors.black;
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: TabBarView(
          children: [
            Currently(text: text,textColor: textColor),
            Today(text: text,textColor: textColor),
            Weekly(text: text,textColor: textColor),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title:  TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: searchController,
              decoration: textFieldDecoration,
            ),
            suggestionsCallback: (pattern) async{
              return await getCitiesSuggestion(pattern);
              //return CitiesService.getSuggestions(pattern);

              print("a");
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: const Icon(Icons.location_city),
                title: Text("${suggestion['name']}, ${suggestion['admin1']}, ${suggestion['country']}"),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                textColor = Colors.black;
                text = suggestion['name'];
                searchController.clear();
              });
            
            },
          ),
          // TextField(
          //   decoration: textFieldDecoration,
          //   controller: searchController,
          //   onSubmitted: (value) => setState(() {
          //     textColor = Colors.black;
          //     text = value;
          //     searchController.clear();
          //   }),
          // ),
          actions: [
            const VerticalDivider(
              width: 1,
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: ()async {
                setState(() {
                  //text = "Geolocation";
                  textColor = Colors.black;
                  
                });
                _determinePosition().then((value) => setState(() {
                  value.latitude;
                  text = value.toString();
                })).catchError((e) => setState(() {
                  text = "Location service is not available Please enable it in settings";
                  textColor = Colors.red;
                }));
                //await _getLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
 
  const BottomBar({
    super.key,
    
  });

  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      child: TabBar(
        labelColor: Colors.black,
        tabs: [
          Tab(
            icon: Icon(Icons.wb_sunny_outlined),
            text: "Currently",
          ),
          Tab(
            icon: Icon(Icons.today_outlined),
            text: "Today",
          ),
          Tab(
            icon: Icon(Icons.calendar_month_outlined),
            text: 'Weekly',
          ),
        ],
      ),
    );
  }
}

InputDecoration textFieldDecoration = InputDecoration(
              hintStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              hintText: "Search",
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              filled: true,
              fillColor: Colors.blueGrey[300],
            );
