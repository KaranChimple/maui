import 'dart:io';
import 'package:maui/db/entity/user.dart';
import 'package:maui/quack/user_collection.dart';
import 'package:maui/quack/user_drawing_grid.dart';
import 'package:maui/quack/user_progress.dart';
import '../loca.dart';
import 'package:flutter/material.dart';
import '../state/app_state_container.dart';
import 'package:maui/components/camera.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  List<String> categories = ["gallery", "collection", "progress"];
  TabController tabController;
  String userName;
  bool setflag = false;

  @override
  void initState() {
    super.initState();
    print("Welcome to QuizProgressTracker class");
    tabController = new TabController(length: categories.length, vsync: this);
  }

  getImage(BuildContext context) async {
    setState(() {
      imagePathStore = '';
    });

 Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new CameraScreen(true)),
            );
    // imagePathStore = "assets/solo.png" ;
  }

  Widget getTabBar() {
    return TabBar(
        isScrollable: false,
        indicatorColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 5.0,
        labelColor: Colors.black,
        labelStyle: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
        controller: tabController,
        tabs: [
          new Tab(text: Loca.of(context).gallery),
          new Tab(text: Loca.of(context).collection),
          new Tab(text: Loca.of(context).progress),
        ]);
  }

  Widget getTabBarPages(BuildContext context) {
    return Expanded(
      child: TabBarView(controller: tabController, children: <Widget>[
        UserDrawingGrid(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),
        UserCollection(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),
        UserProgress(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    var user = AppStateContainer.of(context).state.loggedInUser;
    final TextEditingController _textController = new TextEditingController();
    final stackChildren = <Widget>[
      new Container(
          height: 125.0,
          width: 125.0,
          decoration: new BoxDecoration(
              border: new Border.all(width: 3.0, color: Colors.blueAccent),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  image: new FileImage(new File(user.image)),
                  fit: BoxFit.fill))),
      Positioned(
        right: 1.0,
        bottom: -19.0,
        child: CircleAvatar(
          radius: 30.0,
          child: Center(
            child: new IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () => getImage(context),
            ),
          ),
        ),
      )
    ];

    final stackTextField = <Widget>[
      Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: media.size.width,
            height: media.size.height * .05,
            color: Colors.white,
            child: Center(
              child: new Text(
                "${user.name}",
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      Positioned(
        right: 1.0,
        bottom: -1.0,
        child: Center(
          child: new IconButton(
            // color: Colors.transparent,
            icon: Icon(
              Icons.edit,
              color: Colors.teal,
              size: 30.0,
            ),
            onPressed: () {
              setState(() {
                setflag = true;
              });
            },
          ),
        ),
      )
    ];

    final stackHeader = Stack(
      children: stackChildren,
      overflow: Overflow.visible,
    );
    final stackText = Stack(
      children: stackTextField,
      overflow: Overflow.visible,
    );
    return Scaffold(
      body: SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            stackHeader,
            new SizedBox(height: 45.0),
            stackText,
            getTabBar(),
            getTabBarPages(context),
            setflag == true
                ? Row(
                    children: <Widget>[
                      Flexible(
                        child: new TextField(
                          // focusNode: _focusName,
                          autocorrect: false,
                          autofocus: true,
                          textInputAction: TextInputAction.none,
                          onSubmitted: _submit(userName),
                          onChanged: _onTyping,
                          controller: _textController,
                          decoration: new InputDecoration(
                            labelStyle: TextStyle(color: Colors.red),
                            isDense: true,
                            border: const OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0)),
                                borderSide: const BorderSide(
                                    style: BorderStyle.solid,
                                    width: 100.0,
                                    color: Colors.amber)),
                            hintText: Loca.of(context).writeYourName,
                          ),
                        ),
                      ),
                      Container(
                          margin: new EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            color: Colors.black,
                            icon: new Icon(
                              Icons.send,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              editbutton(user);
                            },
                          )),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _onTyping(String name) {
    userName = name;
  }

  _submit(String name) {
    print('called on submit $name');
    setState(() {
      userName = name;
      // setflag = false;
    });
  }

  void editbutton(User user) {
    if (user.name != null && userName != '' && userName != null) {
      setState(() {
        user.name = userName;
        setflag = false;
      });
    }
  }
}
