import 'package:fanpage/driver.dart';
import 'package:fanpage/pages/home.dart';
import 'package:fanpage/pages/signup.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.driver:
        return MaterialPageRoute(builder: (_) => Driver());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      default:
        return MaterialPageRoute(builder: (_) => Driver());
    }
  }
}

class Routes {
  static const String home = HomePage.routeName;
  static const String signup = SignUpPage.routeName;
  static const String driver = '/';
}
