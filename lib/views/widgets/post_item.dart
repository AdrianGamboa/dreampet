import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app_ui/models/post.dart';
import 'package:social_app_ui/models/user.dart';

import '../screens/post_content.dart';

class PostItem extends StatefulWidget {
  
  final String dp;
  final List<String> images;
  
  final User user;
  final Post post;
  final int postType;
  final Function() notifyParent;

  PostItem({
    Key key,
    @required this.dp,
    @required this.images,
    @required this.user,
    @required this.post,
    @required this.postType,
    @required this.notifyParent,
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
              title: Column(
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(
                        "${widget.user.name + " " + widget.user.lastName}",
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
                          "${widget.post.title}",
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
                "${DateFormat.yMMMd().format(widget.post.publishedDate.toLocal())}",
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
                "${widget.post.description}",
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
                  images: widget.images,
                  user: widget.user,
                  post: widget.post,
                  postType: widget.postType,
                );
              },
            ),
          ).then((value) => widget.notifyParent());
        },
      ),
    );
  }
}
