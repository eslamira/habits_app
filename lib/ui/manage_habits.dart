import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/ui/add-edit_habit.dart';
import 'package:habits_app/ui/main_screen.dart';
import 'package:habits_app/utils/local_database_provider.dart';

class ManageHabits extends StatefulWidget {
  final List<HabitModel> habits;

  ManageHabits(this.habits);

  @override
  _ManageHabitsState createState() => _ManageHabitsState();
}

class _ManageHabitsState extends State<ManageHabits> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.habits.isNotEmpty)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Color(widget.habits[0].color)));
//    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Habits',
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .title
              .copyWith(color: Colors.black),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()),
                (r) => false)),
      ),
      body: ReorderableListView(
        children: widget.habits
            .map(
              (h) => Column(
                key: ValueKey(h),
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HabitScreen(
                              habitModel: h,
                            ))),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${h.name}',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: Colors.black),
                          ),
                          Icon(
                            FontAwesomeIcons.expandArrowsAlt,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
            .toList(),
        onReorder: (oldIndex, newIndex) async {
          if (newIndex == widget.habits.length)
            newIndex = widget.habits.length - 1;
          HabitModel tempOldHM = widget.habits[oldIndex];
          HabitModel tempNewHM = widget.habits[newIndex];
          widget.habits.removeAt(oldIndex);
          widget.habits.insert(oldIndex, tempNewHM);
          widget.habits.removeAt(newIndex);
          widget.habits.insert(newIndex, tempOldHM);
          String tempId = widget.habits[oldIndex].id;
          widget.habits[oldIndex].id = widget.habits[newIndex].id;
          widget.habits[newIndex].id = tempId;
          await SQLiteDBProvider.internal()
              .updateHabit(widget.habits[oldIndex]);
          await SQLiteDBProvider.internal()
              .updateHabit(widget.habits[newIndex]);
          if (mounted) setState(() {});
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => HabitScreen())),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
