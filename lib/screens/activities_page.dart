import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/activites_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/activites_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ACTIVITY_TYPES { ALL, LIKED, ASKED, ANSWERED }

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  _tabsContent() {
    if (_currentIndex == 0) {
      return Container(child: Text("All Tab"));
    } else if (_currentIndex == 1) {
      return Container(child: Text("Liked Tab"));
    } else if (_currentIndex == 2) {
      return Container(child: Text("Asked Tab"));
    } else if (_currentIndex == 3) {
      return Container(child: Text("Answered Tab"));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    tabs = ['All', 'Liked', 'Asked', 'Answered'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        body: BlocBuilder(
          bloc: changeThemeBloc,
          builder: (BuildContext context, ChangeThemeState state) {
            return Theme(
                data: state.themeData,
                child: Scaffold(
                  body: SafeArea(
                    child: Container(
                      color: state.themeData.primaryColor,
                      child: DefaultTabController(
                        length: tabs.length,
                        child: Scaffold(
                          appBar: TabBar(
                              indicatorColor:
                                  state.themeData.textTheme.body1.color,
                              labelColor: state.themeData.textTheme.body1.color,
                              tabs: tabs.map((e) => Tab(text: e)).toList()),
                          body: TabBarView(children: [
                            Container(child: ActivityTab(ACTIVITY_TYPES.ALL)),
                            Container(child: ActivityTab(ACTIVITY_TYPES.LIKED)),
                            Container(child: ActivityTab(ACTIVITY_TYPES.ASKED)),
                            Container(
                                child: ActivityTab(ACTIVITY_TYPES.ANSWERED))
                          ]),
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}

class ActivityTab extends StatefulWidget {
  @override
  _ActivityTabState createState() => _ActivityTabState();

  ACTIVITY_TYPES activity_types;

  ActivityTab(this.activity_types);
}

class _ActivityTabState extends State<ActivityTab> {
  ActivitiesBloc _bloc;

  get activity_types => widget.activity_types;

  @override
  void initState() {
    super.initState();
    _bloc = ActivitiesBloc();
    _bloc.fetchActivitiesList(activity_types);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        body: BlocBuilder(
          bloc: changeThemeBloc,
          builder: (BuildContext context, ChangeThemeState state) {
            return Theme(
                data: state.themeData,
                child: Scaffold(
                  body: SafeArea(
                    child: Container(
                      color: state.themeData.primaryColor,
                      child: RefreshIndicator(
                        onRefresh: () =>
                            _bloc.fetchActivitiesList(activity_types),
                        child: StreamBuilder<ApiResponse<ActivitesResponse>>(
                          stream: _bloc.activitiesListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return Loading(
                                      loadingMessage: snapshot.data.message);
                                  break;
                                case Status.COMPLETED:
                                  return ActivitesList(
                                      response: snapshot.data.data);
                                  break;
                                case Status.ERROR:
                                  return Error(
                                      errorMessage: snapshot.data.message,
                                      onRetryPressed: () => _bloc
                                          .fetchActivitiesList(activity_types));
                                  break;
                              }
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}

class ActivitesList extends StatelessWidget {
  final ActivitesResponse response;

  const ActivitesList({Key key, this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: response.results.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Container(
                  width: 65,
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: response.results[index].activity_image,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/image_placeholder.png",
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      fadeInDuration: Duration(seconds: 1),
                      fadeOutDuration: Duration(seconds: 1),
                    ),
                  ),
                ),
                title: Text(
                  response.results[index].activity_title,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(response.results[index].activity_time),
                trailing: Text(response.results[index].activity_type),
              ));
        },
      ),
    );
  }
}
