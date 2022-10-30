import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_app_ui/util/data.dart';

import '../../util/const.dart';

class PostContent extends StatefulWidget {
  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  static Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                names[random.nextInt(10)],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Status should be here",
                style: TextStyle(),
              ),
              SizedBox(height: 20),
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
                    onPressed: () {},
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
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Hola, soy tobi, no tengo un hogar aún, si me quieres adoptar contacte con nostrosos.",
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
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/images/cm8.jpeg",
                      fit: BoxFit.cover,
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
}
