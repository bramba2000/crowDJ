import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/utils_auth_provider.dart';
import '../../events/models/event_model.dart';
import '../../events/services/event_service.dart';

part 'current_event.g.dart';

@riverpod
class VisibleEvents extends _$VisibleEvents {
  @override
  List<Event> build() {
    return const [];
  }

  void changeEvents(List<Event> events) {
    state = events;
  }
}

@riverpod
Future<List<Event>> eventsOfUser(EventsOfUserRef ref) async {
  final userId = ref.read(userIdProvider);
  return EventService().getRegisteredEvents(userId!);
}

@riverpod
Future<List<Event>> createdEvents(CreatedEventsRef ref) async {
  final eventService = EventService();
  final userId = ref.read(userIdProvider);
  return await eventService.getEventsByCreator(userId!);
}
