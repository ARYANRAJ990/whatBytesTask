import 'package:flutter/material.dart';
import 'package:world_of_wood/Utils/Routes/routes_name.dart';
import 'package:world_of_wood/View/Home_view.dart';
import 'package:world_of_wood/View/Splash_view.dart';

import '../../View/Auth_View/Login_View.dart';
import '../../View/Auth_View/Personal_details_add.dart';

class Routes{
  static Route<dynamic> generateRoute (RouteSettings setting) {
    switch (setting.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
        case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
        case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeView());
        case RoutesName.userProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => UserDetailsForm());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('no route'),
            ),
          );
        });
    }
  }
}
