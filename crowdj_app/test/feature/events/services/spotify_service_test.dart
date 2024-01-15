import 'package:crowdj/feature/events/services/spotify_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/spotify.dart';

void main() {
  group('Music data source integrates spotify web api -', () {
    late SpotifyService dataSource;

    setUp(() {
      dataSource = SpotifyService.fromEnvironment();
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
}
