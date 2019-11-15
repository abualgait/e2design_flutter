import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/request/question_request.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';

class AddNewPostPage extends StatefulWidget {
  Function onQuestionCreated;

  AddNewPostPage(this.onQuestionCreated);

  @override
  _AddNewPostPageState createState() => _AddNewPostPageState();
}

class _AddNewPostPageState extends State<AddNewPostPage> {
  Future<File> imageFile;

  TextEditingController controller = TextEditingController();
  String thisText = "";
  String locationStr = "";
  String longStr = "";
  String latStr = "";
  String timeStr = "";
  var showloader = false;
  BuildContext globalContext;

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
    this.thisText = controller.text;

    setState(() {
      showloader = true;
      isOnline().then((onValue) {
        if (onValue) {
          createQuestion();
        } else {
          //show toas offline mode
          // showMessage(globalContext, "Internet Connection lost");
          flushBarUtil(
              globalContext, "Oops!", "Internet Connection lost", Icons.close);
        }
      });
    });
  }

  void createQuestion() {
    QuestionRequest questionRequest = new QuestionRequest(
      question: thisText,
      location: longStr + "@" + latStr,
      city: locationStr,
      details: "details",
      image: "",
      tag_1: "",
      tag_2: "",
      tag_3: "",
      user_id: "",
    );

    imageFile.then((onValue) {
      _uploadImage(questionRequest, onValue).then((onValue) {
        checkResponse(onValue);
      });
    });
  }

  Future<Map<String, dynamic>> _uploadImage(
      QuestionRequest questionRequest, File image) async {
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST',
        Uri.parse("https://murmuring-meadow-41519.herokuapp.com/api/question"));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    imageUploadRequest.fields['question'] = questionRequest.question;
    imageUploadRequest.fields['location'] = questionRequest.location;
    imageUploadRequest.fields['city'] = questionRequest.city;
    imageUploadRequest.fields['details'] = questionRequest.details;
    imageUploadRequest.fields['tag_1'] = questionRequest.tag_1;
    imageUploadRequest.fields['tag_2'] = questionRequest.tag_2;
    imageUploadRequest.fields['tag_3'] = questionRequest.tag_3;
    imageUploadRequest.fields['user_id'] = questionRequest.user_id;
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void checkResponse(Map<String, dynamic> response) {
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      flushBarUtil(
          globalContext, "Oops!", "Question Upload Failed", Icons.close);
    } else {
      Navigator.pop(globalContext);
      widget.onQuestionCreated();
    }
    setState(() {
      showloader = false;
    });
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
    timeStr = formattedDate;
    return Scaffold(
      body: BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          globalContext = context;
          return Theme(
              data: state.themeData,
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
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
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xff614385),
                              Color(0xff516395),
                            ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
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
                                        controller: controller,
                                        minLines: 4,
                                        maxLines: 25,
                                        style: TextStyle(
                                          color: state
                                              .themeData.textTheme.body1.color,
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
                              Chip(
                                label: new Text(controller.text),
                                onDeleted: () {},
                              ),
                              Visibility(
                                visible: false,
                                child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        AsyncSnapshot<
                                                                List<Address>>
                                                            snapshot) {
                                                      //  if (snapshot.hasData) {
                                                      if (snapshot.hasData &&
                                                          snapshot.data.first
                                                                  .locality !=
                                                              null) {
                                                        locationStr = snapshot
                                                            .data
                                                            .first
                                                            .locality;
                                                        return Chip(
                                                          labelStyle: TextStyle(
                                                            color: state
                                                                .themeData
                                                                .textTheme
                                                                .body1
                                                                .color,
                                                          ),
                                                          label: Text(snapshot
                                                              .data
                                                              .first
                                                              .locality),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        color: state
                                                            .themeData
                                                            .textTheme
                                                            .body1
                                                            .color,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14.0))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
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
                      ),
                      Visibility(
                        child: Center(child: CircularProgressIndicator()),
                        visible: showloader,
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
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
      longStr = currentLocation.longitude.toString();
      latStr = currentLocation.latitude.toString();
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
          print("show");
          print(snapshot.data.path);

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
                        fit: BoxFit.cover, image: FileImage(snapshot.data))),
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
