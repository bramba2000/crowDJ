import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/env/env.dart';

final String endpoint = "https://api.geoapify.com/v1/geocode/search";

fromAddrToCoord(String addr) async {
  if (addr == "") {
    return [];
  }

  //https://api.geoapify.com/v1/geocode/search?text=38%20Upper%20Montagu%20Street%2C%20Westminster%20W1H%201LJ%2C%20United%20Kingdom&apiKey=889b9139bce84f2f9205fdde6846d83f
  var response = await http
      .get(Uri.parse("$endpoint?text=$addr&apiKey=${Env.geoAPIToken}"));
  //print(Uri.parse(endpoint+"?text="+addr+"&apiKey="+api));

  return jsonDecode(response.body);
}

GeoPoint getGeoPointFromJson(Map<String, dynamic>? response) {
  if (response == null) return const GeoPoint(0, 0);

  return GeoPoint(response["features"][0]["geometry"]["coordinates"][1],
      response["features"][0]["geometry"]["coordinates"][0]);
}
