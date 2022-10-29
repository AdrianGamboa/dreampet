import 'package:flutter/material.dart';
import 'package:social_app_ui/views/widgets/post_item.dart';
import 'package:social_app_ui/util/data.dart';

import '../../util/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

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
              text: "Adopción",
            ),
            Tab(
              text: "Perdidos",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          //TAB 1 - Adopción
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Map post = posts[index];
              return PostItem(
                img: post['img'],
                name: post['name'],
                dp: post['dp'],
                time: post['time'],
              );
            },
          ),
          //TAB 2 - Perdidos
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Map post = posts[index];
              return PostItem(
                img: post['img'],
                name: post['name'],
                dp: post['dp'],
                time: '12/12/22',
              );
            },
          ),
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
}


/*

ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),

*/