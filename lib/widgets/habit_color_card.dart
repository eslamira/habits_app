import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final Color itemColor;
  final bool checked;
  ColorCard({@required this.itemColor, this.checked = false});

  bool isDark(Color color) {
    final luminance =
        (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue);
    return luminance < 150;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.width * 0.12,
      margin: EdgeInsets.only(right: 16.0, top: 12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: itemColor,
      ),
      alignment: Alignment.center,
      child: Visibility(
        visible: checked,
        child: Icon(
          Icons.check,
          color: isDark(itemColor) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
