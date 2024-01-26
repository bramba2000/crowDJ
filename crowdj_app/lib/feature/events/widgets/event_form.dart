import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event_model.dart';

/// A widget to create, modify or show an event.
///
/// If an event is not provided, the widget will be in creation mode. Otherwise,
/// if an event is provided, the widget will be in show mode. If [canEdit] is
/// true, the widget will be in edit mode and the user will be able to modify.
/// If [startWithEdit] is true, the widget will start in edit mode.
class EventForm extends StatefulWidget {
  final Event? event;
  final bool isCreation;
  final bool canEdit;
  final bool startWithEdit;

  /// Creates a new event form. If [event] is not null, the form will be in show
  /// mode. If [canEdit] is true, the form will be in edit mode and the user
  const EventForm(
      {super.key, this.event, this.canEdit = false, this.startWithEdit = false})
      : isCreation = event == null,
        assert(!startWithEdit || (canEdit && startWithEdit));

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat.yMd();
  final _timeFormat = DateFormat.jm();
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
  late String? _musicGenre = widget.event?.genre;
  late bool _isPrivate = switch (widget.event) {
    PrivateEvent? _ => true,
    _ => false,
  };
  late bool _isEdit = widget.startWithEdit || widget.isCreation;

  List<String> musicGenres = [
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
            TextFormField(
              controller: _dateController,
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                _dateController.text = date.toString();
              },
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              enabled: _isEdit,
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
              ),
              onTap: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  // ignore: use_build_context_synchronously
                  _timeController.text = time.format(context);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a time';
                }
                return null;
              },
              enabled: _isEdit,
            ),
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

  void _confirmForm() {}
}
