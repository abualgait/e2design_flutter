import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/staticpage_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/terms_bloc.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum STATICPAGES { ABOUT, TERMS, PRIVACY }

class StaticPages extends StatefulWidget {
  STATICPAGES type;

  StaticPages(this.type);

  @override
  _StaticPagesState createState() => _StaticPagesState();
}

class _StaticPagesState extends State<StaticPages> {
  double screenWidth, screenHeight;
  TermsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TermsBloc();
    loadWhichPage(widget.type);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  loadWhichPage(STATICPAGES type) {
    switch (type) {
      case STATICPAGES.ABOUT:
        _bloc.fetchAboutUs();
        break;
      case STATICPAGES.TERMS:
        _bloc.fetchTerms();
        break;
      case STATICPAGES.PRIVACY:
        _bloc.fetchPrivacy();
        break;
    }
  }

  String loadPageTitle(STATICPAGES type) {
    String title = "";
    switch (type) {
      case STATICPAGES.ABOUT:
        title = "About Us";
        break;
      case STATICPAGES.TERMS:
        title = "Terms and Conditions";
        break;
      case STATICPAGES.PRIVACY:
        title = "Privacy Policy";
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Scaffold(
              appBar: buildMainAppBar(
                  state,
                  true,
                  false,
                  context,
                  loadPageTitle(widget.type),
//                  AppLocalizations.of(context).translate('app_comments'),
                  state.themeData.textTheme.headline,
                  state.themeData.primaryColor),
              backgroundColor: Colors.white10,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: state.themeData.primaryColor,
                child: StreamBuilder<ApiResponse<StaticResponse>>(
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
                            onRetryPressed: () => loadWhichPage(widget.type),
                          );
                          break;
                      }
                    }
                    return Container();
                  },
                ),
              ),
            ));
      },
    );
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
