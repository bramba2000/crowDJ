import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../core/router/utils/EventExtra.dart';
import '../events/models/event_model.dart';

///the MapModel contains methods and informations to be shown in a Map,
///it doesn't plot the map
class MapModel {
  //locations
  List<Marker> _markers = [];

  //where to center the map
  late GeoPoint _center;

  MapModel(
      {GeoPoint g = const GeoPoint(41.40293360242581, 2.1751213629094206)}) {
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

  static Future<MapModel> createEventsMap(
      List<Event> events, List<Event?> myEvents, BuildContext context) async {
    final GeoPoint center = await getCurrentLocation();
    final List<Marker> eventLocations = [];

    for (Event e in events) {
      //print("---new marker");
      eventLocations.add(
        Marker(
          point: LatLng(e.location.latitude, e.location.longitude),
          width: 60,
          height: 60,
          child: IconButton(
            onPressed: () {
              print(e.title);
              context.go(
                "/event/${e.id}",
                extra: EventExtra(
                  event: e,
                  sub: myEvents.any((obj) => obj!.id == e.id),
                ),
              );
            },
            icon: Icon(
              Icons.place,
              color: (myEvents.any((obj) => obj!.id == e.id))
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ),
      );
    }

    return MapModel._withMarkers(center, eventLocations);
  }

  //return the current geographical location of the user
  static Future<GeoPoint> getCurrentLocation() async {
    LocationData location;
    try {
      location = await Location().getLocation();
      if (location.latitude != null &&
          location.longitude != null &&
          location.latitude!.isFinite &&
          location.longitude!.isFinite) {
        return GeoPoint(location.latitude!, location.longitude!);
      } else {
        // Handle the case where latitude or longitude is not a finite number
        // You might want to use a default location or show an error message.
        print(
            'Invalid location values: latitude=${location.latitude}, longitude=${location.longitude}');
        return const GeoPoint(41.40293360242581, 2.1751213629094206);
      }
    } catch (e) {
      print('-------------------- Error : $e');
    }
    return const GeoPoint(41.40293360242581, 2.1751213629094206);
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
    for (GeoPoint pl in places) {
      addPlace(pl);
    }
  }

  //return the current center
  GeoPoint getCenter() {
    return _center;
  }

  LatLng getCenterLatLng() {
    return LatLng(getCenter().latitude, getCenter().longitude);
  }

  //return all the Marker in _markers
  List<Marker> getMarkers() {
    return _markers;
  }

  //esteem the zoom based on the distance (radius)
  double calculateZoomLevel(double distanceInKm, double mapWidth) {
    const double earthRadius = 6371.0; // Earth radius in kilometers
    const double paddingFactor =
        1.1; // A padding factor to provide some extra space

    // Calculate the angular distance covered by the given distance
    double angularDistance = distanceInKm / earthRadius;

    // Calculate the zoom level based on the screen width and angular distance
    double zoomLevel =
        log(mapWidth / (angularDistance * 256.0 * paddingFactor)) / log(2.0);

    // Ensure the zoom level is within a reasonable range
    return max(0.0, min(zoomLevel, 18.0));
  }
}
