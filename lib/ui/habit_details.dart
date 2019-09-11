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
//  final GlobalKey<AnimatedCircularChartState> _chartKey =
//      new GlobalKey<AnimatedCircularChartState>();
  int _year = 2019;
  List<CircularStackEntry> data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(500.0, Theme.of(context).primaryColor,
                rankKey: 'Q1'),
//        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
//        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
//        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
          ],
          rankKey: 'Quarterly Profits',
        ),
      ];

      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(widget.habitModel.color)));
//    if (mounted) setState(() {});
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
//                    key: _chartKey,
                        size: const Size(250.0, 250.0),
                        holeRadius: 100.0,
                        initialChartData: <CircularStackEntry>[
                          CircularStackEntry(
                            <CircularSegmentEntry>[
                              CircularSegmentEntry(
                                30.0,
                                Theme.of(context).primaryColor,
                                rankKey: 'completed',
                              ),
                              CircularSegmentEntry(
                                70.0,
                                Colors.grey[300],
                                rankKey: 'remaining',
                              ),
                            ],
                            rankKey: 'progress',
                          ),
                        ],
                        edgeStyle: SegmentEdgeStyle.flat,
                        chartType: CircularChartType.Radial,
                        percentageValues: true,
//                    holeLabel: '0% \n \n 0 of 0 completed',
//                    labelStyle: new TextStyle(
//                      color: Colors.blueGrey[600],
//                      fontWeight: FontWeight.bold,
//                      fontSize: 24.0,
//                    ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '0%',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Text(
                              '0 of 0 \ncompleted',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
