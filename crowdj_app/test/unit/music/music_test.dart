import 'package:crowdj/core/env/env.dart';
import 'package:crowdj/feature/music/data/music_data_source.dart';
import 'package:crowdj/feature/music/model/track_metadata.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/spotify.dart';

void main() {
  group('TrackMetadata serialization -', () {
    const trackMetadata = TrackMetadata(
      id: '11dFghVXANMlKmJXsNCbNl',
      name: 'Cut To The Feeling',
      artist: 'Carly Rae Jepsen',
      album: 'Cut To The Feeling',
      imageUrl:
          'https://i.scdn.co/image/ab67616d0000b273e8f0b6b9a9a3a7b0b9b9b9b9',
      proposedBy: 'user1',
      played: false,
      voters: ['user1', 'user2'],
    );

    test('should correctly serialize to JSON', () {
      final json = trackMetadata.toJson();
      expect(json["id"], trackMetadata.id);
      expect(json["name"], trackMetadata.name);
      expect(json["artist"], trackMetadata.artist);
      expect(json["album"], trackMetadata.album);
      expect(json["imageUrl"], trackMetadata.imageUrl);
      expect(json["proposedBy"], trackMetadata.proposedBy);
      expect(json["played"], trackMetadata.played);
      expect(json["voters"], trackMetadata.voters);
    });

    test('should correctly deserialize from JSON when all field are provided',
        () {
      // Add your JSON string here
      final json = {
        "id": "11dFghVXANMlKmJXsNCbNl",
        "name": "Cut To The Feeling",
        "artist": "Carly Rae Jepsen",
        "album": "Cut To The Feeling",
        "imageUrl":
            "https://i.scdn.co/image/ab67616d0000b273e8f0b6b9a9a3a7b0b9b9b9b9",
        "proposedBy": "user1",
        "played": false,
        "voters": ["user1", "user2"]
      };
      final result = TrackMetadata.fromJson(json);
      expect(result, trackMetadata);
    });

    test(
        'should correctly deserialize from JSON when only required field are provided',
        () {
      final json = {
        "id": "11dFghVXANMlKmJXsNCbNl",
        "name": "Cut To The Feeling",
        "artist": "Carly Rae Jepsen",
        "album": "Cut To The Feeling",
        "imageUrl":
            "https://i.scdn.co/image/ab67616d0000b273e8f0b6b9a9a3a7b0b9b9b9b9",
      };
      final result = TrackMetadata.fromJson(json);
      expect(result.name, trackMetadata.name);
      expect(result.artist, trackMetadata.artist);
      expect(result.album, trackMetadata.album);
      expect(result.imageUrl, trackMetadata.imageUrl);
      expect(result.proposedBy, isNull);
      expect(result.played, isFalse);
      expect(result.voters, isEmpty);
    });
  });

  group('Music data source integrates spotify web api -', () {
    late MusicDataSource dataSource;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = MusicDataSource.fromCredentials(
          Env.spotifyClientId, Env.spotifyClientSecret, firestore);
    });

    test(
        'Get track 11dFghVXANMlKmJXsNCbNl should return "Cut To The Feeling" track',
        () async {
      final result = await dataSource.getTrack('11dFghVXANMlKmJXsNCbNl');
      expect(result, isA<Track>());
      expect(result.name, 'Cut To The Feeling');
      expect(result.artists?.first.name, 'Carly Rae Jepsen');
    });

    test('Get track with invalid id should throw an exception', () async {
      expect(() async => await dataSource.getTrack('invalid_id'),
          throwsA(isA<Exception>()));
    });

    test('Get track with empty id should throw an exception', () async {
      expect(
          () async => await dataSource.getTrack(''), throwsA(isA<Exception>()));
    });

    test('Look for track "Cut To The Feeling" should return a of track',
        () async {
      final result = await dataSource.searchTrack('Cut To The Feeling');
      expect(result, isNotNull);
      expect(result, isA<Track>());
      expect(result!.name, 'Cut To The Feeling');
      expect(result.artists?.first.name, 'Carly Rae Jepsen');
    });

    test('Look for tracks "Cut To The Feeling" should return a list of tracks',
        () async {
      final result = await dataSource.searchTracks('Cut To The Feeling');
      expect(result, isNotNull);
      expect(result, isA<List<Track>>());
      expect(result!.first.name, 'Cut To The Feeling');
      expect(result.first.artists?.first.name, 'Carly Rae Jepsen');
    });
  });

  group('Music data source handle metatracks with Firestore -', () {
    late MusicDataSource dataSource;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = MusicDataSource.fromCredentials(
          Env.spotifyClientId, Env.spotifyClientSecret, firestore);
    });

    test('Save track metadata should save the track metadata', () async {
      final track = await dataSource.getTrack('11dFghVXANMlKmJXsNCbNl');
      await dataSource.saveTrackMetadata('eventId', track);
      final result = (await firestore
              .collection('events')
              .doc('eventId')
              .collection('tracks')
              .doc('11dFghVXANMlKmJXsNCbNl')
              .get())
          .data();
      print(firestore.dump());
      expect(result, isNotNull);
      result!;
      expect(result["name"], 'Cut To The Feeling');
      expect(result["artist"], 'Carly Rae Jepsen');
    });
  });
}
