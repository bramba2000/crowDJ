import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/router.dart';
import '../widgets/event_form.dart';

class NewEventPage extends ConsumerWidget {
  const NewEventPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a New Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EventForm(
          onEventSubmitted: () => ref.read(routerProvider).pop(),
        ),
      ),
    );
  }
}
