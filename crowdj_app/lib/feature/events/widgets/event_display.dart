import 'package:flutter/material.dart';

import '../models/event_model.dart';

/// Display the details of an [Event].
///
/// This widget is used to display the details of an [Event] in the [EventDetailsScreen].
class EventDisplay extends StatelessWidget {
  final Event event;

  const EventDisplay({required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(event.description),
          Text(event.startTime.toString()),
          Text(event.genre),
        ],
      ),
    );
  }
}
