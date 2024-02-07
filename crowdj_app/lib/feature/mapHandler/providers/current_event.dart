import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/data/auth_data_source.dart';
import '../../auth/data/user_data_source.dart';
import '../../auth/providers/authentication_provider.dart';
import '../../auth/providers/state/authentication_state.dart';
import '../../events/models/event_model.dart';
import '../../events/services/event_service.dart';

part 'current_event.g.dart';

@riverpod
class CurrentEvents extends _$CurrentEvents {
  @override
  List<Event> build() {
    return const [];
  }

  void changeEvents(List<Event> events) {
    state = events;
  }

  void addEvent(Event event) {
    state = [...state, event];
  }
}

@riverpod
Future<List<Event>> createdEvents(CreatedEventsRef ref) {
  final eventService = EventService();
  final userId = ref.watch(
      authNotifierProvider(defaultAuthDataSource, defaultUserDataSource)
          .select((value) => switch (value) {
                AuthenticationStateAuthenticated a => a.user.uid,
                _ => null,
              }));
  return eventService.getEventsByCreator(userId!);
}
