import 'package:flutter/material.dart';
import 'package:habits_app/main.dart';
import 'package:habits_app/model/habit_model.dart';
import 'package:habits_app/ui/add-edit_habit.dart';
import 'package:habits_app/ui/habit_details.dart';
import 'package:habits_app/ui/manage_habits.dart';
import 'package:habits_app/utils/local_database_provider.dart';
import 'package:habits_app/widgets/habit_card.dart';
import 'package:tiny_widgets/tiny_widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<HabitModel> _habits = List<HabitModel>();
  int _currentImage = 0;
  PageController _controller;
  bool _isLoading = true;

  @override
  initState() {
    super.initState();
    _initData();
  }

  _initData() async {
//    try {
    _habits = await SQLiteDBProvider.internal().getAllHabits();
    _currentImage = 0;
    _controller = PageController(
      initialPage: _currentImage,
      keepPage: false,
      viewportFraction: 0.8,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_habits.isNotEmpty) MyApp.setTheme(context, Color(_habits[0].color));
    });
    _isLoading = false;
    if (mounted) setState(() {});
//    } catch (e) {
//      print(e);
//    }
  }

  builder(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: _currentImage == index
                    ? MediaQuery.of(context).size.height > 1000 &&
                            MediaQuery.of(context).orientation ==
                                Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.85
                        : MediaQuery.of(context).size.height > 800 &&
                                MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                            ? MediaQuery.of(context).size.height * 0.75
                            : MediaQuery.of(context).size.height * 0.75
                    : MediaQuery.of(context).size.height > 1000 &&
                            MediaQuery.of(context).orientation ==
                                Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.75
                        : MediaQuery.of(context).size.height > 800 &&
                                MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                            ? MediaQuery.of(context).size.height * 0.65
                            : MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.height > 1000 &&
                        MediaQuery.of(context).orientation ==
                            Orientation.portrait
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.height > 800 &&
                            MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.95
                        : MediaQuery.of(context).size.width * 0.95,
                child: HabitCard(habitModel: _habits[index])),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('HABITS'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HabitScreen())),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            if (_habits.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _habits
                    .map(
                      (h) => ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HabitDetailsScreen(h)));
                    },
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(h.color),
                        ),
                      ),
                    ),
                    title: Text(
                      '${h.name}',
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Colors.black),
                    ),
                  ),
                )
                    .toList(),
              ),
              Divider(),
            ],
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ManageHabits(_habits)));
              },
              leading: Icon(Icons.edit),
              title: Text(
                'Manage Habits',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.black),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.black),
              ),
            ),
            ListTile(
              leading: Icon(Icons.mode_comment),
              title: Text(
                'About',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? TinyLoading(
              color: Theme.of(context).primaryColor,
              verColor: Theme.of(context).scaffoldBackgroundColor,
            )
          : PageView.builder(
              onPageChanged: (int value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  MyApp.setTheme(context, Color(_habits[value].color));
                });
                _currentImage = value;
                setState(() {});
              },
              controller: _controller,
              itemCount: _habits.length,
              itemBuilder: (context, index) => builder(index),),
    );
  }
}
