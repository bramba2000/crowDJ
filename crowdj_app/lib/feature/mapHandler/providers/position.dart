import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position.g.dart';

@riverpod
Future<LatLng> currentPosition(CurrentPositionRef ref) async {
  Location location = Location();
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      throw Exception("Location service not enabled");
    }
  }

  PermissionStatus permissionStatus = await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      throw Exception("Location permission not granted");
    }
  }
  final LocationData locationData = await location.getLocation();
  if (locationData.latitude == null || locationData.longitude == null) {
    throw Exception("Location not found");
  } else {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }
}
