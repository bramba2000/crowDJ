import 'package:crowdj/feature/events/data/music_data_source.dart';
import 'package:crowdj/feature/events/models/track_metadata.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/spotify.dart';

void main() {
  group('Music data source handle metatracks with Firestore -', () {
    late MusicDataSource dataSource;
    late FakeFirebaseFirestore firestore;
    late Track track = Track.fromJson({
      "id": "11dFghVXANMlKmJXsNCbNl",
      "name": "Cut To The Feeling",
      "artists": [
        {"name": "Carly Rae Jepsen"}
      ],
      "album": {
        "name": "Cut To The Feeling",
        "images": [
          {
            "url":
                "https://i.scdn.co/image/ab67616d0000b273e8f0b6b9a9a3a7b0b9b9b9b9"
          }
        ]
      },
    });

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = MusicDataSource(firestore: firestore);
    });

    test(
        'Get TracksMetadata should retrieve correctly all the tracks for an event',
        () async {
      await firestore.collection('events').doc('eventId').set({
        'name': 'Event name',
        'description': 'Event description',
        'owner': 'user1',
      });
      await firestore
          .collection('events')
          .doc('eventId')
          .collection('tracks')
          .add({
        "id": "11dFghVXANMlKmJXsNCbNl",
        "name": "Cut To The Feeling",
        "artist": "Carly Rae Jepsen",
        "album": "Cut To The Feeling",
        "imageUrl":
            "https://i.scdn.co/image/ab67616d0000b273e8f0b6b9a9a3a7b0b9b9b9b9",
        "proposedBy": "user1",
        "played": false,
        "voters": ["user1", "user2"]
      });
      final result = await dataSource.getTracksMetadata('eventId');
      expect(result, isNotNull);
      expect(result, isA<List<TrackMetadata>>());
      expect(result.first.name, 'Cut To The Feeling');
      expect(result.first.artist, 'Carly Rae Jepsen');
    });

    test('Save track metadata should save the track metadata', () async {
      await dataSource.saveTrackMetadata('eventId', track);
      final result = (await firestore
              .collection('events')
              .doc('eventId')
              .collection('tracks')
              .doc('11dFghVXANMlKmJXsNCbNl')
              .get())
          .data();
      expect(result, isNotNull);
      result!;
      expect(result["name"], 'Cut To The Feeling');
      expect(result["artist"], 'Carly Rae Jepsen');
    });

    test('Mark track as played should update the track metadata', () async {
      await dataSource.saveTrackMetadata('eventId', track);
      await dataSource.markTrackAsPlayed('eventId', '11dFghVXANMlKmJXsNCbNl');
      final result = (await firestore
              .collection('events')
              .doc('eventId')
              .collection('tracks')
              .doc('11dFghVXANMlKmJXsNCbNl')
              .get())
          .data();
      expect(result, isNotNull);
      result!;
      expect(result["played"], true);
    });

    test('Vote track should update the track metadata', () async {
      await dataSource.saveTrackMetadata('eventId', track);
      await dataSource.voteTrack('eventId', '11dFghVXANMlKmJXsNCbNl', 'user1');
      final result = (await firestore
              .collection('events')
              .doc('eventId')
              .collection('tracks')
              .doc('11dFghVXANMlKmJXsNCbNl')
              .get())
          .data();
      expect(result, isNotNull);
      result!;
      expect(result["voters"], ['user1']);
    });
  });
}
