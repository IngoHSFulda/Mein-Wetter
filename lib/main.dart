import 'dart:async';
import 'dart:io';
import 'global.dart' as globals;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:drop_shadow/drop_shadow.dart';
void main() {var adresse;
  runApp(const MyApp());


}
enum Loading { NOT_LOADING, LOADING, LOADED }
class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.


  @override
  AppState createState() => AppState();
}
class AppState extends State {

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow[50],
        child: const Layout());
  }

}


class Wetteddaten extends StatefulWidget{
  const Wetteddaten({Key? key}) : super(key: key);

  @override
  WetterdatenContent createState() => WetterdatenContent();
}

class getPositionAdress extends StatefulWidget{
  const getPositionAdress({Key? key}) : super(key: key);

  @override
  AdressCalc createState() => AdressCalc();
}

class AdressCalc extends State {
   ValueNotifier<String> placeNotify  = ValueNotifier('Lädt');

  @override
  void initState() {

    debugPrint("OUTSIDE");
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
debugPrint("TIMER");
_updateState();
    });
    super.initState();
  }
  AdressCalc() {
    var counter = 3;

}

List<Placemark> geodata = [];

  int counter =0;
  void _updateState() {
   if(globals.placemarks.toString() != "[]") {
      placeNotify.value = globals.placemarks[0].subLocality.toString();
    }

}


  @override
  Widget build(BuildContext context) {
    return Container(


        child: Row(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children:<Widget> [


      ValueListenableBuilder(valueListenable:placeNotify ,builder: (context,value,child){
              return Text(value.toString(),textDirection: TextDirection.ltr, textAlign: TextAlign.center,style: const TextStyle(fontSize: 20, fontWeight:FontWeight.w300,color: Colors.black45));
            },)

      ],
        ),

            );


    // TODO: implement build
    throw UnimplementedError();
  }
  void reverseGeocodingSearch() async {

 // adresse = await googleGeocoding.geocoding.get("1600 Amphitheatre",null);

  }


}




class WetterdatenContent extends State {
  ValueNotifier<String> weatherNoty = ValueNotifier('Lädt');
  ValueNotifier<String> tempNoty = ValueNotifier('Lädt');
  ValueNotifier<String> windNoty = ValueNotifier('Lädt');
  ValueNotifier<String> directionNoty = ValueNotifier('Lädt');
  ValueNotifier<String> IconNoty = ValueNotifier('');

  WetterdatenContent() {
    weatherNoty = ValueNotifier('Lädt');
    tempNoty = ValueNotifier('Lädt');
    windNoty = ValueNotifier('Lädt');
    directionNoty = ValueNotifier('Lädt');
    IconNoty = ValueNotifier('');
    var periodicTimer = Timer.periodic(
      const Duration(seconds: 2),
          (timer) {
        // Update user about remaining time
        _getLocation();git remote add origin https://gitlab.com/ingo.schwarzhaupt/mein-wetter.git
      },
    );
  }

  String _key = '';
  late WeatherFactory ws;


  double? lat = 50.483400;
  double? lon = 9.399740;


