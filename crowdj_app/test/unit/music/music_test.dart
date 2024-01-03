import 'package:crowdj/core/env/env.dart';
import 'package:crowdj/feature/music/data/music_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/spotify.dart';

void main() {
  late final MusicDataSource dataSource;

  setUp(() {
    dataSource = MusicDataSource.fromCredentials(
        Env.spotifyClientId, Env.spotifyClientSecret);
  });

  test(
      'Get track 11dFghVXANMlKmJXsNCbNl should return "Cut To The Feeling" track',
      () async {
    final result = await dataSource.getTrack('11dFghVXANMlKmJXsNCbNl');
    expect(result, isA<Track>());
    expect(result.name, 'Cut To The Feeling');
    expect(result.artists?.first.name, 'Carly Rae Jepsen');
  });
}
