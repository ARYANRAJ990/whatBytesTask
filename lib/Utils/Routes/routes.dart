import 'package:flutter/material.dart';
import 'package:world_of_wood/Utils/Routes/routes_name.dart';
import 'package:world_of_wood/View/Home/notes_feed_page.dart';
import 'package:world_of_wood/View/Home/Points_Redeemption_View.dart';
import 'package:world_of_wood/View/Navbar_view/terms_and_conditions_view.dart';
import 'package:world_of_wood/View/Navbar_view/user_details_view.dart';
import 'package:world_of_wood/View/Splash_view.dart';

import '../../View/Auth_View/Login_View.dart';
import '../../View/Auth_View/Personal_details_add.dart';
import '../../View/Auth_View/Resetpassword_view.dart';
import '../../View/Auth_View/Singnup_view.dart';

class Routes{
  static Route<dynamic> generateRoute (RouteSettings setting) {
    switch (setting.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
        case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
        case RoutesName.notes:
        return MaterialPageRoute(
            builder: (BuildContext context) => NotesFeedPage());
        case RoutesName.userProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => UserDetailsForm());
        case RoutesName.userdetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => UserDetails());
        case RoutesName.terms:
        return MaterialPageRoute(
            builder: (BuildContext context) => TermsAndConditionsView());
        case RoutesName.PointsRedeem:
        return MaterialPageRoute(
            builder: (BuildContext context) => PointsRedeemptionView());
        case RoutesName.signup:
          return MaterialPageRoute(
              builder: (BuildContext context) => SignupView());
        case RoutesName.resetPassword:
          return MaterialPageRoute(
              builder: (BuildContext context) => ResetPasswordScreen());
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
