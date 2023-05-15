import 'package:flutter/material.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  //at the start of the application get the location of the user
  @override
  void initState() {
    super.initState();
    _determinePosition().then(
      (value) {
        setState(() {
          text = value.toString();
          latitude = value.latitude.toString();
          longitude = value.longitude.toString();

        });
      },
    );
    
  }

  String text = "hello";
  Color textColor = Colors.black;
  String latitude = "";
  String longitude = "";
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image:const AssetImage("assets/back4.jpg"),fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black.withOpacity(1),BlendMode.dstATop))
          ),
          child: TabBarView(
            children: [
              Currently(
                  text: text,
                  textColor: textColor,
                  latitude: latitude,
                  longitude: longitude),
              Today(
                  text: text,
                  textColor: textColor,
                  lat: latitude,
                  long: longitude),
              Weekly(
                  text: text,
                  textColor: textColor,
                  lat: latitude,
                  long: longitude),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: AsyncAutocomplete(
            asyncSuggestions: (searchValue) {
              return getCitiesSuggestion(searchValue);
            },
            maxListHeight: 375,
            controller: searchController,
            decoration: textFieldDecoration,
            onSubmitted: null,
            onChanged: null,
            suggestionBuilder: (data) => ListTile(
              title: Text(data["name"]),
              subtitle: Text("${data['admin1']}, ${data['country']}"),
              onTap: () => setState(() {
                text =
                    "${data['name']} \n${data['admin1']}, ${data['country']}";
                latitude = data["latitude"].toString();
                longitude = data["longitude"].toString();
                textColor = Colors.black;
                FocusScope.of(context).unfocus();
                searchController.clear();
              }),
            ),
          ),
          //     TextField(
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
              onPressed: () async {
                setState(() {
                  //text = "Geolocation";
                  textColor = Colors.black;
                });
                _determinePosition()
                    .then((value) => setState(() {
                          //alue.latitude;
                          latitude = value.latitude.toString();
                          longitude = value.longitude.toString();
                          text = value.toString();
                        }))
                    .catchError((e) => setState(() {
                          text =
                              "Location service is not available Please enable it in settings";
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
  hintText: "Search for a location",
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
