import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';

class IntroductionScreenPage extends StatefulWidget {
  final bool intro;

  const IntroductionScreenPage({Key key, this.intro}) : super(key: key);

  @override
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onIntroEnd(context) async {
    if (widget.intro) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('showIntroduction', true);

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        // # 1
        PageViewModel(
          title: "¡Firulais te da la bienvenida!",
          body: "¡Bienvenido a Dreampet!",
          image: _buildImage('Intro1.png', 250),
          decoration: pageDecoration,
        ),
        // # 2
        PageViewModel(
          title: "Encuentra un hogar para mascotas",
          body:
              "Puedes ayudar a alguna mascota a encontrar un nuevo hogar, adoptando o dando en adopción.",
          image: _buildImage('Intro2.png', 250),
          decoration: pageDecoration,
        ),
        // # 3
        PageViewModel(
          title: "Encuentra a mascotas perdidas",
          body:
              "Puedes ayudar a alguna mascota a volver con su familia o que te ayuden a encontrar a la tuya.",
          image: _buildImage('Intro3.png', 250),
          decoration: pageDecoration,
        ),
        // # 4
        PageViewModel(
          title: "Lleva un registro de tus mascotas",
          body:
              "Puedes llevar un registro con toda la información general de tus mascotas.",
          image: _buildImage('Intro4.png', 250),
          decoration: pageDecoration,
        ),
        // # 5
        PageViewModel(
          title: "Lleva un control médico de tus mascotas",
          body:
              "Puedes llevar un control médico de tus mascotas, registrando vacunas, medicinas o visitas al veterinario.",
          image: _buildImage('Intro5.png', 250),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_back, color: Colors.white),
      skip: const Text('Saltar', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      done: const Text('Listo',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.all(8.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeColor: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color.fromARGB(255, 43, 42, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
