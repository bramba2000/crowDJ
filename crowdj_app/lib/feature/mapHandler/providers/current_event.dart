import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../events/models/event_model.dart';

part 'current_event.g.dart';

@riverpod
class CurrentEvents extends _$CurrentEvents {
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
