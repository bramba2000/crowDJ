import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../events/data/events_data_source.dart';
import '../events/models/event_model.dart';
import 'DynMap.dart';
import 'MapModel.dart';

class UserMap extends StatefulWidget {
  final List<Event?> myEvents;
  final EventDataSource eventDataSource;

  const UserMap(
      {super.key, required this.myEvents, required this.eventDataSource});

  @override
  State<StatefulWidget> createState() => _UserMapState();
}

class _UserMapState extends State<UserMap> {
  ///---->map<----
  ///
  final MapController _mapController = MapController();
  late MapModel _mapModel;
  late DynMap _map;
  double _zoom = 17.0;
  double _radius = 5;

  ///---->events<----
  ///
  late List<Event> _nearEvents = [];

  Future<void> _loadNearEvents() async {
    try {
      widget.eventDataSource
          .getEventsWithinRadius(await MapModel.getCurrentLocation(), _radius)
          .listen((list) {
        // Handle each list as it arrives
        _nearEvents = list;
      });
    } on Exception catch (e) {
      print(" error!!!!!!!!!!! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadNearEvents(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const SizedBox(
                height: 100,
                width: 100,
                child: Text("error occurs while loading the map"),
              );
            } else {
              return Container(
                child: Column(
                  children: [
                    _userMap(),
                    const SizedBox(
                      height: 20,
                    ),
                    _nearEventSlider(MediaQuery.of(context).size.width),
                  ],
                ),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                width: 100,
                child: Text(
                  "----------------- error: ${snapshot.error.toString()}",
                ),
              );
            } else {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("loading ..."),
                  ],
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _userMap() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color.fromARGB(255, 60, 158, 238),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<void>(
        future: _builUserMap(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const SizedBox(
                height: 100,
                width: 100,
                child: Text("error occurs while loading the map"),
              );
            } else {
              print("----------------- no snapshot errors, returning the map");
              return Container(padding: const EdgeInsets.all(8), child: _map);
            }
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 100,
                width: 100,
                child: Text(
                    "----------------- error:${snapshot.error}"),
              );
            } else {
              return const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    semanticsLabel: "Loading ... ",
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _builUserMap() async {
    try {
      _mapModel = await MapModel.createEventsMap(
          _nearEvents, widget.myEvents, context); //createEventsMap()
      _mapModel.addYourCurrentPlace(_mapModel.getCenter());
      _map = DynMap(
        mapModel: _mapModel,
        center: _mapModel.getCenter(),
        mapController: _mapController,
        zoom: _zoom,
      );
      //print("Map has been built");
      //return _map;
    } catch (e) {
      print(e.toString());
      //return _map;
    }
  }

  Widget _nearEventSlider(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _radius,
            min: 1,
            max: 100,
            label: "$_radius km ",
            divisions: 100,
            onChanged: (value) {
              setState(() {
                _radius = value;
                _zoom = _mapModel.calculateZoomLevel(_radius, screenWidth);
                _mapController.move(_mapModel.getCenterLatLng(), _zoom);
              });
            },
          ),
        ),
        Text("${_radius.truncate()}"),
      ],
    );
  }
}
