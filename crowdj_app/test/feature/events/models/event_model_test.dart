import 'package:crowdj/feature/events/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

void main() {
  group('Serialization and deserialization tests', () {
    test('Event model should be deserialized to the correct type', () {
      final Event event = Event.fromJson({
        'id': 'id',
        'title': 'title',
        'description': 'description',
        'maxPeople': 10,
        'location': GeoFirePoint(0, 0).data,
        'startTime': DateTime.now().toString(),
        'creatorId': 'creatorId',
        'genre': 'genre',
        'accessibility': 'public',
        'status': 'upcoming',
      });

      expect(event, isA<PublicEvent>());

      final Event event2 = Event.fromJson({
        'id': 'id',
        'title': 'title',
        'description': 'description',
        'maxPeople': 10,
        'location': GeoFirePoint(0, 0).data,
        'startTime': DateTime.now().toString(),
        'creatorId': 'creatorId',
        'genre': 'genre',
        'accessibility': 'private',
        'status': 'upcoming',
        'password': 'password',
      });

      expect(event2, isA<PrivateEvent>());
    });
  });
}
