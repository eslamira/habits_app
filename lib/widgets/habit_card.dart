import 'package:flutter/material.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/ui/habit_details.dart';
import 'package:habits_app/widgets/date_widget.dart';
import 'package:habits_app/widgets/progress_widget.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habitModel;

  const HabitCard({Key key, @required this.habitModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HabitDetailsScreen(habitModel))),
              child: Text(
                'More',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 11.0, vertical: 32.0),
              child: Text('${habitModel.name}',
                  style: Theme.of(context).textTheme.title),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                DateWidget(
                    habitModel,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)),
                DateWidget(
                    habitModel,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 1)),
                DateWidget(
                    habitModel,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 2)),
                DateWidget(
                    habitModel,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 3)),
                DateWidget(
                    habitModel,
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day - 4)),
              ],
            ),
          ),
          ProgressWidget(habitModel),
        ],
      ),
    );
  }
}
