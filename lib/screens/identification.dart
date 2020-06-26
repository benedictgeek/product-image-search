import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_recognition/utils/button.dart';
import 'package:image_recognition/widgets/camera_page/indentification/moving_test.dart';

class IndentificationScreen extends StatefulWidget {
  static const String routeName = "/identification";
  @override
  _IndentificationScreenState createState() => _IndentificationScreenState();
}

class _IndentificationScreenState extends State<IndentificationScreen>
    with TickerProviderStateMixin {
  AnimationController _revolverAnimation;
  AnimationController _sweepAngleAnimation;

  double currentStartAngle = -pi / 2;
  double startAngle = -pi / 2;

  double sweepAngle = 0;

  //todo: decrease the sweep angle when identification is complete

  @override
  void initState() {
    super.initState();
    // sweepAngle = lerpDouble(0, pi, 0.6);
    _revolverAnimation = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..addListener(() {
        setState(() {
          currentStartAngle =
              lerpDouble(startAngle, (3 * pi) / 2, _revolverAnimation.value);
        });
      });
    _sweepAngleAnimation = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {
          sweepAngle = lerpDouble(0.0, pi, _sweepAngleAnimation.value);
        });
      });
    _revolverAnimation.repeat();
    _sweepAngleAnimation.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _revolverAnimation.dispose();
    _sweepAngleAnimation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Identification",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Understanding and Analysis",
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(fontWeight: FontWeight.w200),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Stack(
                  children: <Widget>[
                    // Positioned(child: Text("Test position"), top: -3,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval(
                          child: Image.asset(
                            "public/images/test.jpg",
                            fit: BoxFit.cover,
                            // centerSlice: Rect.fromCenter(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CustomPaint(
                          painter: InpectedPictureRevolver(
                              startAngle: currentStartAngle,
                              sweepAngle: sweepAngle),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 2,
              child: TextStream(),
            ),
            Spacer(
              flex: 1,
            ),
            CustomRaisedButton(
              title: "Cancel",
              bgColor: Colors.transparent,
              color: Colors.black,
              border: Border.all(width: 0.5),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class InpectedPictureRevolver extends CustomPainter {
  final startAngle;
  final sweepAngle;
  InpectedPictureRevolver({this.startAngle, this.sweepAngle});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.height / 2, size.width / 2);
    final radius = min(size.height / 2, size.width / 2);
    var arcBar = Paint()
      ..color = Color(0xff5A5DD3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var leadingDot = Paint()
      ..color = Color(0xff5A5DD3)
      ..style = PaintingStyle.fill;

    var trailingPonts = Paint()
      ..color = Color(0xff5A5DD3)
      ..strokeWidth = 8
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var ballPointX = (radius * cos(startAngle + sweepAngle)) + size.width / 2;
    var ballPointY = (radius * sin(startAngle + sweepAngle)) + size.height / 2;

    canvas.drawArc(
      Rect.fromCenter(center: center, width: size.width, height: size.height),
      startAngle,
      sweepAngle,
      false,
      arcBar,
    );
    canvas.drawCircle(Offset(ballPointX, ballPointY), 10, leadingDot);

    Offset getTrailingOffset(int pointIndex) {
      double trailingPointSweepAngle = sweepAngle / 10;
      double displacedAngle =
          (startAngle - (trailingPointSweepAngle * pointIndex));

      var trailingPointX = (radius * cos(displacedAngle)) + size.width / 2;
      var trailingPointY = (radius * sin(displacedAngle)) + size.height / 2;

      return Offset(trailingPointX, trailingPointY);
    }

    canvas.drawPoints(
        PointMode.points,
        [
          getTrailingOffset(1),
          getTrailingOffset(2),
          getTrailingOffset(3),
        ],
        trailingPonts);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
