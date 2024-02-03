import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

LatLng toLatLng(GeoPoint geoPoint) {
  return LatLng(geoPoint.latitude, geoPoint.longitude);
}

GeoPoint toGeoPoint(LatLng latLng) {
  return GeoPoint(latLng.latitude, latLng.longitude);
}

const _distance = Distance();

double radiusFromBounds(LatLngBounds bounds) {
  return _distance.as(LengthUnit.Kilometer, bounds.center, bounds.northEast);
}
