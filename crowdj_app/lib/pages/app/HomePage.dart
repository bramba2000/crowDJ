import 'package:crowdj/utils/Event.dart';
import 'package:crowdj/utils/Song.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> get_events() {
    List<Event> events = [
      Event(eventID: 1, title: "festa della salamella", maxPeople: 200, songs: [
        Song(songID: 11, artist: "Bello figo", title: "pasta con tonno"),
        Song(songID: 12, artist: "Rovere", title: "affogare")
      ]),
      Event(eventID: 2, title: "boom festival", maxPeople: 15000, songs: [
        Song(songID: 21, artist: "k", title: "psy and fly"),
        Song(songID: 22, artist: "matrix", title: "drop it")
      ])
    ];

    return events;
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            yourEvents(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "NEARBY EVENTS",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            map(screenWidth, screenHeight),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "YOUR INVITATIONS",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            invitationsList(),
          ],
        ),
      ),
    );
  }

  Widget yourEvents() {
    return Container(
      child: Column(children: [
        const Text(
          "YOUR EVENTS",
          style: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        eventList(),
      ]),
    );
  }

  Widget eventList() {
    List<Event> events = get_events();

    return Container(
      child: Column(
      children: [
        for (var event in events)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go("/homePage/EventPage",);            
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set border radius to 0 for a square button
                  ),
                  backgroundColor:const Color.fromARGB(255, 60, 158, 238),
                ),
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 30,
        ),
      ],
    ));
  }

  Widget elevatedBox(Event e, Color color) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(children: [
          Text(
            e.title,
            style: const TextStyle(
              color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            "${e.maxPeople}",
            style: const TextStyle(
              color: Color.fromARGB(255, 47, 35, 150),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 10),
    ]);
  }

  Widget map(screenWidth, screenHeight) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Color.fromARGB(255, 60, 158, 238),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.5,
          child: const Text("put the map here"),
        ));
  }

  Widget invitationsList() {
    List<Event> events = get_events();

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            events.length,
            (index) => Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              color: Colors.blue,
              child: Row(
                children: [
                  elevatedBox(events[index], Color.fromARGB(255, 99, 136, 235)),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                      onPressed: () => print("accettato"),
                      child: const Text("accept")),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                      onPressed: () => print("declinato"),
                      child: const Text("decline")),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    /*
      child: Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                elevatedBox(events[index], Color.fromARGB(255, 99, 136, 235)),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                    onPressed: () => print("accettato"), child: Text("accept")),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                    onPressed: () => print("declinato"),
                    child: Text("decline")),
              ],
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ],*/
  }
}
