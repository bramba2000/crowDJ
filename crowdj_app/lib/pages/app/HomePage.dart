import 'package:crowdj/utils/Event.dart';
import 'package:crowdj/utils/Song.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  _HomePageState createState()=>_HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Event> get_events(){

    List<Event> events=[
      Event(eventID: 1, 
            title: "festa della salamella", 
            maxPeople: 200, 
            songs: [Song(songID: 11, artist: "Bello figo", title: "pasta con tonno"),
                    Song(songID: 12, artist: "Rovere", title: "affogare")
                    ]
      ),
      Event(eventID: 2, 
            title: "boom festival", 
            maxPeople: 15000, 
            songs: [Song(songID: 21, artist: "k", title: "psy and fly"),
                    Song(songID: 22, artist: "matrix", title: "drop it")
                    ]
      )
    ];

    return events;
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            const Text(
              "YOUR EVENTS",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30,),
            eventList(),
          ],
        ),
      ),
    );
  }


  Widget eventList() {

    List<Event> events=get_events();

    return Container(
      child: Column(
        children: [
          for (var event in events)
            Row(
              children:[
                Column( children: [ Text("${event.title}"), ], ),
                const SizedBox(width: 30,),
                Column( children: [ Text("${event.maxPeople}"), ], ),
              ]
            )
        ],
      )   
    );
  }
}