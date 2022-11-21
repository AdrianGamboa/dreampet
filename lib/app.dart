import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app_ui/util/const.dart';
import 'package:social_app_ui/util/global.dart';
import 'package:social_app_ui/util/theme_config.dart';
import 'package:social_app_ui/views/screens/auth/login.dart';
import 'package:social_app_ui/views/screens/introduction_screen.dart';
import 'package:social_app_ui/views/screens/main_screen.dart';

class MyApp extends StatelessWidget {
  final bool showIntroduction;

  const MyApp({Key key, this.showIntroduction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: themeData(ThemeConfig.lightTheme),
        darkTheme: themeData(ThemeConfig.darkTheme),
        home: showIntroduction
            ? configureSession()
            : IntroductionScreenPage(intro: true));
  }

  Widget configureSession() {
    userFire = authFire.currentUser;
    if (userFire == null) {
      return Login();
    } else {
      return MainScreen();
    }
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
