import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../events/models/event_model.dart';

///the MapModel contains methods and informations to be shown in a Map,
///it doesn't plot the map
class MapModel {
  //locations
  List<Marker> _markers = [];

  //where to center the map
  late GeoPoint _center;

  MapModel(
      {GeoPoint g = const GeoPoint(48.38374662182102, 62.50187384520631)}) {
    _center = g;
  }

  //private constructor. See create() static constructor
  MapModel._(this._center);

  static Future<MapModel> create() async {
    final GeoPoint center = await getCurrentLocation();
    return MapModel._(center);
  }

  ///privare constructor to use when building the map with all 
  ///the events close to a User. See createEventsMap() static constructor
  MapModel._withMarkers(this._center, this._markers);

  static Future<MapModel> createEventsMap(List<Event> events) async {
    final GeoPoint center = await getCurrentLocation();
    final List<Marker> eventLocations = [];

    for (Event e in events) {
      eventLocations.add(
        Marker(
          point: LatLng(e.location.latitude, e.location.longitude),
          width: 60,
          height: 60,
          child: IconButton(
            onPressed: () => print("${e.title}"),
            icon: const Icon(
              Icons.place,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return MapModel._withMarkers(center,eventLocations );
  }

  //return the current geographical location of the user
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

  //add a red Marker in _markers
  void addPlace(GeoPoint place) {
    _markers.add(
      Marker(
        point: LatLng(place.latitude, place.longitude), //
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: () =>
              print("lat: ${place.latitude} and lng: ${place.longitude}"),
          icon: const Icon(
            Icons.place,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  //add a blue Marker in _markers
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

  //clear all the _markers and add a new one
  void updatePlace(GeoPoint place) {
    print("updatePalce");
    _markers.clear();
    addPlace(place);
  }

  //update where to center the map
  void updateCenter(GeoPoint place) {
    print("updateCenter");
    _center = place;
  }

  //does the same of appPalce() but for a list of GeoPoint
  void updatePlaces(List<GeoPoint> places) {
    _markers.clear();
    for (GeoPoint pl in places) addPlace(pl);
  }

  //return the current center
  GeoPoint getCenter() {
    return _center;
  }

  //return all the Marker in _markers
  List<Marker> getMarkers() {
    return _markers;
  }
}
