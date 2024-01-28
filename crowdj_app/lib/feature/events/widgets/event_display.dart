import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event_model.dart';

/// Display the details of an [Event].
///
/// This widget is used to display the details of an [Event] in the [EventDetailsScreen].
class EventDisplay extends StatelessWidget {
  final Event event;
  final DateFormat _dateFormat = DateFormat.yMd().add_jm();

  EventDisplay({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10,),
          Text(event.description),
          Text(_dateFormat.format(event.startTime)),
          Text(event.genre),
        ],
      ),
    );
  }
}
