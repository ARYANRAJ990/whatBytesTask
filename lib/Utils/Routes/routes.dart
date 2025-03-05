import 'package:fintech_task/Utils/Routes/routes_name.dart';
import 'package:flutter/material.dart';


import '../../View/Auth_View/Login_View.dart';
import '../../View/Navbar_view/Personal_details_add.dart';
import '../../View/Auth_View/Resetpassword_view.dart';
import '../../View/Auth_View/Singnup_view.dart';
import '../../View/Home/Points_Redeemption_View.dart';
import '../../View/Home/task_feed_page.dart';
import '../../View/Navbar_view/terms_and_conditions_view.dart';
import '../../View/Navbar_view/user_details_view.dart';
import '../../View/Splash_view.dart';

class Routes{
  static Route<dynamic> generateRoute (RouteSettings setting) {
    switch (setting.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
        case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
        case RoutesName.task:
        return MaterialPageRoute(
            builder: (BuildContext context) => TasksPage());
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
