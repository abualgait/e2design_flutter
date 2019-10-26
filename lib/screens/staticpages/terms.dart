import 'package:e2_design/base_widgets/base_network_widgets.dart';
import 'package:e2_design/bloc/change_theme_bloc.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:e2_design/models/terms_response.dart';
import 'package:e2_design/network_manager/api_response.dart';
import 'package:e2_design/network_manager/network_blocs/terms_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  double screenWidth, screenHeight;
  TermsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TermsBloc();
    _bloc.fetchTerms();
  }
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: state.themeData.primaryColor,
                child: RefreshIndicator(
                  onRefresh: () => _bloc.fetchTerms(),
                  child: StreamBuilder<ApiResponse<TermsResponse>>(
                    stream: _bloc.termStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Loading(
                                loadingMessage: snapshot.data.message);
                            break;
                          case Status.COMPLETED:
                            return TermsWidget(
                                respone: snapshot.data.data.data);
                            break;
                          case Status.ERROR:
                            return Error(
                              errorMessage: snapshot.data.message,
                              onRetryPressed: () =>
                                  _bloc.fetchTerms(),
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
}

class TermsWidget extends StatelessWidget {
  final String respone;

  const TermsWidget({Key key, this.respone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child:Text(respone));
        },
      ),
    );
  }
}
