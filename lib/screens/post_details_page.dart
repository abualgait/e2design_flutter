import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_details_bloc.dart';
import 'package:e2_design/screens/respond_to_post_page.dart';
import 'package:e2_design/widgets/app_widgets.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  String uid = "";

  PostDetailsPage(String id) {
    this.uid = id;
  }

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  PostDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostDetailsBloc();
    _bloc.fetchPostDetailsList(widget.uid);
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
                  AppLocalizations.of(context).translate('app_comments'),
                  state.themeData.textTheme.headline,
                  state.themeData.primaryColor),
              backgroundColor: Colors.white10,
              floatingActionButton: FloatingActionButton(
                elevation: 5,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RespondToPostPage(widget.uid)),
                  );
                },
                backgroundColor: state.themeData.textTheme.body1.color,
                child: Icon(Icons.send),
              ),
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

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class PostDetailsWidget extends StatelessWidget {
  final PostDetailsObj postDetailsObj;

  const PostDetailsWidget({Key key, this.postDetailsObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: postDetailsObj.comments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PostCard(
                null,
                null,
                null,
                context,
                postDetailsObj.post_txt,
                postDetailsObj.post_location,
                postDetailsObj.post_time,
                postDetailsObj.post_img,
                "",
                0,
                false);
          } else {
            index = index - 1;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentCard(
                    context,
                    "",
                    "",
                    "",
                    postDetailsObj.comments[index].createdAt,
                    "",
                    "",
                    postDetailsObj.comments[index].comment,
                    "",
                    "",
                    ""));
          }
        });
  }
}
