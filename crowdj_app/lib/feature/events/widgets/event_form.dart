import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../auth/providers/state/authentication_state.dart';
import '../../auth/providers/utils_auth_provider.dart';
import '../../mapHandler/widgets/address_form_field.dart';
import '../models/event_data.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

/// A widget to create, modify or show an event.
///
/// If an [event] is not provided, the widget will be in creation mode. Otherwise,
/// if an event is provided, the widget will be in show mode. If [canEdit] is
/// true, the widget will be in edit mode and the user will be able to modify.
/// If [startWithEdit] is true, the widget will start in edit mode.
class EventForm extends ConsumerStatefulWidget {
  final Event? event;
  final bool isCreation;
  final bool canEdit;
  final bool startWithEdit;
  final Function? onEventSubmitted;

  /// Creates a new event form.
  const EventForm(
      {super.key,
      this.event,
      this.canEdit = false,
      this.onEventSubmitted,
      this.startWithEdit = false})
      : isCreation = event == null,
        assert(!startWithEdit || (canEdit && startWithEdit));

  @override
  ConsumerState<EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<EventForm> {
  // ============ Interal fields ============
  final _eventService = EventService();
  List<String> musicGenres = const [
    'all genres',
    'Rock',
    'Pop',
    'Hip Hop',
    'Electronic',
    'Jazz',
    'Classical',
    'Country',
    'R&B',
    'Blues',
  ];

  // ============ Form controller ============
  final _formKey = GlobalKey<FormState>();
  late final _titleController =
      TextEditingController(text: widget.event?.title);
  late final _descriptionController =
      TextEditingController(text: widget.event?.description);
  late final _maxPeopleController =
      TextEditingController(text: widget.event?.maxPeople.toString());

  // ============ Form field variables ============
  late String? _musicGenre = widget.event?.genre;
  late bool _isPrivate = widget.isCreation || widget.event! is PrivateEvent;
  late DateTime? _startTime = widget.event?.startTime;
  late GeoPoint? _location = widget.event?.location.geoPoint;

  // ============ State variables ============
  late bool _isEdit = widget.startWithEdit || widget.isCreation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            /// Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              enabled: _isEdit,
            ),

            /// Description field
            TextFormField(
              controller: _descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              enabled: _isEdit,
            ),

            /// Date field
            DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Start time',
              ),
              initialValue: _startTime,
              validator: (value) =>
                  value == null ? 'Please enter a date' : null,
              onChanged: _isEdit ? (value) => _startTime = value : null,
            ),

            /// Genre field
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Music Genre',
              ),
              value: _musicGenre,
              onChanged: _isEdit
                  ? (String? newValue) {
                      setState(() {
                        _musicGenre = newValue;
                      });
                    }
                  : null,
              items: musicGenres.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            /// Max people field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Max people',
              ),
              keyboardType: TextInputType.number,
              controller: _maxPeopleController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null) {
                  return 'Please enter a number';
                }
                return null;
              },
              enabled: _isEdit,
            ),

            /// Public/Private switch
            SwitchListTile(
              title: const Text('Private'),
              value: _isPrivate,
              onChanged: _isEdit
                  ? (bool value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    }
                  : null,
              secondary: const Icon(Icons.lock),
            ),

            /// Address field
            AddressFormField(
              initialPosition: widget.event?.location != null
                  ? LatLng(widget.event!.location.latitude,
                      widget.event!.location.longitude)
                  : null,
              enabled: _isEdit,
              onPositionChanged: (LatLng position) {
                _location = GeoPoint(position.latitude, position.longitude);
              },
            ),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.canEdit && !widget.isCreation)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEdit = !_isEdit;
                        });
                        if (!_isEdit || widget.isCreation) {
                          _titleController.text = widget.event!.title;
                          _descriptionController.text =
                              widget.event!.description;
                          _maxPeopleController.text =
                              widget.event!.maxPeople.toString();
                          _musicGenre = widget.event!.genre;
                          _isPrivate = widget.event! is PrivateEvent;
                          _startTime = widget.event!.startTime;
                          _location = widget.event!.location.geoPoint;
                        }
                      },
                      child: Text(_isEdit ? 'Cancel' : 'Edit'),
                    ),
                  ),
                if (_isEdit || widget.isCreation)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _confirmForm,
                      child: Text(widget.isCreation ? 'Create' : 'Save'),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxPeopleController.dispose();
    super.dispose();
  }

  void _confirmForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.isCreation) {
        final creatorId = ref.read(userIdProvider);
        assert(creatorId is AuthenticationStateAuthenticated);

        await _eventService.createEvent(
            eventData: EventData(
          title: _titleController.text,
          description: _descriptionController.text,
          startTime: _startTime!,
          genre: _musicGenre!,
          isPrivate: _isPrivate,
          location: _location!,
          maxPeople: int.parse(_maxPeopleController.text),
          creatorId: (creatorId as AuthenticationStateAuthenticated).user.uid,
        ));
      } else {
        await _eventService.updateEvent(
          id: widget.event!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          maxPeople: int.parse(_maxPeopleController.text),
          startTime: _startTime,
          genre: _musicGenre!,
          location: _location!,
        );
      }
      if (widget.onEventSubmitted != null) {
        widget.onEventSubmitted!();
      }
      setState(() {
        _isEdit = false;
      });
    }
  }
}
