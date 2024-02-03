import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../events/models/event_model.dart';
import '../../events/services/event_service.dart';
import '../models/map_data.dart';
import '../providers/current_event.dart';
import '../providers/position.dart';
import '../utils/coordinates_converter.dart';

class UserMap extends ConsumerStatefulWidget {
  final LatLng initialPosition;
  const UserMap({required this.initialPosition, super.key});

  @override
  ConsumerState<UserMap> createState() => _UserMapState();
}

class _UserMapState extends ConsumerState<UserMap> {
  final MapController _mapController = MapController();
  bool waitPosition = true;
  late Stream<List<Event>> _eventStream;
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventStream = _eventService.getEventsWithinRadius(
        toGeoPoint(widget.initialPosition), 3);
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd ||
          event is MapEventDoubleTapZoomEnd ||
          event is MapEventScrollWheelZoom) {
        setState(() {
          _eventStream = _eventService.getEventsWithinRadius(
              toGeoPoint(event.camera.center),
              radiusFromBounds(event.camera.visibleBounds));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentPositionProvider).isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: ref.read(currentPositionProvider).asData!.value,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: CancellableNetworkTileProvider(),
              userAgentPackageName: 'it.polimi.dima'),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
          StreamBuilder<Object>(
              stream: _eventStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final events = snapshot.data as List<Event>;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ref
                        .read(currentEventsProvider.notifier)
                        .changeEvents(events);
                  });
                  return MarkerLayer(
                      markers: events
                          .map((e) => MapData.createMarker(e, false))
                          .toList());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text("No events found"));
                }
              }),
        ]);
  }
}
