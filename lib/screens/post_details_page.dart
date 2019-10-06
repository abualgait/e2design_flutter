import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/post_details_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/post_details_bloc.dart';
import 'package:e2_design/widgets/app_widgets.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsPage extends StatefulWidget {
  int _id = 0;

  PostDetailsPage(int id) {
    this._id = id;
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
                  false,
                  true,
                  context,
                  AppLocalizations.of(context).translate('app_notification'),
                  state.themeData.textTheme.headline,
                  state.themeData.primaryColor),
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
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: TextField(
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    bottom: 11,
                                                    top: 11,
                                                    right: 15),
                                                hintText:
                                                    'Responde to your people'),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FloatingActionButton(
                                          elevation: 5,
                                          onPressed: () {},
                                          backgroundColor: Colors.pink,
                                          child: Icon(Icons.send),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                context,
                postDetailsObj.post_txt,
                postDetailsObj.post_location,
                postDetailsObj.post_time,
                postDetailsObj.post_img,
                postDetailsObj.post_comments,
                postDetailsObj.post_stars);
          } else {
            index = index - 1;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentCard(
                    context,
                    postDetailsObj.comments[index].comment_avatar,
                    postDetailsObj.comments[index].comment_name,
                    postDetailsObj.comments[index].comment_designation,
                    postDetailsObj.comments[index].comment_time,
                    postDetailsObj.comments[index].comment_percent,
                    postDetailsObj.comments[index].comment_rate,
                    postDetailsObj.comments[index].comment_txt,
                    postDetailsObj.comments[index].comment_likes,
                    postDetailsObj.comments[index].comment_comments,
                    postDetailsObj.comments[index].comment_share));
          }
        });
  }
}
