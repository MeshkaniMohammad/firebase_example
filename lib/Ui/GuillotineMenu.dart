import 'dart:math';
import 'package:firebase_example/Ui/about_us.dart';
import 'package:firebase_example/Ui/home.dart';
import 'package:firebase_example/Ui/user_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:firebase_example/Ui/search.dart';



class GuillotinePageRoute<T> extends PageRoute<T> {
  GuillotinePageRoute({
    @required this.builder,
    RouteSettings settings: const RouteSettings(),
    this.maintainState: true,
    bool fullscreenDialog: false,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Color get barrierColor => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw new FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never be null.');
      }
      return true;
    }());
    return result;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    MediaQueryData queryData = MediaQuery.of(context);

    var topInset = queryData.padding.top;

    Offset origin =
        Offset((kToolbarHeight / 2.0), topInset + (kToolbarHeight / 2.0));

    Curve curve = animation.status == AnimationStatus.forward
        ? Curves.bounceOut
        : Curves.bounceIn;
    var rotateTween = new Tween(begin: -pi / 2.0, end: 0.0);

    Cubic opacityCurve = Cubic(0.0, 1.0, 0.0, 1.0);

    return new AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: opacityCurve.transform(animation.value),
          child: Transform(
            transform: Matrix4.identity()
              ..rotateZ(rotateTween.lerp(curve.transform(animation.value))),
            origin: origin,
            child: child,
          ),
        );
      },
    );
  }

  @override
  String get barrierLabel => null;
}

class MenuPage extends StatefulWidget {
  @override
  MenuPageState createState() {
    return new MenuPageState();
  }
}

class MenuPageState extends State<MenuPage> {
  final List<Map> _menus = <Map>[
    {
      "icon": Icons.person,
      "title": "پروفایل",
      "color": Colors.white,
    },
    {
      "icon": Icons.search,
      "title": "جستجو",
      "color": Colors.white,
    },
    {
      "icon": Icons.home,
      "title": "خانه",
      "color": Colors.white,
    },
    {
      "icon": Icons.sentiment_very_satisfied,
      "title": "درباره ما",
      "color": Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "home-page": (context) => Home(),
          "login-page": (context) => UserLoginPage(),
          'about-us': (context) => AboutUs(),
        },
        home: Column(children: [
          AppBar(
            leading: new IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Navigator.pop(context)),
            elevation: 0.0,
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.fromLTRB(50.0, 20.0, 0.0, 0.0),
              width: double.infinity,
              height: double.infinity,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _menus.map((menuItem) {
                  return new ListTile(
                    leading: new IconButton(
                      icon: Icon(menuItem["icon"]),
                      color: menuItem["color"],
                      onPressed: () {
                        if(menuItem["icon"] == Icons.search){
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchList()));
                        }else if(menuItem["icon"] == Icons.sentiment_very_satisfied){
                          Navigator.push(context, MaterialPageRoute(builder: (c) => AboutUs()));
                        }else if(menuItem["icon"] == Icons.home){
                          Navigator.pop(context,MaterialPageRoute(builder: (c) => Home()));
                        }
                      },
                    ),
                    title: new Text(
                      menuItem["title"],
                      style: new TextStyle(
                          color: menuItem["color"], fontSize: 24.0),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
