import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/map_data.dart';

class CustomMap extends StatefulWidget {
  final LatLng? center;
  final MapData? mapData;
  final MapController? mapController;
  const CustomMap({super.key, this.center, this.mapData, this.mapController})
      : assert(mapData != null || center != null,
            "Either center or mapData must be provided");

  const CustomMap.fromMapData(MapData this.mapData,
      {super.key, this.mapController})
      : center = null;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  static const double _initialZoom = 13.0;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter:
            widget.center ?? widget.mapData!.center ?? const LatLng(0, 0),
        initialZoom: _initialZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tileProvider: CancellableNetworkTileProvider(),
          userAgentPackageName: 'it.polimi.dima',
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
        if (widget.mapData != null && widget.mapData!.markers.isNotEmpty)
          MarkerLayer(markers: widget.mapData!.markers),
      ],
    );
  }
}
