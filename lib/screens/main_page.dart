import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/database_helpers/posts_helper.dart';
import 'package:e2_design/models/post_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_bloc.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  _save(snapshot.data.data);
                  return PostList(postList: snapshot.data.data);
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
    );
  }

  @override
  void dispose() {
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

class PostList extends StatelessWidget {
  final List<Post> postList;

  const PostList({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildCard(
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
