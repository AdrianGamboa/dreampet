import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io' show File, Platform;

import '../../util/const.dart';
import '../../util/view_image_handler.dart';

class PostContent extends StatefulWidget {
  final String profileImg;
  final String name;
  final String time;
  final List<String> images;
  final String description;
  final String title;

  PostContent(
      {Key key,
      /*@required*/ this.profileImg,
      /*@required*/ this.name,
      /*@required*/ this.time,
      /*@required*/ this.images,
      /*@required*/ this.description,
      /*@required*/ this.title})
      : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  static Random random = Random();
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
                  "assets/images/cm${random.nextInt(10)}.jpeg",
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                widget.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text('Contacto: ' + '+50686949588'),
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
                      phoneCall('+50686949588');
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
                      openWhatsapp('+50686949588');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )),
              SizedBox(height: 20),
              // GridView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   primary: false,
              //   padding: EdgeInsets.all(5),
              //   itemCount: 8,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     childAspectRatio: 200 / 200,
              //   ),
              //   itemBuilder: (BuildContext context, int index) {
              //     return Padding(
              //       padding: EdgeInsets.all(5.0),
              //       child: Image.asset(
              //         "assets/images/cm8.jpeg",
              //         fit: BoxFit.cover,
              //       ),
              //     );
              //   },
              // ),
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
