import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  // _EventPageState createState() => _EventPageState();
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("EVENT PAGE")),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("titolone"),
                Text("immagine/mappa"),
              ],
            ),
          ]),
        ));
  }
}