  void _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }


  requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(_key, language: Language.GERMAN);
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());


    List<Weather> weather = await ws.fiveDayForecastByLocation(lat!, lon!);
    setState(() {
      globals.data = weather;
    });
    print("Wetter");
    if (globals.data[0].country == null || globals.data[0].country == 0) {
      globals.country = "Außerhalb";
    } else {


    }
    print(globals.data[0].date);
    print(globals.data[1].date);
    weatherNoty.value = globals.data[globals.id].weatherDescription.toString();
    tempNoty.value = globals.data[globals.id].temperature.celsius.toStringAsFixed(2);
    windNoty.value = globals.data[globals.id].windSpeed.toString();
    directionNoty.value = globals.data[globals.id].windDegree.toString();
    IconNoty.value = globals.data[globals.id].weatherIcon.toString();

  }

  printLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 2));
    print("Das ist die POSITION !!");
    globals.lat = position.latitude;
    globals.lon = position.longitude;
    globals.userPosition = LatLng(position.latitude, position.longitude);
    queryWeather();
    print(globals.lat);
    print(globals.lon);
    globals.placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print("Davor");
    print(globals.placemarks[0].subLocality.toString());
    print("Danachr");
  }


  @override
  Widget build(BuildContext context) {
    return Container(


      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[


            Container(


                child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: DropShadow(
                          blurRadius: 10,

                          offset: const Offset(3, 3),
                          spread: 1,
                          child: Container(


                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEC3DEC),
                                    Color(0xFF73C5ED)
                                  ],
                                ),
                                border: Border.all(
                                  width: 2,
                                ),

                              ),
                              child: ValueListenableBuilder(
                                valueListenable: weatherNoty,
                                builder: (context, value, child) {
                                  return Text(value.toString(),
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.center);
                                },
                              ),


                            ),
                          ),
                        ),
                      ),

                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: DropShadow(
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                          spread: 1,
                          child: Container(

                            child: Container(


                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEC3DEC),
                                    Color(0xFF73C5ED)
                                  ],
                                ),
                                border: Border.all(
                                  width: 2,
                                ),

                              ),
                              child: ValueListenableBuilder(
                                valueListenable: windNoty,
                                builder: (context, value, child) {
                                  return Text("Windstärke\n" + value.toString(),
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.center);
                                },
                              ),


                            ),
                          ),
                        ),
                      ),
                    ]
                )
            ),

            Container(

              child: ValueListenableBuilder(
                valueListenable: IconNoty, builder: (context, value, child) {
                return Image.network(
                  'http://openweathermap.org/img/w/' + value.toString() +
                      '.png',
                  width: 60.0,
                );
              },
              ),

            ),

           Container(
                child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: DropShadow(
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                          spread: 1,
                          child: Container(

                            child: Container(

                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.orange[200],
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEC3DEC),
                                      Color(0xFF73C5ED)
                                    ],
                                  ),
                                  border: Border.all(
                                    width: 2,
                                  ),

                                ),
                                child: Container(
                                  child: ValueListenableBuilder(
                                    valueListenable: tempNoty,
                                    builder: (context, value, child) {
                                      return Text(
                                        "Temperatur\n" + value.toString(),
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.center,);
                                    },
                                  ),


                                )
                            ),
                          ),
                        ),
                      ),


                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: DropShadow(
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                          spread: 1,
                          child: Container(

                            child: Container(


                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEC3DEC),
                                    Color(0xFF73C5ED)
                                  ],
                                ),
                                border: Border.all(
                                  width: 2,
                                ),

                              ),
                              child: ValueListenableBuilder(
                                valueListenable: directionNoty,
                                builder: (context, value, child) {
                                  return Text(
                                    "Windrichtung\n" + value.toString(),
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.center,);
                                },
                              ),


                            ),
                          ),
                        ),
                      ),

                    ]

                )
            )
          ]
      ),
    );
  }
}
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void initState() {

    debugPrint("OUTSIDE");
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      debugPrint("TIMER");
      _add();
      _goToTheLake();
    });
    super.initState();
  }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.lat, globals.lon),
    zoom: 16.4746,
  );

  void _add() {

    final MarkerId markident = const MarkerId("Position");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markident,
      position: LatLng(
        globals.lat,
        globals.lon,
      ),

    );

    setState(() {
      // adding a new marker to map
      markers[markident ] = marker;
    });
  }

       CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(globals.lat ,globals.lon),
      tilt: 59.440717697143555,
      zoom: 16.151926040649414);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
          markers:Set<Marker>.of(markers.values),
      ),

    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: globals.userPosition, zoom: globals.zoomValue),
    ),);
  }
}

class  Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);


  @override
  LayoutState createState() => LayoutState();
  }

class LayoutState extends State {
  ValueNotifier<String> Name = ValueNotifier('Wetter in drei Stunden');
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Container( child:Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget> [

          SizedBox(height: 50),
          Flexible(
            flex: 1,
            child: Container(padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                    color: Colors.orange[200],
                    border: Border.all(width: 2.0, color: Colors.black45)
                ),
                child: getPositionAdress()
            )
          ),

          Flexible(
            flex: 2,
            child:Container(color: Colors.cyan[100],
                padding: const EdgeInsets.all(10),
                child: Wetteddaten(),

          ) ,
          ),
          Flexible(
            flex: 2,
            child:MaterialApp(color: Colors.blue,
              title: 'Flutter Google Maps Demo',
              home: MapSample(),

            ),
          ),
          Flexible(
              flex: 1,
              child:Directionality(
                  textDirection: TextDirection.ltr,
                  child: Material(//
                child: InkWell(
                  onTap: () {
                    setState(() {
                     if(globals.id == 0){
                       globals.id = 1;
                       Name = ValueNotifier('Wetter jetzt');
                     } else{
                       globals.id = 0;
                       Name = ValueNotifier('Wetter in drei Stunden');
                     }
                    });
                  },
                  child:  Container(padding: const EdgeInsets.all(50),
                    width: 250,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFC0CA33),
                          Color(0xFFAED581)
                        ],
                      ),
                      border: Border.all(
                        width: 2,
                      ),

                    ),

                    child: ValueListenableBuilder(

                  valueListenable: Name,
                  builder: (context, value, child) {
                    return Text( value.toString(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center);
                  },
                ),

                ),
                  )
              )
              )
          )
        ]


    )

    );
  }
}

