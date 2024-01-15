import 'package:crowdj/feature/events/models/track_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
