import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/db_helpers/posts_helper.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:sqflite/sqlite_api.dart';

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  PostBloc _bloc;
  DatabaseHelper helper = DatabaseHelper();
  List<Post> postList;
  int count = 0;
  bool insert = false;

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchPostList(),
        child: StreamBuilder<ApiResponse<List<Post>>>(
          stream: _bloc.movieListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
//                  updateListView();
//                  List<Post> concatPostsList = new List.from(snapshot.data.data)
//                    ..addAll(postList);
//                  List<Post> result = concatPostsList.toSet().toList();
                  return PostList(postList: snapshot.data.data, helper: helper);
                  break;
                case Status.ERROR:
                  updateListView();
                  return count == 0
                      ? Error(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => _bloc.fetchPostList(),
                        )
                      : PostList(postList: postList, helper: helper);

                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Post>> postListFuture = helper.getPostList();
      postListFuture.then((postList) {
        setState(() {
          this.postList = postList;
          this.count = postList.length;
        });
      });
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class PostList extends StatefulWidget {
  final List<Post> postList;
  final DatabaseHelper helper;

  const PostList({Key key, this.postList, this.helper}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void _save(List<Post> posts) async {
    await widget.helper.deleteAllPosts();
    widget.helper.insertAllPosts(posts);
  }

  @override
  void initState() {
    super.initState();
    _save(widget.postList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.postList.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildCard(
                widget.postList[index].post_txt,
                widget.postList[index].post_location,
                widget.postList[index].post_time,
                widget.postList[index].post_img,
                widget.postList[index].post_comments,
                widget.postList[index].post_stars));
      },
    );
  }
}
