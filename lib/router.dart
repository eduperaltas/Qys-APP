import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Usuarios/UI/Screens/login.dart';

const String StartUserRoute = "/";
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartUserRoute:
      return PageTransition(child: SignInScreen(), type: PageTransitionType.rightToLeft);

  }
}