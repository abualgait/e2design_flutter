import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/comment_response.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/models/request/comment_request.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_details_bloc.dart';
import 'package:e2_design/repositories/base_repository.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class RespondToPostPage extends StatefulWidget {
  String uid = "";

  RespondToPostPage(String id) {
    this.uid = id;
  }

  @override
  _RespondToPostPageState createState() => _RespondToPostPageState();
}

class _RespondToPostPageState extends State<RespondToPostPage> {
  PostDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostDetailsBloc();
    _bloc.fetchPostDetailsList(widget.uid);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _onpressed() {
    print("send pressed");
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
              body: Container(
                color: state.themeData.primaryColor,
                child: RefreshIndicator(
                  onRefresh: () => _bloc.fetchPostDetailsList(widget.uid),
                  child: StreamBuilder<ApiResponse<PostDetailsObj>>(
                    stream: _bloc.postdetailsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Loading(
                                loadingMessage: snapshot.data.message);
                            break;
                          case Status.COMPLETED:
                            return Stack(children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: PostDetailsWidget(
                                    postDetailsObj: snapshot.data.data),
                              ),
                            ]);
                            break;
                          case Status.ERROR:
                            return Error(
                              errorMessage: snapshot.data.message,
                              onRetryPressed: () =>
                                  _bloc.fetchPostDetailsList(widget.uid),
                            );
                            break;
                        }
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}

class PostDetailsWidget extends StatefulWidget {
  final PostDetailsObj postDetailsObj;

  const PostDetailsWidget({Key key, this.postDetailsObj}) : super(key: key);

  @override
  _PostDetailsWidgetState createState() => _PostDetailsWidgetState();
}

class _PostDetailsWidgetState extends State<PostDetailsWidget> {
  Future<File> imageFile;
  GoogleMap googleMap;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  bool isMapCreated = false;
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;
  MapType _currentMapType = MapType.normal;
  TextEditingController controler = TextEditingController();
  String thisText = "";
  var showloader = false;
  BaseRepository _baseRepository;

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
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: FileImage(snapshot.data))),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Image.asset(
            "assets/images/image_placeholder.png",
            fit: BoxFit.cover,
            height: 150,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _baseRepository = BaseRepository();
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

  changeMapMode() async {
    int isDarkDayMode = await changeThemeBloc.getOption();
    if (isDarkDayMode == 1) {
      getJsonFile("assets/nightmode.json").then(setMapStyle);
    } else {
      getJsonFile("assets/daymode.json").then(setMapStyle);
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }
    googleMap = GoogleMap(
      mapType: _currentMapType,
      myLocationEnabled: true,
      initialCameraPosition: _initialCamera,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
        isMapCreated = true;
        setState(() {});
      },
      markers: {gramercyMarker},
    );
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Theme(
              data: state.themeData,
              child: Scaffold(
                  backgroundColor: state.themeData.backgroundColor,
                  body: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.postDetailsObj.post_img == null
                                ? ""
                                : widget.postDetailsObj.post_img,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/image_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/image_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                            fadeInDuration: Duration(seconds: 1),
                            fadeOutDuration: Duration(seconds: 1),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 5,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                widget.postDetailsObj
                                                            .post_txt ==
                                                        null
                                                    ? ""
                                                    : widget.postDetailsObj
                                                        .post_txt,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                              Icons.location_on,
                                                              size: 20),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              child: Text(
                                                                widget.postDetailsObj
                                                                            .post_location ==
                                                                        null
                                                                    ? ""
                                                                    : widget
                                                                        .postDetailsObj
                                                                        .post_location,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(Icons.history,
                                                          size: 20),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(widget.postDetailsObj
                                                                  .post_time ==
                                                              null
                                                          ? ""
                                                          : widget
                                                              .postDetailsObj
                                                              .post_time),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new TextField(
                                            controller: controler,
                                            style: TextStyle(
                                                color: state.themeData.textTheme
                                                    .body1.color),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Type your Answer',
                                              labelStyle: TextStyle(
                                                color: state.themeData.textTheme
                                                    .body1.color,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 150,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: showImage(),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: googleMap,
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xff614385 ),
                                                    Color(0xff516395),
                                                  ])),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showloader = true;
                                                        });
                                                        isOnline()
                                                            .then((onValue) {
                                                          if (onValue) {
                                                            checkValidations(
                                                                context);
                                                          } else {
                                                            //show toas offline mode
                                                          }
                                                        });
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          "Submit",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: <Widget>[
                                                      IconButton(
                                                        color: Colors.white,
                                                        icon: Icon(
                                                            Icons.camera_alt),
                                                        onPressed: () {
                                                          _pickImage('Camera');
                                                        },
                                                      ),
                                                      IconButton(
                                                        color: Colors.white,
                                                        icon: Icon(Icons.image),
                                                        onPressed: () {
                                                          _pickImage('Gallery');
                                                        },
                                                      ),
                                                      IconButton(
                                                        color: Colors.white,
                                                        icon: Icon(Icons.map),
                                                        onPressed: () {},
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ))),
                          ],
                        ),
                        Center(
                          child: Visibility(
                            child: Center(child: CircularProgressIndicator()),
                            visible: showloader,
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  void checkValidations(BuildContext context) {
    this.thisText = controler.text;
    print(thisText);
    createComment();
  }

  void createComment() {
    CommentRequest commentRequest = new CommentRequest(
      comment: thisText,
      question_id: widget.postDetailsObj.id, //5d95b9922f2ba612a2f0bf4b
    );
    _baseRepository.createComment(commentRequest).then((onValue) {
      checkResponse(onValue);
    });
  }

  void checkResponse(CommentResponse response) {
    //print(response.data.createdAt);
    Navigator.pop(context);

    setState(() {
      showloader = false;
    });
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
