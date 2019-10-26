import 'dart:async';

import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/db_helpers/posts_helper.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_bloc.dart';
import 'package:e2_design/screens/post_details_page.dart';
import 'package:e2_design/widgets/app_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sqflite/sqflite.dart';

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
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
    _bloc = PostBloc();
    //startTimer();
    postList = List<Post>();
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
                              maxPagesNumber = snapshot.data.data.pages;
                              postList.addAll(snapshot.data.data.results);
                              //_save(postList);
                              print("after add all: " +
                                  postList.length.toString());
                              return PostList(page, maxPagesNumber,
                                  postList: postList,
                                  controller: _scrollController);
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

class PostList extends StatelessWidget {
  final List<Post> postList;
  final ScrollController controller;

  final int currentpage;
  final int maxpage;

  const PostList(this.currentpage, this.maxpage,
      {Key key, this.postList, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postList.length + 1,
      controller: controller,
      itemBuilder: (context, index) {
        if (index == postList.length) {
          if (this.currentpage >= maxpage)
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
                    builder: (context) => PostDetailsPage(postList[index].uid)),
              );
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostCard(
                    () => {flagSelected(index, context)},
                    context,
                    postList[index].post_txt,
                    postList[index].post_location,
                    postList[index].post_time,
                    postList[index].post_img,
                    "",
                    "")));
      },
    );
  }

  flagSelected(int newIndex, BuildContext context) {
    var choice1 = AppLocalizations.of(context)
        .translate('report_sexual_or_immoral_content');
    var choice2 = AppLocalizations.of(context)
        .translate('report_stupid_not_relevant_question');
    var choice3 =
        AppLocalizations.of(context).translate('report_spam_or_misleading');
    var choice4 = AppLocalizations.of(context)
        .translate('report_illegal_or_prohibited_items');
    var choice5 = AppLocalizations.of(context)
        .translate('report_hatful_or_abuse_content');

    var reports = [choice1, choice2, choice3, choice4, choice5];

    showDialog(
      context: context,
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

                                  break;

                                case 1:
                                  print(reports[index]);
                                  break;

                                case 2:
                                  print(reports[index]);
                                  break;

                                case 3:
                                  print(reports[index]);
                                  break;
                              }

                              Navigator.pop(context);
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
  }
}
