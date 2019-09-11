class HabitModel {
  String id;
  String name;
  int color;
  List repeatGoal;
  List habitDetails = List();

  HabitModel({
    this.id,
    this.name,
    this.color,
    this.repeatGoal,
    this.habitDetails,
  });
}

class HabitDetails {
  int date;
  bool done;
  String note;

  HabitDetails({
    this.date,
    this.done,
    this.note,
  });

  HabitDetails.fromMap(Map m) {
    this.date = m['date'];
    this.done = m['done'];
    this.note = m['note'];
  }

  toMap() {
    return {'date': this.date, 'done': this.done, 'note': this.note};
  }
}
