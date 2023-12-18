
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String endpoint = "https://api.geoapify.com/v1/geocode/search";
final String api = "889b9139bce84f2f9205fdde6846d83f";

fromAddrToCoord(String addr) async {

  if (addr == "") {
    return [];
  }

  //https://api.geoapify.com/v1/geocode/search?text=38%20Upper%20Montagu%20Street%2C%20Westminster%20W1H%201LJ%2C%20United%20Kingdom&apiKey=889b9139bce84f2f9205fdde6846d83f
  var response = await http.get(Uri.parse(endpoint+"?text="+addr+"&apiKey="+api));
  print(Uri.parse(endpoint+"?text="+addr+"&apiKey="+api));

  return jsonDecode(response.body);

}

getGeoPointFromJson(var response){

  if(response == null || response==null) return GeoPoint(0, 0);

  return GeoPoint(
    response["features"][0]["geometry"]["coordinates"][0], 
    response["features"][0]["geometry"]["coordinates"][1]);

}

