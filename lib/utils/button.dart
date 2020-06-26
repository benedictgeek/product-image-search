import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget indicator;
  final Function onTapAction;
  final Color bgColor;
  final Color color;
  final String leadingIconPath;
  final BorderRadius borderRadius;
  final Border border;

  CustomRaisedButton(
      {this.indicator,
      this.title,
      this.onTapAction,
      this.bgColor,
      this.color,
      this.leadingIconPath,
      this.width,
      this.borderRadius,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.border});
  @override
  Widget build(BuildContext context) {
    // Color themeTextColor = color == null ? Colors.white : color;
    // Color themeBgColor = bgColor == null ? Theme.of(context).primaryColor : bgColor;

    return InkWell(
      onTap: onTapAction,
      child: Container(
        height: height != null ? height : 45,
        width: width != null ? width : 180,
        // padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor != null ? bgColor : Theme.of(context).primaryColor,
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(25),
          border: border != null ? border : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (leadingIconPath != null)
              SizedBox(
                height: 20,
                child: Image.asset(leadingIconPath),
              ),
            if (leadingIconPath != null)
              SizedBox(
                width: 8,
              ),
            FittedBox(
              child: Text(
                title,
                style: Theme.of(context).textTheme.body2.copyWith(
                      color: color != null ? color : Colors.white,
                      fontSize: fontSize != null ? fontSize : null,
                      fontWeight:
                          fontWeight != null ? fontWeight : FontWeight.w600,
                    ),
              ),
            ),
            if (indicator != null) indicator
          ],
        ),
      ),
    );
  }
}
