import 'dart:async';
import 'dart:io';

import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AddNewPostPage extends StatefulWidget {
  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  Future<File> imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onpressed() {
    print("send pressed");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
        onPressed: _onpressed,
        icon: Icon(Icons.send),
      )
    ];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \nEEE d MMM yyyy').format(now);
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Scaffold(
              appBar: buildMainAppBarWithActions(
                  state,
                  true,
                  false,
                  context,
                  AppLocalizations.of(context).translate('app_add_new_post'),
                  state.themeData.textTheme.headline,
                  state.themeData.primaryColor,
                  actions),
              backgroundColor: Colors.white10,
              body: SafeArea(
                child: Container(
                  color: state.themeData.primaryColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                            child: Image.asset(
                          "assets/images/worldmap.jpg",
                          fit: BoxFit.cover,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    child: TextField(
                                      minLines: 4,
                                      maxLines: 25,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                          hintStyle: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey),
                                          hintText:
                                              'What do you want to ask about?'),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,
                                                    size: 20),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text("Location"),
                                              ],
                                            ),
                                            FutureBuilder(
                                                future: locateUser(),
                                                builder: ((context,
                                                    AsyncSnapshot<List<Address>>
                                                        snapshot) {
                                                  //  if (snapshot.hasData) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data.first
                                                              .locality !=
                                                          null) {
                                                    return Chip(
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                      label: Text(snapshot
                                                          .data.first.locality),
                                                    );
                                                  } else {
                                                    print(
                                                        "Connection State : ${snapshot.connectionState}");
                                                    return SizedBox(
                                                        height: 16,
                                                        width: 16,
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                }))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 1,
                                          child: Container(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.watch_later,
                                                    size: 20),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text("Time"),
                                              ],
                                            ),
                                            Text(formattedDate,
                                                style: new TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.0))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: () {
                                                _pickImage('Camera');
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.image),
                                              onPressed: () {
                                                _pickImage('Gallery');
                                              },
                                            )
                                          ],
                                        ),
                                        Expanded(
                                            child: Flex(
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            Expanded(child: showImage())
                                          ],
                                        ))
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.4),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0))
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: FileImage(snapshot.data))),
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.4),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0))
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.asset(
                  "assets/images/image_placeholder.png",
                  fit: BoxFit.cover,
                ),
              ));
        }
      },
    );
  }
}
