import 'package:geoflutterfire2/geoflutterfire2.dart';

class LocationHelper {
  static Map<String, dynamic> toJson(GeoFirePoint? point) {
    return point?.data;
  }

  static GeoFirePoint fromJson(Map<String, dynamic> data) {
    return GeoFirePoint(data['geopoint'].latitude, data['geopoint'].longitude);
  }
}
