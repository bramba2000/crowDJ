import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../auth/data/auth_data_source.dart';
import '../../auth/data/user_data_source.dart';
import '../../auth/providers/authentication_provider.dart';
import '../../auth/providers/state/authentication_state.dart';
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

  /// Creates a new event form.
  const EventForm(
      {super.key, this.event, this.canEdit = false, this.startWithEdit = false})
      : isCreation = event == null,
        assert(!startWithEdit || (canEdit && startWithEdit));

  @override
  ConsumerState<EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<EventForm> {
  // ============ Interal fields ============
  final _eventService = EventService();
  final _dateFormat = DateFormat.yMd();
  final _timeFormat = DateFormat.jm();
  // TODO: move to a global file
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
  late final _dateController = TextEditingController(
      text: widget.event?.startTime != null
          ? _dateFormat.format(widget.event!.startTime)
          : null);
  late final _timeController = TextEditingController(
      text: widget.event?.startTime != null
          ? _timeFormat.format(widget.event!.startTime)
          : null);

  // ============ Form field variables ============
  late String? _musicGenre = widget.event?.genre;
  late bool _isPrivate = widget.isCreation || widget.event! is PrivateEvent;
  late DateTime? _startTime = widget.event?.startTime;
  late int _maxPeople = widget.event?.maxPeople ?? 100;
  late GeoPoint? _location = null;

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

            /// Max people field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Max people',
              ),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) => _maxPeople = int.parse(value),
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
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _confirmForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.isCreation) {
        final creatorId = ref.read(
            authNotifierProvider(defaultAuthDataSource, defaultUserDataSource));
        assert(creatorId is AuthenticationStateAuthenticated);

        _eventService.createEvent(
            eventData: EventData(
          title: _titleController.text,
          description: _descriptionController.text,
          startTime:
              DateTime.parse(_dateController.text + _timeController.text),
          genre: _musicGenre!,
          isPrivate: _isPrivate,
          location: const GeoPoint(0, 0),
          maxPeople: _maxPeople,
          creatorId: (creatorId as AuthenticationStateAuthenticated).user.uid,
        ));
      }
    }
  }
}
