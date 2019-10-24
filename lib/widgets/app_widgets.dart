import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget TrendCard(BuildContext context, var post_txt, var post_location,
    var post_time, var post_img, var post_comments, var post_stars) {
  return Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.network(
          post_img,
          width: 100,
          height: 150.0,
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: 150,
        width: 100,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                post_location,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                    fontFamily: "SF-Pro-Display"),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      )
    ],
  );
}

class PostCard extends StatelessWidget {
  Function onTap;
  var post_txt, post_location, post_time, post_img, post_comments, post_stars;
  BuildContext context;

  PostCard(this.onTap(), this.context, this.post_txt, this.post_location,
      this.post_time, this.post_img, this.post_comments, this.post_stars);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Muhammad"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            post_time,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            post_location,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: true,
                  child: IconButton(
                      onPressed: () {
                        onTap();
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      )),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 300.0,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.4),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0))
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: post_img,
                  placeholder: (context, url) => Image.asset(
                    "assets/images/image_placeholder.png",
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fadeInDuration: Duration(seconds: 1),
                  fadeOutDuration: Duration(seconds: 1),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.send, color: Colors.grey, size: 20),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "5",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.favorite, color: Colors.red, size: 20),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "30",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Icon(Icons.share, color: Colors.grey, size: 20),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            MyPeople(),
            Text(
              post_txt,
            ),
          ],
        ));
  }
}

Widget CommentCard(
    BuildContext context,
    var comment_avatar,
    var comment_name,
    var comment_designation,
    var comment_time,
    var comment_percent,
    var comment_rate,
    var comment_txt,
    var comment_likes,
    var comment_comments,
    var comment_share) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 35,
                      height: 35,
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(comment_avatar)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(comment_name),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          comment_designation,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        comment_share,
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(Icons.star_half, color: Colors.yellow, size: 20),
                    ],
                  ),
                  Text(
                    comment_time,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            comment_txt,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.favorite, color: Colors.red, size: 20),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    comment_likes,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.comment, color: Colors.grey, size: 20),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    comment_comments,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.send, color: Colors.grey, size: 20),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    comment_share,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget MyPeople() {
  return Container(
    width: 75,
    height: 30,
    child: Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            alignment: Alignment.topCenter,
            width: 25.0,
            height: 25.0,
            decoration: new BoxDecoration(
              border: Border.all(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://avatars0.githubusercontent.com/u/38107393?s=460&v=4")),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 12.5,
            ),
            Container(
              alignment: Alignment.topCenter,
              width: 25.0,
              height: 25.0,
              decoration: new BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2, style: BorderStyle.solid),
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        "https://www.theportlandclinic.com/wp-content/uploads/Persons460x360-350x350.jpg")),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 25.0,
            ),
            Container(
              alignment: Alignment.topCenter,
              width: 25.0,
              height: 25.0,
              decoration: new BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2, style: BorderStyle.solid),
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        "https://petrieflom.law.harvard.edu/images/made/82e033b5d85a88b0/Cohen2015_people_300_300_85.jpg")),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
