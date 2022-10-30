import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_app_ui/views/widgets/post_item.dart';
import '../../services/adoptionPostService.dart';
import '../../services/lostPostService.dart';
import '../../util/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List postsAdoptionList = [];
  List postsLostList = [];

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
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
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
          postFutureBuilder(AdoptionPostDB.getDocuments(), postsAdoptionList),
          //TAB 2 - Perdidos
          postFutureBuilder(LostPostDB.getDocuments(), postsLostList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget postFutureBuilder(_future, list) => FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
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
            img: "assets/images/cm8.jpeg",
            name: list[index][1]['name'] + " " + list[index][1]['lastName'],
            dp: "assets/images/cm${Random().nextInt(10)}.jpeg",
            time: list[index][0]['publishedDate'],
            description: list[index][0]['description'],
          );
        },
      );
}
