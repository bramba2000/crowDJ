import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget to get the information about an address.
///
/// The widget is composed by a text field and a map. The user can insert an
/// address in the text field and the map will show the position of the address.
/// The map is visible only if the user insert an address or an [initialPosition]
/// is provided. The [onPositionChanged] callback is called when the corrent
class AddressFormField extends StatefulWidget {
  final LatLng? initialPosition;
  final void Function(LatLng)? onPositionChanged;

  const AddressFormField(
      {super.key, this.initialPosition, this.onPositionChanged});

  @override
  State<AddressFormField> createState() => _AddressFormFieldState();
}

class _AddressFormFieldState extends State<AddressFormField> {
  static const double _initialZoom = 13.0;
  static const String _endpoint = "https://api.geoapify.com/v1/geocode/search";
  static const String _api = "889b9139bce84f2f9205fdde6846d83f";

  late bool _isMapVisible = widget.initialPosition != null;
  late LatLng _currentPosition = widget.initialPosition ?? LatLng(0, 0);
  final MapController _mapController = MapController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        /// Address field
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an address';
              }
              return null;
            },
            onEditingComplete: () async {
              final point = await _reverseAddress();
              if (!_isMapVisible) {
                setState(() {
                  _currentPosition = LatLng(point.latitude, point.longitude);
                  _isMapVisible = true;
                });
              } else {
                setState(() {
                  _currentPosition = LatLng(point.latitude, point.longitude);
                });
                _mapController.move(
                    _currentPosition, _mapController.camera.zoom);
              }
              if (widget.onPositionChanged != null) {
                widget.onPositionChanged!(
                    LatLng(point.latitude, point.longitude));
              }
            },
          ),
        ),
        if (_isMapVisible) ...[
          const SizedBox(width: 20, height: 10),
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: _initialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'it.polimi.dima',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]
      ],
    );
  }

  Future<GeoPoint> _reverseAddress() async {
    final address = _addressController.text;
    final parse = Uri.parse("$_endpoint?text=$address&apiKey=$_api");
    final response = await http.get(parse);
    final json = jsonDecode(response.body);
    return _geoPointFromJson(json);
  }

  GeoPoint _geoPointFromJson(Map<String, dynamic>? response) {
    if (response == null) throw Exception("No response");

    return GeoPoint(response["features"][0]["geometry"]["coordinates"][1],
        response["features"][0]["geometry"]["coordinates"][0]);
  }
}
