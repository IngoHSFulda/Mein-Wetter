import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather/weather.dart';
List<Location> locations =[];
List<Placemark> placemarks =[];
List<Weather> data = [];
String country ="";
List<Double>  latilongi = [];
double lat = 50.483400;
double lon = 9.399740;


// Wetter Zeit

String time = "Wetter in einer Stunde";
int id = 0;

LatLng userPosition  = LatLng(50.483400, 9.399740);

double zoomValue = 16.151926040649414;
