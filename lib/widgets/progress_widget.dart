import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '0 of 0',
          style: Theme.of(context).textTheme.display1,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Stack(
              children: <Widget>[
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    color: Colors.grey[400],
                  ),
                ),
                Container(
                  height: 5.0,
                  width: 0.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )),
            Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.display1,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
