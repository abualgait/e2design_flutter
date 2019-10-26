import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/normal_response.dart';
import 'package:e2_design/models/request/question_request.dart';
import 'package:e2_design/repositories/base_repository.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

class AddNewPostPage extends StatefulWidget {
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

  BaseRepository _baseRepository;
  String base64Image;

  @override
  void initState() {
    super.initState();
    _baseRepository = BaseRepository();
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
        image: base64Image);

//    _baseRepository.createQuestions(questionRequest).then((onValue) {
//      checkResponse(onValue);
//    });
    imageFile.then((onValue) {
      getUploadimg(questionRequest, onValue);
//      .then((onValue) {
//        // checkResponse(onValue);
//      });
    });
  }

  ///storage/emulated/0/Android/data/com.abualgait.e2_design/files/Pictures/scaled_image_picker8641475548139463162.jpg
  _asyncFileUpload(QuestionRequest questionRequest, File file) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST",
        Uri.parse("https://murmuring-meadow-41519.herokuapp.com/api/question"));
    //add text fields
    request.fields["question"] = questionRequest.question;
    request.fields["location"] = questionRequest.location;
    request.fields["city"] = questionRequest.city;
    request.fields["details"] = questionRequest.details;
    print(file.path);
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);

    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }

  Upload(QuestionRequest questionRequest, File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri =
        Uri.parse("https://murmuring-meadow-41519.herokuapp.com/api/question");

    var request = new http.MultipartRequest("POST", uri);
    //add text fields
    request.fields["question"] = questionRequest.question;
    request.fields["location"] = questionRequest.location;
    request.fields["city"] = questionRequest.city;
    request.fields["details"] = questionRequest.details;
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void getUploadimg(QuestionRequest questionRequest, _image) async {
    String apiUrl = 'https://murmuring-meadow-41519.herokuapp.com/api/question';
    final length = await _image.length();
    final request = new http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..files.add(new http.MultipartFile('image', _image.openRead(), length));
    http.Response response = await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");

  }

  void checkResponse(NormalResponse onValue) {
    NormalResponse response = onValue;

    if (response.message != "") {
      print("Question has been posted successfuly");
      //Navigator.pop(context);
    } else {
      //show status false and show message
      print(response.message);
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
                                      controller: controller,
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
                                                    locationStr = snapshot
                                                        .data.first.locality;
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
                      Visibility(
                        child: Center(child: CircularProgressIndicator()),
                        visible: showloader,
                      )
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
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
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
