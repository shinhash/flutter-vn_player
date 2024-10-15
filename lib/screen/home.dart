import 'package:flutter/material.dart';
import 'package:vn_player/layout/base_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      children: _homeView(),
    );
  }

  _homeView() {
    return [
      _Logo(),
      SizedBox(height: 10),
      _Title(),
    ];
  }
}

class _Logo extends StatefulWidget {
  const _Logo({super.key});

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  @override
  Widget build(BuildContext context) {
    return Image.asset('asset/image/logo.png');
  }
}

class _Title extends StatefulWidget {
  const _Title({super.key});

  @override
  State<_Title> createState() => _TitleState();
}

class _TitleState extends State<_Title> {
  @override
  Widget build(BuildContext context) {
    final fontStyle = TextStyle(
      color: Colors.white,
      fontSize: 32,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: fontStyle.copyWith(
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          'PLAYER',
          style: fontStyle.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
