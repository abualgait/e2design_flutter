import 'dart:async';
import 'dart:io';

import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  Future<File> imageFile;
  GoogleMap googleMap;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    googleMap = GoogleMap(
      mapType: _currentMapType,
      myLocationEnabled: true,
      initialCameraPosition: _initialCamera,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {gramercyMarker},
    );
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Scaffold(
              backgroundColor: Colors.white10,
              body: SafeArea(
                child: Container(
                  color: state.themeData.primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                            ),
                            OutlineButton(
                              color: Colors.white,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              onPressed: () {
                                _pickImage('Gallery');
                              },
                              textColor: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(AppLocalizations.of(context)
                                    .translate('choose_from_gallery')),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          SizedBox(height: 300.0, child: googleMap),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: RaisedButton(
                                onPressed: () {
                                  _onMapTypeButtonPressed();
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                child: const Icon(Icons.map, size: 36.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: IndexedStack(
                        children: <Widget>[
                          showImage(),
                        ],
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            _pickImage('Camera');
                          },
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "TEXT ONLY",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FutureBuilder(
                            future: locateUser(),
                            builder: ((context,
                                AsyncSnapshot<List<Address>> snapshot) {
                              //  if (snapshot.hasData) {
                              if (snapshot.hasData &&
                                  snapshot.data.first.locality != null) {
                                return Row(
                                  // alignment: WrapAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Chip(
                                        label: Text(
                                            snapshot.data.first.addressLine),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                );
                              } else {
                                print(
                                    "Connection State : ${snapshot.connectionState}");
                                return CircularProgressIndicator();
                              }
                            })),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  _pickImage(String action) {
    action == 'Gallery'
        ? setState(() {
            imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
          })
        : setState(() {
            imageFile = ImagePicker.pickImage(source: ImageSource.camera);
          });
  }

  Future<List<Address>> locateUser() async {
    LocationData currentLocation;
    Future<List<Address>> addresses;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();

      print(
          'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');
      //setup after get coordinates
      _currentCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 16);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
          CameraUpdate.newCameraPosition(_currentCameraPosition));

      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);

      addresses = Geocoder.local.findAddressesFromCoordinates(coordinates);
    } on PlatformException catch (e) {
      print('ERROR : $e');
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return addresses;
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: FileImage(snapshot.data))),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Image.asset(
            "assets/images/image_placeholder.png",
            fit: BoxFit.fill,
          );
        }
      },
    );
  }
}

Marker gramercyMarker = Marker(
  markerId: MarkerId('Tech'),
  position: LatLng(30.0016564, 31.1367549),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
