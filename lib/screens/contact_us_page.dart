import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/request/contact_us_request.dart';
import 'package:e2_design/models/staticpage_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/terms_bloc.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  double screenWidth, screenHeight;
  StaticBloc _bloc;

  TextEditingController _name_controler = TextEditingController();
  TextEditingController _subject_controler = TextEditingController();
  TextEditingController _email_controler = TextEditingController();
  TextEditingController _message_controler = TextEditingController();

  String thisName = "";
  String thisSubject = "";
  String thisEmail = "";
  String thisMessage = "";

  var showloader = false;
  BuildContext globalContext;

  @override
  void initState() {
    super.initState();
    _bloc = StaticBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
        onPressed: _onpressed,
        icon: Icon(Icons.send),
      )
    ];
    globalContext = context;
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
                  "Contact Us",
//                  AppLocalizations.of(context).translate('app_comments'),
                  state.themeData.textTheme.headline,
                  state.themeData.primaryColor,
                  actions),
              backgroundColor: Colors.white10,
              body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: state.themeData.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    controller: _name_controler,
                                    style: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    controller: _subject_controler,
                                    style: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Subject',
                                      labelStyle: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    controller: _email_controler,
                                    style: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    maxLines: 6,
                                    controller: _message_controler,
                                    style: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Message',
                                      labelStyle: TextStyle(
                                        color:
                                            state.themeData.textTheme.body1.color,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
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
                  )),
            ));
      },
    );
  }

  void _onpressed() {
    this.thisName = _name_controler.text;
    this.thisEmail = _email_controler.text;
    this.thisSubject = _subject_controler.text;
    this.thisMessage = _message_controler.text;

    setState(() {
      showloader = true;
      isOnline().then((onValue) {
        if (onValue) {
          var contactUsRequest = ContactUsRequest(
              subject: thisSubject,
              email: thisEmail,
              name: thisName,
              message: thisMessage);
          _bloc.postContactUs(contactUsRequest);

          StreamSubscription subscription;
          subscription = _bloc.contactusStream.asBroadcastStream().listen((data) {
            switch (data.status) {
              case Status.LOADING:
                break;
              case Status.COMPLETED:
                flushBarUtil(
                    context,
                    "Thanks!",
                    data.data.message,
                    Icon(
                      Icons.contact_mail,
                      color: Colors.blue,
                    ));
                break;
              case Status.ERROR:
                flushBarUtil(
                    context,
                    "Oops!",
                    "Faild to send contact info",
                    Icon(
                      Icons.close,
                      color: Colors.red,
                    ));
                break;
            }
            subscription.cancel();
          });
        } else {

          flushBarUtil(
              globalContext,
              "Oops!",
              "Internet Connection lost",
              Icon(
                Icons.close,
                color: Colors.red,
              ));
        }
        setState(() {
          showloader = false;
        });
      });
    });
  }
}

class TermsWidget extends StatelessWidget {
  final StaticResponse respone;

  const TermsWidget({Key key, this.respone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: respone.data.page_image == null
                          ? ""
                          : respone.data.page_image,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/image_placeholder.png",
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/image_placeholder.png",
                        fit: BoxFit.fill,
                      ),
                      fadeInDuration: Duration(seconds: 1),
                      fadeOutDuration: Duration(seconds: 1),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(respone.data.page_text)
                ],
              ));
        },
      ),
    );
  }
}
/*StreamBuilder<ApiResponse<StaticResponse>>(
                  stream: _bloc.termStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data.message);
                          break;
                        case Status.COMPLETED:
                          return TermsWidget(respone: snapshot.data.data);
                          break;
                        case Status.ERROR:
                          return Error(
                            errorMessage: snapshot.data.message,
                            onRetryPressed: () => _bloc.fetchTerms(),
                          );
                          break;
                      }
                    }
                    return Container();
                  },
                ),*/
