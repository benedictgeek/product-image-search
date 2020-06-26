import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_recognition/widgets/camera_page/camera_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                children: <Widget>[CameraPage()],
              ),
            ),
            BottomNavigationBar(
              currentIndex: 1,
              items: [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.compass), title: Container()),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.circle), title: Container()),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.userCircle),
                    title: Container())
              ],
            )
          ],
        ),
      ),
    );
  }
}
