import 'package:flutter/material.dart';
import 'package:habits_app/model/habit_model.dart';

class ProgressWidget extends StatefulWidget {
  final HabitModel habitModel;

  ProgressWidget(this.habitModel);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  final _key = GlobalKey();
  int _done = 0;
  int _total = 0;
  int _percent = 0;
  double _lineWidth = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = _key.currentContext.findRenderObject();
      _lineWidth = box.size.width;

      if (widget.habitModel.repeatGoal[1] == 'Everyday') {
        if (DateTime.now().month == 1 ||
            DateTime.now().month == 3 ||
            DateTime.now().month == 5 ||
            DateTime.now().month == 7 ||
            DateTime.now().month == 8 ||
            DateTime.now().month == 10 ||
            DateTime.now().month == 12) {
          _total = 31;
        } else if (DateTime.now().month == 2) {
          _total = 28;
        } else {
          _total = 30;
        }
      } else {
        _total = int.parse(widget.habitModel.repeatGoal[0].toString());
      }
      widget.habitModel.habitDetails.forEach((f) {
        if (f['done'] == true) _done++;
      });
      _percent = ((_done / _total) * 100).truncate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$_done of $_total',
          style: Theme.of(context).textTheme.display1,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Stack(
              children: <Widget>[
                Container(
                  key: _key,
                  height: 5.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    color: Colors.grey[400],
                  ),
                ),
                Container(
                  height: 5.0,
                  width: _lineWidth * (_percent / 100),
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
                    '$_percent%',
                    style: Theme.of(context).textTheme.display1,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
