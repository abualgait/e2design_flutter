import 'package:flutter/material.dart';

Widget buildMainAppBar(
    BuildContext context, var title, TextStyle appbarstyle, Color bgcolor) {
  return AppBar(
    backgroundColor: bgcolor,
    centerTitle: true,
    elevation: 5,
    title: Text(
      // AppLocalizations.of(context).translate('app_title'),
      title,
      style: appbarstyle,
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
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

Widget buildCard(var post_txt, var post_location, var post_time, var post_img,
    var post_comments, var post_stars) {
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
        Image.network(
          post_img,
          fit: BoxFit.fill,
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
                onPressed: () {},
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
