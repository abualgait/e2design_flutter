import 'dart:io';

import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File imageFile;
  int _showImageIndex = 0;
  var _locationController;


  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();

  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();

  }

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
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

  @override
  Widget build(BuildContext context) {
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
                            GestureDetector(
                              onTap: () {
                                _pickImage('Gallery').then((selectedImage) {
                                  setState(() {
                                    _showImageIndex = 1;
                                    imageFile = selectedImage;
                                  });
                                });
                              },
                              child: buildOutlinedButtonWidget(
                                  Colors.white,
                                  Colors.blue,
                                  AppLocalizations.of(context)
                                      .translate('choose_from_gallery')),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: IndexedStack(
                        index: _showImageIndex,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/image_placeholder.png",
                            fit: BoxFit.fill,
                          ),
                          _showImageIndex == 1
                              ? Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: FileImage(imageFile))),
                                )
                              : Image.asset(
                                  "assets/images/image_placeholder.png",
                                  fit: BoxFit.fill,
                                ),
                        ],
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            _pickImage('Camera').then((selectedImage) {
                              setState(() {
                                _showImageIndex = 1;
                                imageFile = selectedImage;
                              });
                            });
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
                              if (snapshot.hasData) {
                                return Row(
                                  // alignment: WrapAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Chip(
                                        label:
                                            Text(snapshot.data.first.locality),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _locationController.text =
                                              snapshot.data.first.locality;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: GestureDetector(
                                        child: Chip(
                                          label: Text(snapshot
                                                  .data.first.subAdminArea +
                                              ", " +
                                              snapshot.data.first.subLocality),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _locationController.text = snapshot
                                                    .data.first.subAdminArea +
                                                ", " +
                                                snapshot.data.first.subLocality;
                                          });
                                        },
                                      ),
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
}
