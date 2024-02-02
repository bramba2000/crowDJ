import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../feature/events/data/events_data_source.dart';
import '../../../feature/events/models/event_data.dart';
import '../../../feature/mapHandler/DynMap.dart';
import '../../../feature/mapHandler/MapModel.dart';
import '../../../feature/mapHandler/widgets/map_utils.dart';
import '../../../feature/auth/data/auth_data_source.dart';
import '../../../feature/auth/data/user_data_source.dart';
import '../../../feature/auth/models/user_props.dart';
import '../../../feature/auth/providers/authentication_provider.dart';
import '../../../feature/auth/providers/state/authentication_state.dart';
import '../utils/appBar.dart';

class CreateNeweventPage extends ConsumerStatefulWidget {
  const CreateNeweventPage({super.key});

  @override
  ConsumerState<CreateNeweventPage> createState() => _CreateNeweventPageState();
}

class _CreateNeweventPageState extends ConsumerState<CreateNeweventPage> {
  ///----> form <----
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxPeopleContoller = TextEditingController();
  int selectedNumber = 1;
  final TextEditingController _addressController = TextEditingController();
  DateTime _selectedDate = DateTime(0);
  String _selectedGenre = "all genres";
  bool _isPrivate = false;

  ///----> music and songs <----
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

  ///----> map <----
  late GeoPoint _location;
  late MapModel _mapModel;
  late DynMap _map;
  late MapController _mapController;
  bool _mapIsVisible = false;

  late var watch;

  ///----> user props <----
  late UserProps _userProps;
  late var _provider;
  late String _userID;

  ///----> event props <----
  late EventDataSource _eventDataSource;

  @override
  void initState() {
    super.initState();

    ///map initialization
    ///
    _mapController = MapController();
    _initializeMapAndModel();
    //print("initilalize new event")
  }

  Future<void> _initializeMapAndModel() async {
    _mapModel = await MapModel.create();
    _location = _mapModel.getCenter();
    _map = DynMap(
      mapModel: _mapModel,
      center: _location,
      mapController: _mapController,
    );
    //await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _initializeUserProps() async {
    _provider = authNotifierProvider(AuthDataSource(), UserDataSource());

    ///user initialization
    ///
    watch = ref.watch(_provider);
    if (watch is AuthenticationStateAuthenticated) {
      _userProps = watch.userProps;
      _userID = watch.user.uid;
    } else {
      throw ErrorDescription(" impossible to load user props ");
    }

    ///event_data_source initialization
    ///
    _eventDataSource = EventDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initializeUserProps();
        if (constraints.maxWidth > 600 /* && usertype==DJ*/) {
          return _desktopDjPage();
        } else {
          return _errorMessagePage();
        }
      },
    );
  }

  Widget _desktopDjPage() {
    return Scaffold(
      appBar: CustomAppBar(text: " Create New Event "),
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
                        _genreForm(),
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
              _isPrivate = !_isPrivate;
            });
          },
          child: const Text('change'),
        ),
        const SizedBox(width: 20),
        Text(
          _isPrivate ? 'Private' : 'Public',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  ///form to choose the gense
  DropdownButtonFormField<String> _genreForm() {
    return DropdownButtonFormField<String>(
      value: _selectedGenre,
      items: musicGenres.map((genre) {
        return DropdownMenuItem<String>(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGenre = value!;
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
                    ? "${_selectedDate.toLocal()}".split(' ')[0]
                    : ''),
            validator: (value) {
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
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
          flex: 3,
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
            //_mapIsVisible? const SizedBox() :
            onPressed: () => setState(
              () {
                fromAddrToCoord(_addressController.text).then(
                  // -------------------->> VEDI FUTURE bUILDER
                  (addrDetails) => setState(
                    () {
                      _location = getGeoPointFromJson(addrDetails);
                      print("Lat:${_location.latitude} Lng:${_location.longitude}");
                      _mapController.move(
                          LatLng(_location.latitude, _location.longitude),
                          13.0);
                      _mapModel = MapModel(g: _location);
                      _mapModel.updatePlace(_location);
                      _mapModel.updateCenter(_location);
                      print("all updated");
                      _map = DynMap(
                        mapModel: _mapModel,
                        center: _location,
                        mapController: _mapController,
                      );
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
        padding: const EdgeInsets.all(40),
        height: 400,
        //width: 400,
        child: _map,
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

          _eventDataSource.createEvent(EventData(
            title: _titleController.text,
            description: _descriptionController.text,
            maxPeople: int.tryParse(_maxPeopleContoller.text)!,
            location: _location,
            startTime: _selectedDate,
            creatorId: _userID,
            genre: _selectedGenre,
          ));

          context.replace('/');
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
