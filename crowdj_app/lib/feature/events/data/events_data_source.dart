import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../models/event_data.dart';
import '../models/event_model.dart';

class EventDataSource {
  static const String _collectionName = Event.collectionName;

  final FirebaseFirestore _firestore;
  final GeoFlutterFire _geo = GeoFlutterFire();

  //Field used internally by random password generator
  static const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghijklmnopqrstuvwxyz';
  static const int _passwordLength = 8;
  static final Random _rnd = Random.secure();

  /// Generates a random password of length [_passwordLength] using characters and digits
  String _generatePassword() {
    return String.fromCharCodes(Iterable.generate(_passwordLength,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Event? _eventStatusControl(Event? e) {
    if (e == null) {
      return e;
    }
    if (e.status != EventStatus.past) {
      if (e.startTime.isAfter(DateTime.now().add(const Duration(days: 1)))) {
        return e.copyWith(status: EventStatus.past);
      } else if (e.startTime.isAfter(DateTime.now()) &&
          e.status != EventStatus.upcoming) {
        return e.copyWith(status: EventStatus.upcoming);
      } else {
        return e;
      }
    } else {
      return e;
    }
  }

  EventDataSource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates an event in the database
  ///
  /// Create a new event with the provided parameters, and adds it to the database.
  /// * If [isPrivate] is true, a random password will be generated for the event
  /// and it will be added to the database as a private event
  /// * If [isPrivate] is false or not provided, the event will be added to the
  /// database as a public event
  Future<Event> createEvent(
    EventData eventData,
  ) async {
    String id = _firestore.collection(_collectionName).doc().id;
    Event event = Event.fromEventData(id, eventData);
    event = _eventStatusControl(event)!;
    _firestore.collection(_collectionName).doc(event.id).set(event.toJson());
    return event;
  }

  /// Updates an event in the database
  ///
  /// Updates the event with the provided [id] with the provided parameters,
  /// leaving the parameters that are not provided unchanged. The [makePrivate]
  /// is used to change the event from public to private and vice versa:
  /// * if it is true, the event will be changed to private, and a password will
  /// be generated
  /// * if it is false, the event will be changed to public
  /// * if it is not provided, the event will be left unchanged
  ///
  /// In case the password of a private event is compromised, the only
  /// possibility to change it is to change the event to public and then back to
  /// private, which will generate a new password
  Future<void> updateEvent({
    required String id,
    String? title,
    String? description,
    int? maxPeople,
    GeoPoint? location,
    DateTime? startTime,
    String? creatorId,
    String? genre,
    EventStatus? status,
    String? password,
    bool? makePrivate,
  }) async {
    final DocumentReference<Map<String, dynamic>> eventRef =
        _firestore.collection(_collectionName).doc(id);
    final DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
        await eventRef.get();
    if (!eventSnapshot.exists) {
      eventRef.delete();
      throw Exception('Event with id $id does not exist');
    }
    final Event event = Event.fromJson(eventSnapshot.data()!);
    late Event updatedEvent;
    switch (event) {
      case PublicEvent _:
        updatedEvent = event.copyWith(
          title: title ?? event.title,
          description: description ?? event.description,
          maxPeople: maxPeople ?? event.maxPeople,
          location: location != null
              ? GeoFirePoint(location.latitude, location.longitude)
              : event.location,
          startTime: startTime ?? event.startTime,
          creatorId: creatorId ?? event.creatorId,
          genre: genre ?? event.genre,
          status: status ?? event.status,
        );
        if (makePrivate ?? false) {
          updatedEvent = updatedEvent.toPrivate(password ?? '');
        }
        break;
      case PrivateEvent _:
        updatedEvent = event.copyWith(
          title: title ?? event.title,
          description: description ?? event.description,
          maxPeople: maxPeople ?? event.maxPeople,
          location: location != null
              ? GeoFirePoint(location.latitude, location.longitude)
              : event.location,
          startTime: startTime ?? event.startTime,
          creatorId: creatorId ?? event.creatorId,
          genre: genre ?? event.genre,
          status: status ?? event.status,
        );
        if (!(makePrivate ?? true)) {
          updatedEvent = updatedEvent.toPublic();
        }
    }
    if (status != null) {
      updatedEvent = _eventStatusControl(updatedEvent)!;
    }
    if (updatedEvent != event) {
      await eventRef.set(updatedEvent.toJson());
    }
  }

  /// Deletes an event from the database
  ///
  /// Deletes the event with the provided [eventId] from the database
  Future<void> deleteEvent(String eventId) async {
    _firestore.collection(_collectionName).doc(eventId).delete();
  }

  /// Retrieves an event from the database
  ///
  /// Retrieves the event with the provided [eventId] from the database
  Future<Event?> getEvent(String eventId) async {
    final DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
        await _firestore.collection(_collectionName).doc(eventId).get();
    final data = eventSnapshot.data();
    final Event? event = data != null ? Event.fromJson(data) : null;
    final Event? checkedEvent = _eventStatusControl(event);
    if (checkedEvent != event) {
      updateEvent(id: eventId, status: checkedEvent?.status);
    }
    return data != null ? checkedEvent : null;
  }

  /// Retrieves a stream of all the events from the database that are within a
  /// radius from a center point
  ///
  /// Retrieves all the events from the database that are within a [radius] from
  /// the [center] point. This method returns a stream of events, which is
  /// updated every time a new event that is inside the radius is added to the
  /// database
  Stream<List<Event>> getEventsWithinRadius(GeoPoint center, double radius) {
    final CollectionReference<Map<String, dynamic>> eventsCollection =
        _firestore.collection(_collectionName);
    final GeoFirePoint centerPoint =
        GeoFirePoint(center.latitude, center.longitude);
    final Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: eventsCollection)
        .withinAsSingleStreamSubscription(
            center: centerPoint,
            radius: radius,
            field: 'location',
            strictMode: true);
    return stream.map((List<DocumentSnapshot> documentList) {
      final List<Event> eventList = [];
      for (final DocumentSnapshot document in documentList) {
        final data = document.data() as Map<String, dynamic>?;
        if (data != null) {
          final event = Event.fromJson(data);
          final checkedEvent = _eventStatusControl(event)!;
          if (checkedEvent != event) {
            updateEvent(id: checkedEvent.id, status: checkedEvent.status);
          }
          eventList.add(checkedEvent);
        }
      }
      return eventList;
    });
  }

  /// Retrieves all the events from the database that are created by the user
  /// with the provided [userId]
  Future<List<Event>> getEventsOfUser(String userId) async {
    final CollectionReference<Map<String, dynamic>> eventsCollection =
        _firestore.collection(_collectionName);
    final documentSnapshot =
        await eventsCollection.where('creatorId', isEqualTo: userId).get();
    if (documentSnapshot.docs.isNotEmpty) {
      return documentSnapshot.docs.map((e) {
        final event = Event.fromJson(e.data());
        final checkedEvent = _eventStatusControl(event)!;
        if (checkedEvent != event) {
          updateEvent(id: checkedEvent.id, status: checkedEvent.status);
        }
        return checkedEvent;
      }).toList();
    }
    return [];
  }
}
