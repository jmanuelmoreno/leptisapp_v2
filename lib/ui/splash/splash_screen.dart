import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

const TextStyle textStyle = TextStyle(
  color: Colors.white,
  //fontFamily: 'OpenSans',
);

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final background = Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/background.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );

  final greenOpacity = Container(
    color: const Color(0xAA69F0CF),
  );

  Widget button(String label, Function onTap) {
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, -0.6), end: Offset.zero)
            .animate(controller),
        child: Material(
          color: const Color(0xBB00D699),
          borderRadius: BorderRadius.circular(30.0),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Center(
                child: Text(
                  label,
                  style: textStyle.copyWith(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final logo = new ScaleTransition(
      scale: animation,
      child: Image.asset(
        'assets/images/logo.png',
        width: 180.0,
        height: 180.0,
      ),
    );

    final description = new FadeTransition(
      opacity: animation,
      child: new SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, -0.8), end: Offset.zero)
            .animate(controller),
        child: Text(
          'Spot the right place to learn guitar lessons.',
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontSize: 24.0),
        ),
      ),
    );

    final separator = new FadeTransition(
      opacity: animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(width: 20.0, height: 2.0, color: Colors.white),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'OR',
              style: textStyle,
            ),
          ),
          Container(width: 20.0, height: 2.0, color: Colors.white),
        ],
      ),
    );

    final signWith = new FadeTransition(
      opacity: animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Sign in with',
            style: textStyle,
          ),
          GestureDetector(
            onTap: () {
              print('google');
            },
            child: Text(
              ' Google',
              style: textStyle.copyWith(
                  color: const Color(0xBB009388),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          const Text(' or', style: textStyle),
          GestureDetector(
            onTap: () {
              print('Facebook');
            },
            child: Text(
              ' Facebook',
              style: textStyle.copyWith(
                  color: const Color(0xBB009388),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          background,
          greenOpacity,
          new SafeArea(
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  logo,
                  const SizedBox(height: 30.0),
                  description,
                  const SizedBox(height: 60.0),
                  button('Create an account', () {
                    print('account');
                  }),
                  const SizedBox(height: 8.0),
                  button('Sign In', () {
                    print('sign in');
                  }),
                  const SizedBox(height: 30.0),
                  separator,
                  const SizedBox(height: 30.0),
                  signWith
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}