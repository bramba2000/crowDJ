import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../services/event_service.dart';

class privateInviteForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _privateEventFormState();
}

class _privateEventFormState extends ConsumerState<privateInviteForm> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final EventService _eventService = EventService();
    String _message = "";

    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: _message == ""
                  ? "Enter the invitation code"
                  : _message,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ElevatedButton(
              onPressed: () async {
                //calling the invitation method

                //bool res = await _eventService.joinPrivateEvent()
                bool res = false;
                if (!res) {
                  setState(() {
                    _message =" Ops... something went wrong" ;
                    _textController.text="";
                  });
                } else {
                  context.replace("/");
                }   
              },
              child: const Text("join"),
                  
            ),
          ),
        ],
      ),
    );
  }
}
