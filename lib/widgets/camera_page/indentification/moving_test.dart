import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TextStream extends StatefulWidget {
  @override
  _TextStreamState createState() => _TextStreamState();
}

class _TextStreamState extends State<TextStream> {
  var textStreamGlobalKey = GlobalKey();
  Size size;
  List<double> offsetList = [];
  List<String> testNameSuggestions = [
    // "Bag",
    // "Ceramic",
    // "Cereal",
    // "Car",
    // "Juga",
    // "maize"
  ];
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 500), (t) {
      testNameSuggestions.add("Sample");
      //maintain just 5 entries to curb overflow
      // if (testNameSuggestions.length > 5) {
      //   testNameSuggestions =
      //       testNameSuggestions.sublist(testNameSuggestions.length - 5);
      //   setState(() {});
      // }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      size = textStreamGlobalKey.currentContext.size;
      offsetList = [0.0, size.height / 2, size.height];
      setState(() {});
    });
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  Widget positionedFloatingText(int index) {
    String itemName = testNameSuggestions[index];
    return FadingText(
      topOffset: offsetList[index % 3],
      leftOffset:
          doubleInRange(Random(), 0.0, size.width - (itemName.length * 8)),
      title: itemName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: textStreamGlobalKey,
      children: List.generate(
          testNameSuggestions.length, (index) => positionedFloatingText(index)),
    );
  }
}

class FadingText extends StatefulWidget {
  final double topOffset;
  final double leftOffset;
  final String title;
  FadingText({this.topOffset, this.title, this.leftOffset});
  @override
  _FadingTextState createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> with TickerProviderStateMixin {
  double opacity = 1.0;
  AnimationController animationController;
  double left;
  @override
  void initState() {
    super.initState();
    double startOffset = widget.leftOffset;
    left = startOffset;
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {
          left = lerpDouble(
              startOffset, startOffset - 10, animationController.value);
        });
      });
    Timer.run(() {
      opacity = 0.0;
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: left,
          top: widget.topOffset,
          child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(seconds: 1),
            child: Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
