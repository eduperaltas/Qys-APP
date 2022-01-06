import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qys/Usuarios/repository/tottus_sheets_api.dart';
import 'package:qys/router.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Usuarios/bloc/bloc_user.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await TottusSheetApi.init();

  var initializationSettingsAndroid =
  AndroidInitializationSettings('codex_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Application());
  });
  
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BlocProvider<UserBloc>(
        bloc: UserBloc(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AnimatedSplash(
              imagePath: 'assets/images/LOGO2.0.JPG',
              home: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: onGenerateRoute,
                  initialRoute: StartUserRoute,
                ),
              duration: 1600,
              type: AnimatedSplashType.StaticDuration,
            )
        ));
  }
}
