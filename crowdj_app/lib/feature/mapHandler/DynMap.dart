
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MapModel.dart';

// ------------------------>> guardati MapController <<-------------------

class DynMap extends StatefulWidget {

  final MapModel mapModel;
  final GeoPoint center;
  final MapController mapController;
  

  DynMap({Key? key, 
    required this.mapModel, 
    required this.center,
    required this.mapController}): super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<DynMap> {

  @override
  Widget build(BuildContext context) {
    /*
    print(" PRINTING THE MAP");
    print("center lat:" +
        widget.center.latitude.toString() +
        " lng: " +
        widget.center.longitude.toString());
    */

    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.center.latitude, widget.center.longitude),
        initialZoom: 17.0,
        onMapReady: () {
          widget.mapController.mapEventStream.listen((evt) {});
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'unknown',
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
