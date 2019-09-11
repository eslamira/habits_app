import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/utils/local_database_provider.dart';
import 'package:intl/intl.dart';
import 'package:tiny_widgets/tiny_widgets.dart';

class DateWidget extends StatefulWidget {
  final HabitModel habitModel;
  final DateTime date;

  DateWidget(this.habitModel, this.date);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  final TextEditingController _note = TextEditingController();
  HabitDetails habitDetails = HabitDetails();
  bool _done = false;
  bool _loading = true;
  int _index;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int f = 0; f < widget.habitModel.habitDetails.length; f++) {
        if (widget.date ==
            DateTime.fromMillisecondsSinceEpoch(
                HabitDetails.fromMap(widget.habitModel.habitDetails[f]).date)) {
          habitDetails =
              HabitDetails.fromMap(widget.habitModel.habitDetails[f]);
          _index = f;
          _done = habitDetails.done;
          if (habitDetails.note != null) _note.text = habitDetails.note;
        }
      }
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  _notePopUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '${DateFormat.MMMEd().format(widget.date)}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontSize: 22.0, color: Colors.black),
            ),
            content: TextField(
              controller: _note,
              style: Theme.of(context).textTheme.display2,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CANCEL',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              FlatButton(
                onPressed: () async {
                  TinyLoadingPopUp().tinyLoading(context);
                  habitDetails.note = _note.text;
                  widget.habitModel.habitDetails[_index] = habitDetails.toMap();
                  await SQLiteDBProvider.internal()
                      .updateHabit(widget.habitModel);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container()
        : Row(
            children: <Widget>[
              CircularCheckBox(
                value: _done,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool x) async {
                  TinyLoadingPopUp().tinyLoading(context);
                  _done = x;
                  habitDetails.done = _done;
                  widget.habitModel.habitDetails[_index] = habitDetails.toMap();
                  await SQLiteDBProvider.internal()
                      .updateHabit(widget.habitModel);
                  Navigator.of(context).pop();
                  if (mounted) setState(() {});
                },
              ),
              SizedBox(width: 8.0),
              Text(
                  '${widget.date.day == DateTime.now().day ? 'Today,' : widget.date.day == (DateTime.now().day - 1) ? 'Yesterday,' : ''}'
                  '${DateFormat.MMMEd().format(widget.date)}'),
              SizedBox(width: 10.0),
              IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidComment,
                    size: 16.0,
                    color: habitDetails == null
                        ? Colors.grey[300]
                        : habitDetails.note == null
                            ? Colors.grey[300]
                            : Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    await _notePopUp();
                    if (mounted) setState(() {});
                  }),
            ],
          );
  }
}
