import 'package:crowdj/feature/events/data/participant_data_source.dart';
import 'package:crowdj/feature/events/models/participation.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Participations testing -', () {
    late FakeFirebaseFirestore firestore;
    late ParticipantDataSource dataSource;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = ParticipantDataSource(firestore: firestore);
    });

    test('Adding a participation should store it in the database', () async {
      const eventId = 'event1';
      const userId = 'user1';
      await dataSource.addParticipant(eventId, userId);
      final result = (await firestore
              .collection(Participation.collectionName)
              .doc('${eventId}_$userId')
              .get())
          .data();
      expect(result, isNotNull);
      final Participation actual = Participation.fromJson(result!);
      expect(actual.eventId, eventId);
      expect(actual.userId, userId);
    });

    test('Adding twice a participation should not overwrite the first one',
        () async {
      const eventId = 'event1';
      const userId = 'user1';
      await dataSource.addParticipant(eventId, userId);
      final result1st = (await firestore
              .collection(Participation.collectionName)
              .doc('${eventId}_$userId')
              .get())
          .data();
      await dataSource.addParticipant(eventId, userId);
      final result2nd = (await firestore
              .collection(Participation.collectionName)
              .doc('${eventId}_$userId')
              .get())
          .data();
      expect(result1st, result2nd);
      expect(result1st!['joinedAt'], result2nd!['joinedAt']);
    });

    test('Removing a participation should remove it from the database',
        () async {
      const eventId = 'event1';
      const userId = 'user1';
      firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId')
          .set(Participation(
                  eventId: eventId, userId: userId, joinedAt: DateTime.now())
              .toJson());
      await dataSource.removeParticipant(eventId, userId);
      final result = (await firestore
              .collection(Participation.collectionName)
              .doc('${eventId}_$userId')
              .get())
          .data();
      expect(result, isNull);
    });

    test('Removing non existing participation should not cause error',
        () async {
      const eventId = 'event1';
      const userId = 'user1';

      await dataSource.removeParticipant(eventId, userId);
    });

    test('Removing all participants of an event should remove them from db',
        () async {
      const eventId = 'event1';
      const userId = 'user1';
      const userId2 = 'user2';
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId')
          .set(Participation(
                  eventId: eventId, userId: userId, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId2')
          .set(Participation(
                  eventId: eventId, userId: userId2, joinedAt: DateTime.now())
              .toJson());
      await dataSource.removeAllParticipants(eventId);
      final result = await firestore
          .collection(Participation.collectionName)
          .where('eventId', isEqualTo: eventId)
          .get();
      expect(result.docs, isEmpty);
    });

    test(
        'Getting the participants of an event should return only the correct ids',
        () async {
      const eventId = 'event1';
      const eventId2 = 'event2';
      const userId = 'user1';
      const userId2 = 'user2';
      const userId3 = 'user3';
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId')
          .set(Participation(
                  eventId: eventId, userId: userId, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId2')
          .set(Participation(
                  eventId: eventId, userId: userId2, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId2}_$userId3')
          .set(Participation(
                  eventId: eventId2, userId: userId3, joinedAt: DateTime.now())
              .toJson());
      final result = await dataSource.getParticipantsId(eventId);
      expect(result, isNotNull);
      expect(result, isA<List<String>>());
      expect(result, contains(userId));
      expect(result, contains(userId2));
      expect(result, isNot(contains(userId3)));
    });

    test(
        'Getting the participants of a non existing event should throw an exception',
        () async {
      const eventId = 'event1';
      await expectLater(
          () => dataSource.getParticipantsId(eventId), throwsException);
    });

    test('Getting the events of a user should return only the correct ids',
        () async {
      const eventId = 'event1';
      const eventId2 = 'event2';
      const eventId3 = 'event3';
      const userId = 'user1';
      const userId2 = 'user2';
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId')
          .set(Participation(
                  eventId: eventId, userId: userId, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId}_$userId2')
          .set(Participation(
                  eventId: eventId, userId: userId2, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId2}_$userId')
          .set(Participation(
                  eventId: eventId2, userId: userId, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId2}_$userId2')
          .set(Participation(
                  eventId: eventId2, userId: userId2, joinedAt: DateTime.now())
              .toJson());
      await firestore
          .collection(Participation.collectionName)
          .doc('${eventId3}_$userId2')
          .set(Participation(
                  eventId: eventId3, userId: userId2, joinedAt: DateTime.now())
              .toJson());
      final result = await dataSource.getRegisteredEvents(userId);
      expect(result, isNotNull);
      expect(result, isA<List<String>>());
      expect(result, contains(eventId));
      expect(result, contains(eventId2));
      expect(result, isNot(contains(eventId3)));
    });

    test(
        'Getting the events of a non existing user should return an empty list',
        () async {
      const userId = 'user1';
      final result = await dataSource.getRegisteredEvents(userId);
      expect(result, isNotNull);
      expect(result, isA<List<String>>());
      expect(result, isEmpty);
    });
  });
}
