import 'dart:async';

import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/db_helpers/posts_helper.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_bloc.dart';
import 'package:e2_design/screens/post_details_page.dart';
import 'package:e2_design/widgets/app_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) =>
          setState(
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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: OfflineBuilder(
          debounceDuration: Duration.zero,
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity,
              Widget child,) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (!connected) {
              // _bloc.fetchPostList();
              ishideconnectivity = true;
            }else{
              startTimer();
            }
            return new Column(
              children: [
                Visibility(
                  visible:ishideconnectivity,
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Center(child: Text('ONLINE')),
                                color: Color(0xFF00EE44)),
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
                    onRefresh: () => _bloc.fetchPostList(),
                    child: StreamBuilder<ApiResponse<List<Post>>>(
                      stream: _bloc.movieListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Loading(
                                  loadingMessage: snapshot.data.message);
                              break;
                            case Status.COMPLETED:
                              _save(snapshot.data.data);
                              return PostList(
                                postList: snapshot.data.data,
                              );
                              break;
                            case Status.ERROR:
                              if (postList == null) {
                                postList = List<Post>();
                                updateListView();
                              }
                              print("list of posts: " + count.toString());
                              if (count == 0) {
                                return Error(
                                  errorMessage: snapshot.data.message,
                                  onRetryPressed: () => _bloc.fetchPostList(),
                                );
                              } else {
                                return PostList(postList: postList);
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
    await helper.deleteAllPosts();
    for (int i = 0; i <= posts.length; i++) {
      await helper.insertPost(posts[i]);
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

class TrendingList extends StatelessWidget {
  final List<Post> postList;

  const TrendingList({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TrendCard(
                context,
                postList[index].post_txt,
                postList[index].post_location,
                postList[index].post_time,
                postList[index].post_img,
                postList[index].post_comments,
                postList[index].post_stars));
      },
    );
  }
}

class PostList extends StatelessWidget {
  final List<Post> postList;

  const PostList({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailsPage(postList[index].id)),
            );
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostCard(
                  context,
                  postList[index].post_txt,
                  postList[index].post_location,
                  postList[index].post_time,
                  postList[index].post_img,
                  postList[index].post_comments,
                  postList[index].post_stars)),
        );
      },
    );
  }
}
