import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/spotify.dart';

import '../data/events_data_source.dart';
import '../data/music_data_source.dart';
import '../data/participant_data_source.dart';
import '../models/event_data.dart';
import '../models/event_model.dart';
import '../models/track_metadata.dart';

class EventService {
  final EventDataSource _eventDataSource;
  final MusicDataSource _musicDataSource;
  final ParticipantDataSource _participantsDataSource;

  const EventService._(this._eventDataSource, this._musicDataSource,
      this._participantsDataSource);

  factory EventService() {
    final eventDataSource = EventDataSource();
    final musicDataSource = MusicDataSource();
    final participants = ParticipantDataSource();
    return EventService._(eventDataSource, musicDataSource, participants);
  }

  /// Register a user to an event
  ///
  /// If the user is already registered, nothing will happen. If the event does
  /// not exist, an [ArgumentError] is thrown. See also [ParticipantDataSource.addParticipant]
  Future<void> addParticipant(String eventId, String userId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _participantsDataSource.addParticipant(eventId, userId);
  }

  /// Add a track to an event
  ///
  /// If no event exists an [ArgumentError] is thrown. See also
  /// [MusicDataSource.addTrackToEvent]
  Future<void> addTrackToEvent(String eventId, Track track) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _musicDataSource.saveTrackMetadata(eventId, track);
  }

  /// Creates an event
  ///
  /// See also [EventDataSource.createEvent]
  Future<Event> createEvent({required EventData eventData}) =>
      _eventDataSource.createEvent(eventData);

  /// Delete an event
  ///
  /// Delete an events and all the associated participations and tracks. If the
  /// event does not exist, an [ArgumentError] is thrown.
  ///
  /// See also [EventDataSource.deleteEvent]
  Future<void> deleteEvent(String eventId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    await _eventDataSource.deleteEvent(eventId);
    await _participantsDataSource.removeAllParticipants(eventId);
  }

  /// Get an event by its id
  ///
  /// See also [EventDataSource.getEvent]
  Future<Event?> getEvent(String eventId) => _eventDataSource.getEvent(eventId);

  /// Get all the participants of an event
  ///
  /// If the event does not exist, an [ArgumentError] is thrown.
  ///
  /// See also [ParticipantDataSource.getParticipantsId]
  Future<List<String>> getEventParticipants(String eventId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _participantsDataSource.getParticipantsId(eventId);
  }

  /// Get all the events created by a user
  ///
  /// See also [EventDataSource.getEventsOfUser]
  Future<List<Event>> getEventsByCreator(String userId) =>
      _eventDataSource.getEventsOfUser(userId);

  /// Get all the events that are within a radius from a center point
  ///
  /// See also [EventDataSource.getEventsWithinRadius]
  Stream<List<Event>> getEventsWithinRadius(GeoPoint center, double radius) =>
      _eventDataSource.getEventsWithinRadius(center, radius);

  /// Get all the events a user is registered to
  ///
  /// No checks are peformed on the validity of the user id. See also
  /// [ParticipantDataSource.getRegisteredEvents]
  Future<List<Event>> getRegisteredEvents(String userId) async {
    final eventIds = await _participantsDataSource.getRegisteredEvents(userId);
    final List<Event> events = [];
    for (final eventId in eventIds) {
      final event = await _eventDataSource.getEvent(eventId);
      if (event == null) {
        throw Exception(
            'A participation is linked to a non existing event $eventId');
      }
      events.add(event);
    }
    return events;
  }

  /// Get all the tracks of an event
  ///
  /// If the events don't exists an [ArgumentError] exception is thrown. See
  /// also [MusicDataSource.getTracksMetadata]
  Future<List<TrackMetadata>> getTracksMetadata(String eventId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _musicDataSource.getTracksMetadata(eventId);
  }

  /// Mark a track as played
  ///
  /// If the event does not exist, an [ArgumentError] is thrown; otherwise, if
  /// the track does not exist, an exception is thrown.
  ///
  /// See also [MusicDataSource.markTrackAsPlayed]
  Future<void> markTrackAsPlayed(String eventId, String trackId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _musicDataSource.markTrackAsPlayed(eventId, trackId);
  }

  /// Update an event
  ///
  /// If the event does not exist, an [ArgumentError] is thrown. See also
  /// [EventDataSource.updateEvent]
  Future<void> updateEvent({
    required String id,
    String? title,
    String? description,
    int? maxPeople,
    GeoPoint? location,
    DateTime? startTime,
    String? genre,
    EventStatus? status,
  }) async {
    final event = await _eventDataSource.getEvent(id);
    if (event == null) {
      throw ArgumentError('Event with id $id does not exist');
    }
    return _eventDataSource.updateEvent(
      id: id,
      title: title,
      description: description,
      maxPeople: maxPeople,
      location: location,
      startTime: startTime,
      genre: genre,
      status: status,
    );
  }

  /// Vote a track
  ///
  /// If the event does not exist, an [ArgumentError] is thrown; otherwise, if
  /// the track does not exist, an exception is thrown.
  ///
  /// See also [MusicDataSource.voteTrack]
  Future<void> voteTrack(String eventId, String trackId, String userId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _musicDataSource.voteTrack(eventId, trackId, userId);
  }

  /// Unvote a track
  ///
  /// If the event does not exist, an [ArgumentError] is thrown; otherwise, if
  /// the track does not exist, an exception is thrown.
  ///
  /// See also [MusicDataSource.unvoteTrack]
  Future<void> unvoteTrack(
      String eventId, String trackId, String userId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _musicDataSource.unvoteTrack(eventId, trackId, userId);
  }

  /// Remove a user from an event
  ///
  /// If the user is not registered, nothing will happen. If the event does not
  /// exist, an [ArgumentError] is thrown.
  ///
  /// See also [ParticipantDataSource.removeParticipant]
  Future<void> removeParticipant(String eventId, String userId) async {
    final event = await _eventDataSource.getEvent(eventId);
    if (event == null) {
      throw ArgumentError('Event with id $eventId does not exist');
    }
    return _participantsDataSource.removeParticipant(eventId, userId);
  }

  /// Remove all participants from an event
}
