import 'package:flutter/material.dart';

import '../widgets/event_form.dart';

class NewEventPage extends StatelessWidget {
  const NewEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a New Event")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: EventForm(),
      ),
    );
  }
}
