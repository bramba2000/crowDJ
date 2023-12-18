import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

import 'MapModel.dart';


class DynMap extends StatefulWidget {

  final MapModel mapModel;
  const DynMap({Key? key, required this.mapModel}):super(key:key);

  @override
  State<DynMap> createState() => _MapState();
}

class _MapState extends State<DynMap> {

  @override
  Widget build(BuildContext context) {


    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(widget.mapModel.getCenter().latitude, widget.mapModel.getCenter().longitude),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        MarkerLayer(markers: widget.mapModel.getMarkers()),
      ],
    );
  }

  
}
