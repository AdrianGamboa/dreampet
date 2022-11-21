import 'package:flutter/material.dart';

import '../screens/post_content.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final List<String> images;
  final String description;
  final String title;

  PostItem(
      {Key key,
      @required this.dp,
      @required this.name,
      @required this.time,
      @required this.images,
      @required this.description,
      @required this.title})
      : super(key: key);
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
              title: Column(
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(
                        "${widget.name}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${widget.title}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            Image.network(
              widget.images[0],
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.description}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                return PostContent(
                    name: widget.name,
                    images: widget.images,
                    title: widget.title,
                    description: widget.description);
              },
            ),
          );
        },
      ),
    );
  }
}
