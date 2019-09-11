import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:habits_app/model/habit_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDBProvider {
  static final SQLiteDBProvider _instance = new SQLiteDBProvider.internal();

  factory SQLiteDBProvider() => _instance;

  final String tableHabits = "habits";
  final String columnId = "id";
  final String columnName = "name";
  final String columnColor = "color";
  final String columnRepeatGoal = "repeatGoal";
  final String columnHabitDetails = "habitDetails";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  SQLiteDBProvider.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  /*
     id | username | password
     ------------------------
     1  | Paulo    | paulo
     2  | James    | bond
   */

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableHabits($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnColor TEXT, $columnRepeatGoal TEXT, $columnHabitDetails TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE , DELETE

  //Insertion
  Future<int> saveHabit(HabitModel habitModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableHabits", {
      columnName: habitModel.name,
      columnColor: habitModel.color,
      columnRepeatGoal: jsonEncode(habitModel.repeatGoal),
      columnHabitDetails: jsonEncode(habitModel.habitDetails)
    });
    return res;
  }

  Future<HabitModel> getHabit(int id) async {
    HabitModel habitModel;
    var dbClient = await db;
    var result = await dbClient
        .query(tableHabits, where: "$columnId = ?", whereArgs: [id]);
    print(result);
    result = result.toList();
    result.forEach((content) {
      print(content);
      habitModel = HabitModel();
      habitModel.id = content["$columnId"].toString();
      habitModel.name = content["$columnName"].toString();
      habitModel.color = int.parse(content["$columnColor"].toString());
      habitModel.repeatGoal = jsonDecode(content["$columnRepeatGoal"]);
      habitModel.habitDetails =
          jsonDecode(content["$columnHabitDetails"] ?? '[]').isEmpty
              ? <HabitDetails>[]
              : jsonDecode(content["$columnHabitDetails"]);
      print(habitModel.habitDetails);
    });
    return habitModel;
  }

  // Get Habits
  Future<List<HabitModel>> getAllHabits() async {
    List<HabitModel> habits = List<HabitModel>();
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableHabits");
    result = result.toList();
    result.forEach((content) {
      print(content);
      habits
        ..add(
          HabitModel(
            id: content["$columnId"].toString(),
            name: content["$columnName"],
            color: int.parse(content["$columnColor"].toString()),
            repeatGoal: jsonDecode(content["$columnRepeatGoal"]),
            habitDetails:
                jsonDecode(content["$columnHabitDetails"] ?? '[]').isEmpty
                    ? <HabitDetails>[]
                    : jsonDecode(content["$columnHabitDetails"]),
          ),
        );
    });
    return habits;
  }

  Future<int> updateHabit(HabitModel habitModel) async {
    var dbClient = await db;

    return await dbClient.update(
        tableHabits,
        {
          columnName: habitModel.name,
          columnColor: habitModel.color,
          columnRepeatGoal: jsonEncode(habitModel.repeatGoal),
          columnHabitDetails: jsonEncode(habitModel.habitDetails)
        },
        where: "$columnId = ?",
        whereArgs: [int.parse(habitModel.id)]);
  }

  Future<int> deleteHabit(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableHabits, where: "$columnId = ?", whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
