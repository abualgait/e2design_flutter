import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/onboarding_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/onboarding_bloc.dart';
import 'package:e2_design/utils/page_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_text/gradient_text.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  OnBoardingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = OnBoardingBloc();
    _bloc.fetchOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Scaffold(
              body: Container(
                color: state.themeData.primaryColor,
                child: RefreshIndicator(
                  onRefresh: () => _bloc.fetchOnBoarding(),
                  child: StreamBuilder<ApiResponse<OnBoardingResponse>>(
                    stream: _bloc.boardStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Splash(
                                loadingMessage: snapshot.data.message);
                            break;
                          case Status.COMPLETED:
                            return BoardingWidget(
                                pageList: snapshot.data.data.results);
                            break;
                          case Status.ERROR:
                            return Error(
                              errorMessage: snapshot.data.message,
                              onRetryPressed: () => _bloc.fetchOnBoarding(),
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

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class BoardingWidget extends StatefulWidget {
  final List<OnBoard> pageList;

  const BoardingWidget({Key key, this.pageList}) : super(key: key);

  @override
  _BoardingWidgetState createState() => _BoardingWidgetState();
}

class _BoardingWidgetState extends State<BoardingWidget>
    with TickerProviderStateMixin {
  PageController _controller;

  int currentPage = 0;

  bool lastPage = false;

  AnimationController animationController;

  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<List<Color>> gradients = [
    [Color(0xFF9708CC), Color(0xFF43CBFF)],
    [Color(0xFFE2859F), Color(0xFFFCCF31)],
    [Color(0xFF5EFCE8), Color(0xFF736EFE)],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: widget.pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (currentPage == widget.pageList.length - 1) {
                    lastPage = true;
                    animationController.forward();
                  } else {
                    lastPage = false;
                    animationController.reset();
                  }
                  print(lastPage);
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    var page = widget.pageList[index];
                    var delta;
                    var y = 1.0;

                    if (_controller.position.haveDimensions) {
                      delta = _controller.page - index;
                      y = 1 - delta.abs().clamp(0.0, 1.0);
                    }
                    return Stack(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: page.image == null ? "" : page.image,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/image_placeholder.png",
                              fit: BoxFit.fitWidth,
                            ),
                            fadeInDuration: Duration(seconds: 1),
                            fadeOutDuration: Duration(seconds: 1),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            margin: EdgeInsets.only(left: 12.0, bottom: 60),
                            height: 100.0,
                            child: Stack(
                              children: <Widget>[
//                              Opacity(
//                                opacity: .10,
//                                child: GradientText(
//                                  page.quote,
//                                  gradient:
//                                      LinearGradient(colors: gradients[0]),
//                                  style: TextStyle(
//                                      fontSize: 35.0,
//                                      fontFamily: "Montserrat-Black",
//                                      letterSpacing: 1.0),
//                                ),
//                              ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 25.0, left: 22.0),
                                  child: GradientText(
                                    page.quote,
                                    gradient:
                                        LinearGradient(colors: gradients[2]),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: "Montserrat-Black",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 34.0, top: 12.0),
//                          child: Transform(
//                            transform:
//                                Matrix4.translationValues(0, 50.0 * (1 - y), 0),
//                            child: Text(
//                              page.quote,
//                              style: TextStyle(
//                                  fontSize: 20.0,
//                                  fontFamily: "Montserrat-Medium",
//                                  color: Color(0xFF9B9B9B)),
//                            ),
//                          ),
//                        )
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              left: 30.0,
              bottom: 55.0,
              child: Container(
                  width: 160.0,
                  child: PageIndicator(currentPage, widget.pageList.length)),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/landing", (r) => false);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
