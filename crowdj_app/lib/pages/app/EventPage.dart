import 'package:crowdj/utils/Event.dart';
import 'package:crowdj/utils/Song.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  final Event args;

  const EventPage({Key? key, required this.args}) : super(key: key);

  @override
  // _EventPageState createState() => _EventPageState();
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    List<Song> songs = widget.args.songs;

    return Scaffold(
        appBar: AppBar(title: const Text("EVENT PAGE")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.args.title),
                  ],
                ),
              ),
              Expanded(
                flex:1,
                child: Text(
                  "max people: ${widget.args.maxPeople}"
                )
              ),
              Expanded(
                child: Column(
                  children: [
                    for (Song s in songs)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(s.title),
                          Text(s.artist),
                          Text("${s.songID}")
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
