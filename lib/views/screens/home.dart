import 'dart:math';
import 'package:flutter/material.dart';
import 'package:social_app_ui/views/screens/create_post.dart';
import 'package:social_app_ui/views/widgets/post_item.dart';
import '../../services/AuthenticationService.dart';
import '../../services/adoptionPostService.dart';
import '../../services/lostPostService.dart';
import '../../util/const.dart';
import 'package:intl/intl.dart';

import '../../util/router.dart';
import 'auth/login.dart';
import 'introduction_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final descriptionTextController = TextEditingController();
  TabController _tabController;
  List postsAdoptionList = [];
  List postsLostList = [];
  bool update = false;
  int tabIndx = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Image.asset(
                    '${Constants.logoWhite}',
                    height: 120,
                  )
                : Image.asset(
                    '${Constants.logoBlack}',
                    height: 120,
                  )),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            icon: Icon(
              Icons.filter_list,
            ),
            itemBuilder: (BuildContext context) {
              return {'Prólogo', 'Cerrar sesión'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
          unselectedLabelColor: Colors.grey[600],
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "Animales en adopción",
            ),
            Tab(
              text: "Animales perdidos",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          //TAB 1 - Adopción
          postFutureBuilder(
              AdoptionPostDB.getDocuments(), postsAdoptionList, 0),
          //TAB 2 - Perdidos
          postFutureBuilder(LostPostDB.getDocuments(), postsLostList, 1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CreatePost(postType: tabIndx);
              },
            ),
          ).then((value) => setState(() {}));
        },
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Prólogo':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => IntroductionScreenPage(intro: false)));
        break;
      case 'Cerrar sesión':
        AuthenticationService()
            .signOut(context)
            .then((value) => Navigate.pushPageReplacement(context, Login()))
            .onError((error, stackTrace) => setState(() {}));
        break;
    }
  }

  Widget postFutureBuilder(_future, list, indx) => FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        tabIndx = indx;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator
          return Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            // Return error
            return const Center(child: Text('Error al extraer la información'));
          } else {
            list = snapshot.data as List;
            if (list.isEmpty) {
              return const Center(child: Text('Sin información disponible'));
            } else {
              return buildPost(list);
            }
          }
        }
      });

  Widget buildPost(list) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return PostItem(
            images: list[index][0]['images'].cast<String>(),
            name: list[index][1]['name'] + " " + list[index][1]['lastName'],
            dp: "assets/images/cm${Random().nextInt(10)}.jpeg",
            time: DateFormat.yMMMd()
                .format(list[index][0]['publishedDate'].toLocal()),
            description: list[index][0]['description'],
            phone: list[index][1]['phone'],
            title: list[index][0]['title'],
          );
        },
      );
}
