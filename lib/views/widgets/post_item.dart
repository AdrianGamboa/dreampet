import 'package:flutter/material.dart';

import '../screens/post_content.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String description;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.description,
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            Image.asset(
              "${widget.img}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.description}",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return PostContent();
              },
            ),
          );
        },
      ),
    );
  }
}
