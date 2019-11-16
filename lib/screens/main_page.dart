import 'dart:async';
import 'dart:convert';

import 'package:e2_design/base_classes/shaerd_prefs_helper.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/constvalue/const_value.dart';
import 'package:e2_design/db_helpers/posts_helper.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/models/request/like_request.dart';
import 'package:e2_design/models/request/report_request.dart';
import 'package:e2_design/models/user_data_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_bloc.dart';
import 'package:e2_design/screens/post_details_page.dart';
import 'package:e2_design/utils/Utils.dart';
import 'package:e2_design/widgets/app_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

import 'home.dart';

class MainBody extends StatefulWidget implements IsReload {
  bool isReload;

  MainBody(this.isReload);

  @override
  _MainBodyState createState() => _MainBodyState();

  @override
  void reloadData() {
    print("---------------state created---------------");
  }
}

class _MainBodyState extends State<MainBody> {
  PostBloc _bloc;
  DatabaseHelper helper = DatabaseHelper();
  List<Post> postList;
  int count = 0;

  Timer _timer;
  int _start = 10;
  bool ishideconnectivity = true;

  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  int page = 0;
  int maxPagesNumber = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              ishideconnectivity = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    checkValidations();
  }

  void checkValidations() {
    _bloc = PostBloc();
    //startTimer();
    postList = List<Post>();
    postList.clear();
    _bloc.fetchPostList(true, page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page <= maxPagesNumber) {
          page++;
          _bloc.fetchPostList(false, page);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: OfflineBuilder(
          debounceDuration: Duration.zero,
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (!connected) {
              // _bloc.fetchPostList();
              ishideconnectivity = true;
            } else {
              //startTimer();
            }
            return new Column(
              children: [
                Visibility(
                  visible: ishideconnectivity,
                  child: SizedBox(
                    height: 24.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
//                      color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                          child: connected
                              ? Visibility(
                                  visible: ishideconnectivity,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                          child: Text(
                                        'ONLINE',
                                      )),
                                      color: Colors.transparent),
                                )
                              : Container(
                                  color: Color(0xFFEE4400),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(child: Text('OFFLINE')),
                                      SizedBox(width: 8.0),
                                      SizedBox(
                                        width: 12.0,
                                        height: 12.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      postList.clear();
                      page = 0;
                      return _bloc.fetchPostList(true, page);
                    },
                    child: StreamBuilder<ApiResponse<PostResponse>>(
                      stream: _bloc.movieListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Loading(
                                  loadingMessage: snapshot.data.message);
                              break;
                            case Status.COMPLETED:
                              print("completed");
                              //        postList.clear();
                              maxPagesNumber = snapshot.data.data.pages;
                              postList.addAll(snapshot.data.data.results);
                              //_save(postList);
                              print("after add all: " +
                                  postList.length.toString());
                              return PostList(page, maxPagesNumber,
                                  postList: postList,
                                  controller: _scrollController,
                                  bloc: _bloc);
                              break;
                            case Status.ERROR:
                              updateListView();
                              print("list of posts: " + count.toString());
                              if (count == 0) {
                                return Error(
                                  errorMessage: snapshot.data.message,
                                  onRetryPressed: () =>
                                      _bloc.fetchPostList(true, page),
                                );
                              } else {
                                return PostList(page, maxPagesNumber,
                                    postList: postList,
                                    controller: _scrollController);
                              }

                              break;
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          child: Container()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _bloc.dispose();
    super.dispose();
  }

  void _save(List<Post> posts) async {
    // await helper.deleteAllPosts();
    for (int i = 0; i <= posts.length; i++) {
      await helper.updatePost(posts[i]);
    }
    print("list of offline: " + posts.length.toString());
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Post>> postListFuture = helper.getPostList();
      postListFuture.then((postList) {
        setState(() {
          this.postList = postList;
          this.count = postList.length;
          print("list of update: " + postList.length.toString());
        });
      });
    });
  }
}

class PostList extends StatefulWidget {
  final List<Post> postList;
  final ScrollController controller;
  final PostBloc bloc;

  final int currentpage;
  final int maxpage;

  const PostList(this.currentpage, this.maxpage,
      {Key key, this.postList, this.controller, this.bloc})
      : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.postList.length + 1,
      controller: widget.controller,
      itemBuilder: (context, index) {
        if (index == widget.postList.length) {
          if (this.widget.currentpage >= widget.maxpage)
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'No More Data',
                  )),
                  color: Colors.transparent),
            );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostDetailsPage(widget.postList[index].uid)),
              );
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostCard(
                    () => {
                          flagSelected(index, context, widget.bloc,
                              widget.postList[index])
                        }, () {
                  //change false to value from api
                  LikeUnlikSelected(
                      index,
                      context,
                      index % 2 == 0 ? true : false,
                      widget.postList[index],
                      widget.bloc);
                },
                    () => {
                          Share.share(
                              ' ' + widget.postList[index].post_txt + '')
                        },
                    context,
                    widget.postList[index].post_txt,
                    widget.postList[index].post_location,
                    widget.postList[index].post_time,
                    widget.postList[index].post_img,
                    "",
                    widget.postList[index].post_stars,
                    index % 2 == 0 ? true : false)));
      },
    );
  }

  LikeUnlikSelected(int newIndex, BuildContext context, bool isLiked, Post post,
      PostBloc bloc) async {
    UserData userData;
    SharedPreferencesHelper.getSession(Constants.USERDATA).then((onValue) {
      Map userMap = jsonDecode(onValue);
      userData = UserData.fromJson(userMap);
      if (!isLiked) {
        //call like api
        var likeRequest =
            LikeRequest(question_id: post.id, user_id: userData.id);
        bloc.likePost(likeRequest);
        StreamSubscription subscription;
        subscription = bloc.likeStream.asBroadcastStream().listen((data) {
          switch (data.status) {
            case Status.LOADING:
              break;
            case Status.COMPLETED:
              flushBarUtil(
                  context,
                  "Congracts!",
                  "Added to liked questions",
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ));
              break;
            case Status.ERROR:
              flushBarUtil(
                  context,
                  "Oops!",
                  "Faild to add question to likes",
                  Icon(
                    Icons.close,
                    color: Colors.red,
                  ));
              break;
          }
          subscription.cancel();
        });
      } else {
        //call unlike api

        bloc.unlikePost(post.uid);
        StreamSubscription subscription;
        subscription = bloc.unlikeStream.asBroadcastStream().listen((data) {
          switch (data.status) {
            case Status.LOADING:
              break;
            case Status.COMPLETED:
              flushBarUtil(
                  context,
                  "Congracts!",
                  "Added to liked questions",
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ));

              break;
            case Status.ERROR:
              flushBarUtil(
                  context,
                  "Oops!",
                  "Faild to add question to likes",
                  Icon(
                    Icons.close,
                    color: Colors.red,
                  ));
              break;
          }
          subscription.cancel();
        });
      }
    });
  }

  flagSelected(
      int newIndex, BuildContext buildContext, PostBloc bloc, Post post) {
    var choice1 = AppLocalizations.of(buildContext)
        .translate('report_sexual_or_immoral_content');
    var choice2 = AppLocalizations.of(buildContext)
        .translate('report_stupid_not_relevant_question');
    var choice3 = AppLocalizations.of(buildContext)
        .translate('report_spam_or_misleading');
    var choice4 = AppLocalizations.of(buildContext)
        .translate('report_illegal_or_prohibited_items');
    var choice5 = AppLocalizations.of(buildContext)
        .translate('report_hatful_or_abuse_content');

    var reports = [choice1, choice2, choice3, choice4, choice5];
    UserData userData;
    SharedPreferencesHelper.getSession(Constants.USERDATA).then((onValue) {
      Map userMap = jsonDecode(onValue);
      userData = UserData.fromJson(userMap);
      var reason = "";
      showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return BlocBuilder(
              bloc: changeThemeBloc,
              builder: (BuildContext context, ChangeThemeState state) {
                return AlertDialog(
                  backgroundColor: state.themeData.primaryColor,
                  title: Text(
                    'Report Question',
                    style: state.themeData.textTheme.body1,
                  ),
                  content: SizedBox(
                    height: 200,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            child: InkWell(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(reports[index],
                                    style: state.themeData.textTheme.body2),
                              ),
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    print(reports[index]);
                                    reason = reports[index];
                                    break;

                                  case 1:
                                    print(reports[index]);
                                    reason = reports[index];
                                    break;

                                  case 2:
                                    print(reports[index]);
                                    reason = reports[index];
                                    break;

                                  case 3:
                                    print(reports[index]);
                                    reason = reports[index];
                                    break;
                                }
                                Navigator.pop(context);
                                var reportRequest = ReportRequest(
                                    user_id: userData.id,
                                    question_id: post.id,
                                    comment_id: "",
                                    reason: reason);
                                bloc.sendReport(reportRequest);

                                StreamSubscription subscription;
                                subscription = bloc.reportStream
                                    .asBroadcastStream()
                                    .listen((data) {
                                  switch (data.status) {
                                    case Status.LOADING:
                                      break;
                                    case Status.COMPLETED:
                                      flushBarUtil(
                                          buildContext,
                                          "Thanks!",
                                          data.data.message,
                                          Icon(
                                            Icons.check,
                                            color: Colors.greenAccent,
                                          ));

                                      break;
                                    case Status.ERROR:
                                      flushBarUtil(
                                          buildContext,
                                          "Oops!",
                                          "Faild to report this question",
                                          Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ));
                                      break;
                                  }
                                  subscription.cancel();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              });
        },
      );
    });
  }
}
