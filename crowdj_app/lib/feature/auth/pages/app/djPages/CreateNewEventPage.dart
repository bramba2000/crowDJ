import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../mapHandler/DynMap.dart';
import '../../../../mapHandler/MapModel.dart';
import '../../../../mapHandler/MapProvider.dart';

class CreateNeweventPage extends StatefulWidget {
  @override
  _CreateNeweventPageState createState() => _CreateNeweventPageState();
}

class _CreateNeweventPageState extends State<CreateNeweventPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _maxPeopleContoller = TextEditingController();
  int selectedNumber = 1;

  TextEditingController _addressController = TextEditingController();
  late GeoPoint location;
  late MapModel _map;
  bool _mapIsVisible = false;

  DateTime? _selectedDate;

  String? selectedGenre;

  bool _eventType = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    print("initilalize new event");
  }

  Future<void> _initializeMap() async {
    _map = await MapModel.create();
    //await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600 /* && usertype==DJ*/) {
          return _desktopDjPage();
        } else {
          return _errorMessagePage();
        }
      },
    );
  }

  Widget _desktopDjPage() {
    List<String> musicGenres = [
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

    return Scaffold(
      appBar: AppBar(title: const Text(" Create a New Event Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _titleForm(),
              const SizedBox(height: 16.0),
              _descriptionForm(),
              const SizedBox(height: 16.0),
              _maxPeopleForm(),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _dateForm(),
                        const SizedBox(height: 16.0),
                        _genreForm(musicGenres),
                        const SizedBox(height: 16.0),
                        _locationForm(),
                        const SizedBox(height: 16.0),
                        _publicOrPrivateForm(),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  if (_mapIsVisible)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _showMap(),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              _confirmationButton(),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  ///form for the maximun number of people
  TextFormField _maxPeopleForm() {
    return TextFormField(
      controller: _maxPeopleContoller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number';
        }
        if (int.tryParse(value) == null) {
          return 'Invalid number format';
        }
        if (int.parse(value) > 20000) {
          return 'max 20.000 partecipants';
        }
        if (int.parse(value) < 2) {
          return 'min 2 people';
        }
        // You can add more validation logic if needed
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Max number of people',
      ),
    );
  }

  ///button to switch form a private event to a public one
  Row _publicOrPrivateForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _eventType = !_eventType;
            });
          },
          child: const Text('change'),
        ),
        const SizedBox(width: 20),
        Text(
          _eventType ? 'Private' : 'Public',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  ///form to choose the gense
  DropdownButtonFormField<String> _genreForm(List<String> musicGenres) {
    return DropdownButtonFormField<String>(
      value: selectedGenre,
      items: musicGenres.map((genre) {
        return DropdownMenuItem<String>(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedGenre = value;
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Choose a genre',
        labelText: 'Music Genre',
      ),
    );
  }

  ///form to insert a description
  TextFormField _descriptionForm() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        if (value.toString().length > 1000) {
          return 'max 1000 characters';
        }
        return null;
      },
    );
  }

  ///form to add the event Date
  Row _dateForm() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Event Date',
            ),
            onTap: () => _selectDate(context),
            controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.toLocal()}".split(' ')[0]
                    : ''),
            validator: (value) {
              if (_selectedDate == null) {
                return 'Please select a date';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _selectDate(context),
          icon: Icon(Icons.calendar_today),
        ),
      ],
    );
  }

  ///form to title the event
  TextFormField _titleForm() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Event Title'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  ///banner with the calendar
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  //---------------->>about the map<<---------------------
  ///form to choose a location
  Row _locationForm() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an address';
              }
              if (value.toString().length > 100) {
                return 'max 100 characters';
              }
              return null;
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () => setState(
              () {
                fromAddrToCoord(_addressController.text).then(
                  (addrDetails) => setState(
                    () {
                      location = getGeoPointFromJson(addrDetails);
                      print("Lat:" +
                          location.latitude.toString() +
                          " Lng:" +
                          location.longitude.toString());
                      _map = MapModel(g: location);
                      _map!.updatePlace(location);
                      _map!.updateCenter(location);
                      print("all updated");
                      // _mapIsVisible = true;
                    },
                  ),
                );
                _mapIsVisible = true;
              },
            ),
            child: const Text(" confirm location "),
          ),
        ),
      ],
    );
  }

  ///plot the map
  Widget _showMap() {
    print("show map");
    try {
      return Container(
        padding: EdgeInsets.all(40),
        height: 400,
        //width: 400,
        child: DynMap(
          mapModel: _map,
          center: location,
        ),
      );
    } catch (e) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Fetching Data...'),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      );
    }
  }

  // --------------------->><<------------------------
  
  ///button to confirm the information into the form. You can find the
  ElevatedButton _confirmationButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Form is valid, process the data
          print('Title: ${_titleController.text}');
          print("Description : ${_descriptionController.text}");
          print('Date: $_selectedDate');
          print("Address : ${_addressController.text}");

        }
      },
      child: const Text('Submit'),
    );
  }

  Widget _errorMessagePage() {
    return const Scaffold(
      body: Center(
        child: Text(
          "opss.. this screen is too small",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
