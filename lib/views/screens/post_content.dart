import 'package:flutter/material.dart';
import 'package:social_app_ui/util/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io' show File, Platform;

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/adoptionPostService.dart';
import '../../services/lostPostService.dart';
import '../../util/const.dart';
import '../../util/view_image_handler.dart';
import 'create_post.dart';

class PostContent extends StatefulWidget {
  final String profileImg;
  final List<String> images;

  final User user;
  final Post post;
  final int postType;

  PostContent({
    Key key,
    this.profileImg,
    @required this.images,
    @required this.user,
    @required this.post,
    @required this.postType,
  }) : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  List<Image> _postImages = [];

  @override
  void initState() {
    _loadImages(widget.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.headline6.color),
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            child: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Image.asset(
                    '${Constants.logoWhite}',
                    height: 120,
                  )
                : Image.asset(
                    '${Constants.logoBlack}',
                    height: 120,
                  )),
        centerTitle: true,
        actions: <Widget>[
          widget.user.uid == userFire.uid
              ? PopupMenuButton<int>(
                  tooltip: 'Acciones',
                  itemBuilder: (context) => [
                    // # 1
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Theme.of(context).textTheme.headline6.color),
                          SizedBox(width: 10),
                          Text("Editar", style: TextStyle(color: Theme.of(context).textTheme.headline6.color))
                        ],
                      ),
                    ),
                    // # 2
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.delete,color: Theme.of(context).textTheme.headline6.color),
                          SizedBox(width: 10),
                          Text("Eliminar", style: TextStyle(color: Theme.of(context).textTheme.headline6.color),)
                        ],
                      ),
                    ),
                  ],
                  color: Theme.of(context).primaryColor,
                  elevation: 2,
                  onSelected: (value) async {
                    if (value == 1) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return CreatePost(
                                postType: widget.postType, post: widget.post);
                          },
                        ),
                      ).then((value) => setState(() {}));
                    } else if (value == 2) {
                      if (widget.postType == 0) {
                        await AdoptionPostDB.delete(widget.post);
                      } else if (widget.postType == 0) {
                        await LostPostDB.delete(widget.post);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60),
              CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/profile.jpeg",
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                widget.user.name + " " + widget.user.lastName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.post.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text('Contacto: ' + widget.user.phone),
              SizedBox(height: 10),
              Row(
                //Contact info
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        textStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Llamar",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                    onPressed: () {
                      phoneCall(widget.user.phone);
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    icon: Icon(
                      Icons.whatsapp,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Mensaje",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                    onPressed: () {
                      openWhatsapp(widget.user.phone);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    widget.post.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.all(5),
                itemCount: widget.images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ImageFullScreenWrapperWidget(
                      dark: true,
                      child: _postImages[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadImages(List<String> images) {
    if (images != null) {
      for (var i = 0; i < images.length; i++) {
        _postImages.add(Image.network(
          images[i],
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ));
      }
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  openWhatsapp(num) async {
    if (Platform.isIOS) {
      var whatsUrl = "https://wa.me/$num?text=${Uri.parse("¡Hola!")}";
      if (await canLaunchUrlString(whatsUrl)) {
        await launchUrlString(whatsUrl);
      } else {
        showInSnackBar('Problema al abrir WhatsApp.');
      }
    } else {
      var whatsUrl = "whatsapp://send?phone=" + num + "&text=¡Hola!";
      if (await canLaunchUrlString(whatsUrl)) {
        await launchUrlString(whatsUrl);
      } else {
        showInSnackBar('Problema al abrir WhatsApp.');
      }
    }
  }

  phoneCall(num) async {
    var phoneUrl = Uri(scheme: 'tel', path: num);
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      showInSnackBar('Problema al abrir llamar.');
    }
  }
}
