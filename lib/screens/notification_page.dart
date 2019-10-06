import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/language_manager/AppLocalizations.dart';
import 'package:e2_design/models/notifications_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/notification_bloc.dart';
import 'package:e2_design/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = NotificationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Scaffold(
//              appBar: buildMainAppBar(
//                  context,
//                  AppLocalizations.of(context).translate('app_notification'),
//                  state.themeData.textTheme.headline,
//                  state.themeData.primaryColor),
//              backgroundColor: Colors.white10,
              body: Container(
                color: state.themeData.primaryColor,
                child: RefreshIndicator(
                  onRefresh: () => _bloc.fetchNotificationList(),
                  child: StreamBuilder<ApiResponse<List<NotificationObj>>>(
                    stream: _bloc.notificationListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Loading(
                                loadingMessage: snapshot.data.message);
                            break;
                          case Status.COMPLETED:
                            return NotificationList(
                                notiList: snapshot.data.data);
                            break;
                          case Status.ERROR:
                            return Error(
                              errorMessage: snapshot.data.message,
                              onRetryPressed: () =>
                                  _bloc.fetchNotificationList(),
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

class NotificationList extends StatelessWidget {
  final List<NotificationObj> notiList;

  const NotificationList({Key key, this.notiList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: notiList.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildNotification(
                  notiList[index].noti_title, notiList[index].noti_body));
        },
      ),
    );
  }
}
