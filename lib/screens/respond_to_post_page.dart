import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_details_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class RespondToPostPage extends StatefulWidget {
  int _id = 0;

  RespondToPostPage(int id) {
    this._id = id;
  }

  @override
  _RespondToPostPageState createState() => _RespondToPostPageState();
}

class _RespondToPostPageState extends State<RespondToPostPage> {
  Future<File> imageFile;
  PostDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostDetailsBloc();
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
                  onRefresh: () => _bloc.fetchPostDetailsList(widget._id),
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
                                  _bloc.fetchPostDetailsList(widget._id),
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

class PostDetailsWidget extends StatelessWidget {
  final PostDetailsObj postDetailsObj;

  const PostDetailsWidget({Key key, this.postDetailsObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 300.0,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: postDetailsObj.post_img,
            placeholder: (context, url) => Image.asset(
              "assets/images/image_placeholder.png",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
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
                  onPressed: () {},
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                postDetailsObj.post_txt,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on, size: 20),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(postDetailsObj.post_location),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.history, size: 20),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(postDetailsObj.post_time),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        new TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintStyle:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                              hintText: 'Leave your answer here'),
                        ),
                        Container(
                          color: Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.camera_alt),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.image),
                                        onPressed: () {},
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
        )
      ],
    );
  }
}
