import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/participation.dart';

/// Data source class for participant related operations
///
/// This class is responsible for:
/// - create and delete participant from Firestore
/// - get participants of an event
/// - get events a user is registered to
class ParticipantDataSource {
  final FirebaseFirestore _firestore;
  final String _participationCollName = Participation.collectionName;

  /// Create a new instance of [ParticipantDataSource] providing a [FirebaseFirestore] instance
  /// If no [FirebaseFirestore] instance is provided, the default one will be used
  ParticipantDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Register a user to an event
  ///
  /// If the user is already registered, nothing will happen
  Future<void> addParticipant(String eventId, String userId) async {
    final doc = await _firestore
        .collection(_participationCollName)
        .doc('${eventId}_$userId')
        .get();
    if (doc.exists) return;
    await doc.reference.set(Participation(
            eventId: eventId, userId: userId, joinedAt: DateTime.now())
        .toJson());
  }

  /// Remove a user from an event
  ///
  /// If the user is not registered, nothing will happen
  Future<void> removeParticipant(String eventId, String userId) async {
    await _firestore
        .collection(_participationCollName)
        .doc('${eventId}_$userId')
        .delete();
  }

  /// Get the list of participants of an event
  /// If the event does not exist, an exception will be thrown. If the event has no participants,
  /// an empty list will be returned
  Future<List<String>> getParticipantsId(String eventId) async {
    final participations = await _firestore
        .collection(_participationCollName)
        .where('eventId', isEqualTo: eventId)
        .get();
    if (participations.docs.isEmpty) {
      throw Exception('No event with id $eventId');
    }
    return participations.docs
        .map((doc) => Participation.fromJson(doc.data()).userId)
        .toList();
  }

  /// Get the list of events a user is registered to
  /// If the user is not registered to any event an empty list will be returned. No check is done
  /// on the validity of the user id
  Future<List<String>> getRegisteredEvents(String userId) async {
    final participations = await _firestore
        .collection(_participationCollName)
        .where('userId', isEqualTo: userId)
        .get();
    return participations.docs
        .map((doc) => Participation.fromJson(doc.data()).eventId)
        .toList();
  }
}
