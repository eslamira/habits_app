import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/ui/main_screen.dart';
import 'package:habits_app/utils/local_database_provider.dart';
import 'package:habits_app/widgets/habit_color_card.dart';

class HabitScreen extends StatefulWidget {
  final HabitModel habitModel;

  HabitScreen({this.habitModel});

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HabitModel _habitModel = HabitModel(habitDetails: <Map>[]);
  TextEditingController _nameController = TextEditingController();
  String _pickedColor;
  List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.green,
    Colors.lightGreen,
    Colors.yellow,
    Colors.orange,
    Colors.blueGrey,
  ];
  List _selected = List();
  List<int> _list = List<int>();
  List<int> _list2 = List<int>();
  String _pickerData;
  String _pickerData2;
  String _pickerData3;

  @override
  void initState() {
    super.initState();
    _selected = ['', ''];
    _list = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25
    ];
    _list2 = _list;
    _pickerData2 = '''
[
    $_list2,
    [
    "Everyday",
    "times in a month"
    ]
]
    ''';
    _pickerData3 = '''
[
    [
    "","",""
    ],
    [
    "Everyday",
    "times in a month"
    ]
]
    ''';
    _pickerData = _pickerData3;
    if (widget.habitModel != null) {
      _habitModel = widget.habitModel;
      _nameController.text = widget.habitModel.name;
      _pickedColor = widget.habitModel.color.toString();
      _selected = widget.habitModel.repeatGoal;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  _showPickerArray(BuildContext context, {List<int> selected}) {
    var jso = JsonDecoder().convert(_pickerData);
    PickerDataAdapter adapter =
        PickerDataAdapter<String>(pickerdata: jso, isArray: true);
    Picker(
        adapter: adapter,
        hideHeader: true,
        selecteds: selected,
        itemExtent: 48.0,
        columnFlex: [1, 2],
        confirmText: 'OK',
        cancelText: 'CANCEL',
        columnPadding: EdgeInsets.all(12.0),
        title: new Text("Repeat goal"),
        onSelect: (picker, selected, List<int> list) {
          if (list[1] == 1) {
            _pickerData = _pickerData2;
            Navigator.of(context).pop();
            _showPickerArray(context, selected: list);
          } else {
            _pickerData = _pickerData3;
            Navigator.of(context).pop();
            _showPickerArray(context, selected: list);
          }
        },
        onConfirm: (Picker picker, List value) {
          _selected = picker.getSelectedValues();
          _pickerData = _pickerData3;
          if (mounted) setState(() {});
        }).showDialog(context);
  }

  _addHabit() async {
    if (_nameController.text.isNotEmpty &&
        _pickedColor != null &&
        _selected.isNotEmpty) {
      if (widget.habitModel == null) {
        await SQLiteDBProvider.internal().initDb();
        _habitModel.name = _nameController.text;
        _habitModel.color = int.parse(_pickedColor);
        _habitModel.repeatGoal = _selected;
        _habitModel.habitDetails
          ..add(
            HabitDetails(
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        .millisecondsSinceEpoch,
                    done: false,
                    note: null)
                .toMap(),
          )
          ..add(
            HabitDetails(
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 1)
                        .millisecondsSinceEpoch,
                    done: false,
                    note: null)
                .toMap(),
          )
          ..add(
            HabitDetails(
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 2)
                        .millisecondsSinceEpoch,
                    done: false,
                    note: null)
                .toMap(),
          )
          ..add(
            HabitDetails(
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 3)
                        .millisecondsSinceEpoch,
                    done: false,
                    note: null)
                .toMap(),
          )
          ..add(
            HabitDetails(
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 4)
                        .millisecondsSinceEpoch,
                    done: false,
                    note: null)
                .toMap(),
          );
        await SQLiteDBProvider.internal().saveHabit(_habitModel);
//      await SQLiteDBProvider.internal().getHabit(i);
//      await SQLiteDBProvider.internal().close();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
            (r) => false);
      } else {
        _habitModel.name = _nameController.text;
        _habitModel.color = int.parse(_pickedColor);
        _habitModel.repeatGoal = _selected;
        await SQLiteDBProvider.internal().initDb();
        await SQLiteDBProvider.internal().updateHabit(_habitModel);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          if (widget.habitModel != null) ...[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await SQLiteDBProvider.internal()
                    .deleteHabit(int.parse(widget.habitModel.id));

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()),
                    (r) => false);
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => _addHabit(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.display2,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                ),
              ),
              SizedBox(height: 32.0),
              Text(
                'Choose color',
                style: Theme.of(context).textTheme.display1,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: RadioButtonGroup(
                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                  onSelected: (String selected) => setState(() {
                    _pickedColor = selected;
                  }),
                  labels: _colors.map((c) => c.value.toString()).toList(),
                  picked: _pickedColor,
                  itemBuilder: (Radio rb, Text txt, int i) {
                    return InkWell(
                      onTap: () => rb.onChanged(i),
                      splashColor: _colors[i],
                      child: ColorCard(
                        itemColor: _colors[i],
                        checked: txt.data == _pickedColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.0),
              InkWell(
                onTap: () => _showPickerArray(context, selected: [0, 0]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Repeat goal',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${_selected[0]} ${_selected[1]}',
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
