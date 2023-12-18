import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapModel {

  List<Marker> _markers = [];
  late GeoPoint _center;

  MapModel({GeoPoint g = const GeoPoint(48.38374662182102, 62.50187384520631 )}){
    _center=g;
  }

  MapModel._(this._center);

  static Future<MapModel> create() async{
    final GeoPoint center = await getCurrentLocation();
    return MapModel._(center);
  }

  static Future<GeoPoint> getCurrentLocation() async {
    LocationData location;
    try {
      location = await Location().getLocation();
      return GeoPoint(location.latitude!, location.longitude!);
    } catch (e) {
      print('Error: $e');
    }
    return const GeoPoint(0, 0);
  }

  void addPlace(GeoPoint place) {
    _markers.add(
      Marker(
        point: LatLng(place.latitude, place.longitude), //
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: () => print("lat: ${place.latitude} and lng: ${place.longitude}"),
          icon: const Icon(
            Icons.place,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void addYourCurrentPlace(GeoPoint place) {
    print("addYourCurrentPlace");
    _markers.add(
      Marker(
        point: LatLng(place.latitude, place.longitude), //
        width: 80,
        height: 80,
        child: IconButton(
          onPressed: () => print("clik"),
          icon: const Icon(
            Icons.place,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  void updatePlace(GeoPoint place){
    print("updatePalce");
    _markers.clear();
    addPlace(place);
  }

  void updateCenter(GeoPoint place){
    print("updateCenter");
    _center=place;
  }

  void updatePlaces(List<GeoPoint> places){
    _markers.clear();
    for(GeoPoint pl in places)
      addPlace(pl);
  }

  GeoPoint getCenter(){
    return _center;
  }

  List<Marker> getMarkers(){
    return _markers;
  }


}
