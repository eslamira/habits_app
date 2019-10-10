import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/ui/add-edit_habit.dart';

class HabitDetailsScreen extends StatefulWidget {
  final HabitModel habitModel;

  HabitDetailsScreen(this.habitModel);

  @override
  _HabitDetailsScreenState createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final _key = GlobalKey();
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  int _done = 0;
  int _total = 0;
  int _percent = 0;
  int _year = DateTime.now().year;
  double _lineHeight = 0.0;
  List<CircularStackEntry> _data = List();
  List<int> _monthlyDone = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = _key.currentContext.findRenderObject();
      _lineHeight = box.size.height;

      widget.habitModel.habitDetails.forEach((f) {
        switch (DateTime.fromMillisecondsSinceEpoch(f['date']).month) {
          case 1:
            {
              if (f['done'] == true) _monthlyDone[0]++;
            }
            break;
          case 2:
            {
              if (f['done'] == true) _monthlyDone[1]++;
            }
            break;
          case 3:
            {
              if (f['done'] == true) _monthlyDone[2]++;
            }
            break;
          case 4:
            {
              if (f['done'] == true) _monthlyDone[3]++;
            }
            break;
          case 5:
            {
              if (f['done'] == true) _monthlyDone[4]++;
            }
            break;
          case 6:
            {
              if (f['done'] == true) _monthlyDone[5]++;
            }
            break;
          case 7:
            {
              if (f['done'] == true) _monthlyDone[6]++;
            }
            break;
          case 8:
            {
              if (f['done'] == true) _monthlyDone[7]++;
            }
            break;
          case 9:
            {
              if (f['done'] == true) _monthlyDone[8]++;
            }
            break;
          case 10:
            {
              if (f['done'] == true) _monthlyDone[9]++;
            }
            break;
          case 11:
            {
              if (f['done'] == true) _monthlyDone[10]++;
            }
            break;
          case 12:
            {
              if (f['done'] == true) _monthlyDone[11]++;
            }
            break;
        }
      });

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
      _data = <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              _percent.truncateToDouble(),
              Theme.of(context).primaryColor,
              rankKey: 'completed',
            ),
            CircularSegmentEntry(
              100.0 - _percent.truncateToDouble(),
              Colors.grey[300],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ];

      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
      _chartKey.currentState.updateData(_data);
//      _chartKey.currentState.setState(() {});
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(widget.habitModel.color)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.habitModel.name}',
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .title
              .copyWith(color: Colors.black),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HabitScreen(
                      habitModel: widget.habitModel,
                    ))),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Progress',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Colors.black),
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartKey,
                        size: const Size(250.0, 250.0),
                        holeRadius: 100.0,
                        initialChartData: _data,
                        edgeStyle: SegmentEdgeStyle.flat,
                        chartType: CircularChartType.Radial,
                        percentageValues: true,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_percent%',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Text(
                              '$_done of $_total \ncompleted',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Performance',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.black),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '$_year',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 8.0),
                          InkWell(
                            onTap: () => setState(() => _year--),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '<',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                        fontSize: 22.0,
                                        color: Colors.grey[400]),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => _year++),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '>',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                        fontSize: 22.0,
                                        color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      key: _key,
                      margin: EdgeInsets.only(top: 32.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: _lineChart('J', 0)),
                          Expanded(child: _lineChart('F', 1)),
                          Expanded(child: _lineChart('M', 2)),
                          Expanded(child: _lineChart('A', 3)),
                          Expanded(child: _lineChart('M', 4)),
                          Expanded(child: _lineChart('J', 5)),
                          Expanded(child: _lineChart('J', 6)),
                          Expanded(child: _lineChart('A', 7)),
                          Expanded(child: _lineChart('S', 8)),
                          Expanded(child: _lineChart('O', 9)),
                          Expanded(child: _lineChart('N', 10)),
                          Expanded(child: _lineChart('D', 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineChart(String char, int index) {
    double height = 0.0;
    height = (_monthlyDone[index] / _total) * _lineHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: height ?? 0.0,
          width: 16.0,
          decoration: BoxDecoration(
            color: Color(widget.habitModel.color),
            borderRadius: BorderRadius.all(
              Radius.circular(28.0),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Expanded(
          flex: 0,
          child: Text(
            char,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
          ),
        ),
      ],
    );
  }
}
