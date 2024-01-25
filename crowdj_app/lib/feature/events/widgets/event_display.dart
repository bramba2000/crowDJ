import 'package:flutter/material.dart';

import '../models/event_model.dart';

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
