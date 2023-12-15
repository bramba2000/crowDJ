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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600 /* && usertype==DJ*/) {
            return _desktopDjPage(widget.args);
          } else {
            return _mobileUserPage(songs);
          }
        },
      ),
    );
  }

  Padding _mobileUserPage(List<Song> songs) {
    return Padding(
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
              flex: 1, child: Text("max people: ${widget.args.maxPeople}")),
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
    );
  }

  Widget _desktopDjPage(Event e) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(widget.args.title),
                  Text("max people: ${widget.args.maxPeople}"),
                  _songListContainer(e),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: _showImage(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _showPlayer(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songListContainer(Event e) {
    return Container(
      color:const  Color.fromARGB(198, 97, 165, 221),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            for (Song s in e.songs)
              Container(
                color:const Color.fromARGB(197, 129, 184, 230),
                margin:const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("${s.artist} - ${s.title} "),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _showImage(){

    return SizedBox();

  }

  Widget _showPlayer(){

    return SizedBox();

  }
}


/*
The following assertion was thrown while applying parent data.:
Incorrect use of ParentDataWidget.
The ParentDataWidget Expanded(flex: 1) wants to apply ParentData of type FlexParentData to a
RenderObject, which has been set up to accept ParentData of incompatible type BoxParentData.
Usually, this means that the Expanded widget has the wrong ancestor RenderObjectWidget. Typically,
Expanded widgets are placed directly inside Flex widgets.
The offending Expanded is currently placed inside a Padding widget.
The ownership chain for the RenderObject that received the incompatible parent data was:
  Row ← Expanded ← Container ← Padding ← LayoutBuilder ← KeyedSubtree-[GlobalKey#1f3f1] ←
_BodyBuilder ← MediaQuery ← LayoutId-[<_ScaffoldSlot.body>] ← CustomMultiChildLayout ← ⋯

*/
