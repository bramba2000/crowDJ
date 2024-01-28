import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import '../../events/models/event_model.dart';

part 'map_data.freezed.dart';

@freezed

/// Represent the data needed to display a map
///
/// It can be created from a list of events or from a single event. Consider
/// [MapData.fromCenter] to create a model without any marker. Otherwise,
/// [MapData.fromEvents] is the way to go. It will create a model for a map with
/// markers for each event and optionally for each subscribed event. If no
/// center is provided, the first marker will be used as center.
///
/// The [MapData.fromSingleEvent] constructor is used to create a model with a
/// single marker for a single event. Usefull to display the location of an
/// event.
class MapData with _$MapData {
  static const double _defaultMarkerSize = 40;
  static const double _defaultIconSize = 30;

  const factory MapData({
    required List<Marker> markers,
    required LatLng? center,
  }) = _MapData;

  /// Create a model with a [Icons.my_location] marker centered on [center]
  factory MapData.fromCenter(LatLng center) =>
      MapData(markers: [_createCenterMarker(center)], center: center);

  factory MapData._fromMarkers(List<Marker> markers) =>
      MapData(markers: markers, center: markers.firstOrNull?.point);

  /// Create a model with a single marker for a single event, the location of
  /// the event is used as center
  factory MapData.fromSingleEvent(Event event) => MapData._fromMarkers([
        Marker(
          width: _defaultMarkerSize,
          height: _defaultMarkerSize,
          point: LatLng(event.location.latitude, event.location.longitude),
          child: IconButton(
            icon: const Icon(Icons.location_on),
            color: Colors.red,
            iconSize: _defaultIconSize,
            onPressed: () {},
          ),
        )
      ]);

  /// Create a model with markers for each event and optionally for each
  /// subscribed event.
  ///
  /// If no center is provided, the first marker will be used as center.
  factory MapData.fromEvents(
      {required List<Event> events,
      List<Event>? subscribedEvents,
      LatLng? center}) {
    final markers = events.map((e) => _createMarker(e, false)).toList();
    if (subscribedEvents != null) {
      markers.addAll(subscribedEvents.map(((e) => _createMarker(e, true))));
    }
    if (center != null) {
      markers.add(_createCenterMarker(center));
      return MapData(markers: markers, center: center);
    }
    return MapData._fromMarkers(markers);
  }

  static Marker _createMarker(Event e, bool isSubscribed) => Marker(
        width: _defaultMarkerSize,
        height: _defaultMarkerSize,
        point: LatLng(e.location.latitude, e.location.longitude),
        child: IconButton(
          icon: const Icon(Icons.location_on),
          color: isSubscribed ? Colors.green : Colors.red,
          iconSize: _defaultIconSize,
          onPressed: () {},
        ),
      );

  static Marker _createCenterMarker(LatLng position) => Marker(
      width: _defaultMarkerSize,
      height: _defaultMarkerSize,
      point: position,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: _defaultIconSize,
      ));
}
