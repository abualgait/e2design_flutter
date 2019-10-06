import 'package:cached_network_image/cached_network_image.dart';
import 'package:e2_design/bloc/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

Widget buildMainAppBar(ChangeThemeState state, bool isTitle, bool isImage,
    BuildContext context, var title, TextStyle appbarstyle, Color bgcolor) {
  return AppBar(
    backgroundColor: bgcolor,
    centerTitle: true,
    elevation: 5,
    title: TitleImageWidget(state, title, isTitle, isImage),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

Widget buildMainAppBarWithActions(
    ChangeThemeState state,
    bool isTitle,
    bool isImage,
    BuildContext context,
    var title,
    TextStyle appbarstyle,
    Color bgcolor,
    List<Widget> actions) {
  return AppBar(
    backgroundColor: bgcolor,
    centerTitle: true,
    elevation: 5,
    title: TitleImageWidget(state, title, isTitle, isImage),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: actions,
  );
}

Widget TitleImageWidget(
    ChangeThemeState state, String title, bool isTitle, bool isImage) {
  if (isImage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset("assets/icon/logo.png"),
    );
  } else {
    return Text(
//                              AppLocalizations.of(context)
//                                  .translate('app_title'),
      title,
      //"E2 Design",
      style: state.themeData.textTheme.headline,
    );
  }
}

Widget buildFlatButtonWidget(Color color, String txt) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
    child: FlatButton(
      color: color,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0)),
      onPressed: () {},
      textColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(txt),
      ),
    ),
  );
}

Widget buildOutlinedButtonWidget(Color btn_color, Color txt_color, String txt) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
    child: OutlineButton(
      color: btn_color,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0)),
      onPressed: () {},
      textColor: txt_color,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(txt),
      ),
    ),
  );
}

Widget menuRow(int index, var iconsArray, var textArray) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[iconsArray[index], textArray[index]],
            ),
          ),
        ),
      ),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[iconsArray[index + 1], textArray[index + 1]],
            ),
          ),
        ),
      )
    ],
  );
}

Widget buildCard(BuildContext context, var post_txt, var post_location,
    var post_time, var post_img, var post_comments, var post_stars) {
  return Card(
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(post_txt)),
              Icon(Icons.flag)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(post_location)
                ],
              ),
              Row(
                children: <Widget>[Text(post_time), Icon(Icons.access_time)],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: post_img,
            placeholder: (context, url) =>
                Center(child: new CircularProgressIndicator()),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fadeInDuration: Duration(seconds: 1),
            fadeOutDuration: Duration(seconds: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                onPressed: () {},
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                textColor: Colors.white,
                label: Text(
                  post_comments,
                ),
              ),
              FlatButton.icon(
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                onPressed: () {},
                icon: Icon(
                  Icons.star_border,
                  color: Colors.white,
                ),
                textColor: Colors.white,
                label: Text(
                  post_stars,
                ),
              ),
              FlatButton(
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                onPressed: () {
                  Share.share('check out my website https://example.com');
                },
                textColor: Colors.white,
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildNotification(var post_title, var post_body) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post_title,
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post_body,
            )),
      ],
    ),
  );
}
