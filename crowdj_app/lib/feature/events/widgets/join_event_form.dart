import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/utils_auth_provider.dart';
import '../../mapHandler/providers/current_event.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class JoinEventForm extends ConsumerStatefulWidget {
  final Event event;

  const JoinEventForm({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinEventFormState();
}

class _JoinEventFormState extends ConsumerState<JoinEventForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final EventService _eventService = EventService();
  late final String _userId = ref.read(userIdProvider)!;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
            child: Text(
                "Do youn want to join this event? Click the button below!")),
        const SizedBox(height: 10),
        if (widget.event is PrivateEvent) ...[
          const Center(
              child: Text(
                  "This is a private event, to join it you need to insert the private code below or directly click the link in the invitation")),
          const SizedBox(height: 10),
        ],
        Form(
          key: _form,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.event is PrivateEvent)
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: "Enter the event private code",
                    ),
                    validator: (value) =>
                        value == (widget.event as PrivateEvent).password
                            ? null
                            : "The code is not correct",
                  ),
                ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () async {
                    final validation = _form.currentState!.validate() ||
                        widget.event is PublicEvent;
                    if (validation) {
                      await _eventService.addParticipant(
                          widget.event.id, _userId,
                          password: _textController.text);
                      _form.currentState!.reset();
                      ref.invalidate(eventsOfUserProvider);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        GoRouter.of(context).go("/");
                      });
                    }
                  },
                  child: const Text("Join!"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
