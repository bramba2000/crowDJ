import "Song.dart";

class Event{
    
    int eventID;
    String title;
    int maxPeople;
    List<Song> songs;
    String genere;
    String state;

    Event({
      required this.eventID,
      required this.title,
      required this.maxPeople,
      required this.songs,
      required this.genere,
      this.state="past",
    });

}