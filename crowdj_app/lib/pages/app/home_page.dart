import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/router/utils/EventExtra.dart';
import '../../feature/auth/providers/utils_auth_provider.dart';
import '../../feature/events/models/event_model.dart';
import '../../feature/events/widgets/event_display.dart';
import '../../feature/auth/models/user_props.dart';
import '../../feature/mapHandler/providers/current_event.dart';
import '../../feature/mapHandler/providers/position.dart';
import '../../feature/mapHandler/widgets/user_map.dart';
import '../../feature/mapHandler/models/map_data.dart';
import '../../feature/mapHandler/widgets/dynamic_map.dart';
import 'utils/appBar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final UserProps _userProps = ref.read(userPropsProvider)!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    return Scaffold(
      appBar: CustomAppBar(
        text: "Home page",
      ),
      body: (_userProps.userType == UserType.dj)
          ? _desktopDjPage()
          : _mobileUserPage(),
    );
  }

  Widget _desktopDjPage() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go("/newEvent");
                    },
                    child: const Text("create new event"),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "TITLE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "PLACE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: _DjEventsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileUserPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const _UserEventsList(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "NEARBY EVENTS",
            style: TextStyle(
              fontSize: 20,
              //color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
              child: FutureBuilder<LatLng>(
                  future: ref.read(currentPositionProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("error occurs while loading the map");
                      } else {
                        return UserMap(
                          initialPosition: snapshot.data!,
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget elevatedBox(Event e, Color color) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(children: [
          Text(
            e.title,
            style: const TextStyle(
              //color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            "${e.maxPeople}",
            style: const TextStyle(
              //color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 10),
    ]);
  }
}

class _UserEventsList extends ConsumerWidget {
  const _UserEventsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myEvents = ref.watch(eventsOfUserProvider);
    return switch (myEvents) {
      AsyncData(value: final events) => Column(children: [
          const Text(
            "MY EVENTS",
            style: TextStyle(
              fontSize: 20,
              //color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          events.isEmpty
              ? const Text("you didn't subscribe to any event")
              : _eventList(context, events),
        ]),
      AsyncError _ => const SizedBox(
          height: 100,
          width: 100,
          child: Text("error occurs while loading the info"),
        ),
      _ => const CircularProgressIndicator(),
    };
  }

  Widget _eventList(BuildContext context, List<Event?> myEvents) {
    //print(_myEvents.toString());
    return Column(
      children: [
        for (Event? event in myEvents)
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go("/event/${event.id}",
                        extra: EventExtra(event: event, sub: true));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Set border radius to 0 for a square button
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    event!.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class _DjEventsList extends ConsumerWidget {
  const _DjEventsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdEvents = ref.watch(createdEventsProvider);

    return switch (createdEvents) {
      AsyncData(value: final events) => ListView.builder(
          itemCount: events.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              //color: const Color.fromARGB(199, 64, 150, 221),
              child: _djEventWrap(context, events[index]),
            );
          },
        ),
      AsyncError _ => const SizedBox(
          height: 100,
          width: 100,
          child: Text("error occurs while loading the info"),
        ),
      _ => const CircularProgressIndicator(),
    };
  }

  /// Return a wrap widget that contains the event details and the map of
  /// the event
  Widget _djEventWrap(BuildContext context, Event e) {
    final double maxHeigth = max(MediaQuery.of(context).size.height * 0.4, 400);

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: maxHeigth),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EventDisplay(event: e),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go("/event/${e.id}",
                            extra: EventExtra(event: e, sub: true));
                      },
                      child: const Text("manage the event"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 600, maxHeight: maxHeigth),
          child: DynamicMap(
            enableMovement: false,
            mapData: MapData.fromSingleEvent(e),
          ),
        )
      ],
    );
  }
}
