import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdj/feature/events/data/events_data_source.dart';
import 'package:crowdj/feature/events/models/event_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

void main() {
  group('Event data source tests', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('Event should be created correctly', () async {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      dataSource.createEvent(
        title: 'title',
        description: 'description',
        maxPeople: 10,
        location: const GeoPoint(0, 0),
        startTime: DateTime.now(),
        creatorId: 'creatorId',
        genre: 'genre',
      );

      expect((await fakeFirestore.collection('events').count().get()).count, 1);
      final Map<String, dynamic> event = (await fakeFirestore
              .collection('events')
              .where('title', isEqualTo: 'title')
              .get())
          .docs
          .first
          .data();
      expect(event['description'], 'description');
      expect(event['maxPeople'], 10);
      expect(event['location'], GeoFirePoint(0, 0).data);
      expect(event['startTime'], isA<String>());
      expect(event['creatorId'], 'creatorId');
      expect(event['genre'], 'genre');
      expect(event['accessibility'], 'public');
      expect(event['status'], 'upcoming');
    });

    test('Event should be retrieve correctly', () {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      fakeFirestore.collection('events').doc('id').set({
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

      dataSource.getEvent('id').then((Event? event) {
        expect(event, isNotNull);
        event = event!;
        expect(event, isA<PublicEvent>());
        expect(event.id, 'id');
        expect(event.title, 'title');
        expect(event.description, 'description');
        expect(event.maxPeople, 10);
        expect(event.location.geoPoint, GeoFirePoint(0, 0).geoPoint);
        expect(event.startTime, isA<DateTime>());
        expect(event.creatorId, 'creatorId');
        expect(event.genre, 'genre');
        expect(event.status, EventStatus.upcoming);
      });
    });

    test('Non-existent event should return null', () {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      dataSource.getEvent('id').then((Event? event) {
        expect(event, null);
      });
    });

    test('Distance fetching should retrieve only correct events', () {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      fakeFirestore.collection('events').doc('id').set({
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

      fakeFirestore.collection('events').doc('id2').set({
        'id': 'id2',
        'title': 'title2',
        'description': 'description2',
        'maxPeople': 10,
        'location': GeoFirePoint(2, 0).data,
        'startTime': DateTime.now().toString(),
        'creatorId': 'creatorId2',
        'genre': 'genre2',
        'accessibility': 'public',
        'status': 'upcoming',
      });

      fakeFirestore.collection('events').doc('id3').set({
        'id': 'id3',
        'title': 'title3',
        'description': 'description3',
        'maxPeople': 10,
        'location': GeoFirePoint(0, 3).data,
        'startTime': DateTime.now().toString(),
        'creatorId': 'creatorId3',
        'genre': 'genre3',
        'accessibility': 'public',
        'status': 'upcoming',
      });

      final Stream<List<Event>> stream = dataSource.getEventsWithinRadius(
        const GeoPoint(0, 0),
        223,
      );

      stream.listen((event) {
        expect(event.length, 2);
        expect(event.first.id, 'id');
        expect(event.last.id, 'id2');
      });
    });

    test('Event should be updated correcly', () async {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      await fakeFirestore.collection('events').doc('id').set({
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

      await dataSource.updateEvent(
        id: 'id',
        title: 'title2',
        description: 'description2',
        maxPeople: 20,
        location: const GeoPoint(1, 1),
        startTime: DateTime.now(),
        creatorId: 'creatorId2',
        genre: 'genre2',
        status: EventStatus.ongoing,
      );

      fakeFirestore
          .collection('events')
          .doc('id')
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> event) {
        expect(event.data()!['title'], 'title2');
        expect(event.data()!['description'], 'description2');
        expect(event.data()!['maxPeople'], 20);
        expect(event.data()!['location'], GeoFirePoint(1, 1).data);
        expect(event.data()!['startTime'], isA<String>());
        expect(event.data()!['creatorId'], 'creatorId2');
        expect(event.data()!['genre'], 'genre2');
        expect(event.data()!['accessibility'], 'public');
        expect(event.data()!['status'], 'ongoing');
      });
    });

    test('Event should be deleted correctly', () {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      fakeFirestore.collection('events').doc('id').set({
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

      dataSource.deleteEvent('id');

      fakeFirestore
          .collection('events')
          .doc('id')
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> document) {
        expect(document.exists, false);
      });
    });

    test('Delete non-existent event should not raise error', () {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      dataSource.deleteEvent('id');
    });

    test('Updating non-existent event should raise exception', () async {
      final EventDataSource dataSource = EventDataSource(fakeFirestore);

      final future = dataSource.updateEvent(
        id: 'id',
        title: 'title2',
        description: 'description2',
        maxPeople: 20,
        location: const GeoPoint(1, 1),
        startTime: DateTime.now(),
        creatorId: 'creatorId2',
        genre: 'genre2',
        status: EventStatus.ongoing,
      );
      await expectLater(future, throwsA(isA<Exception>()));
      expect((await fakeFirestore.collection('events').count().get()).count, 0);
    });
  });
}
