import 'package:flutter/material.dart';
import 'package:habitz/components/habit_tile.dart';
import 'package:habitz/components/month_summary.dart';
import 'package:habitz/components/my_alert_box.dart';
import 'package:habitz/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("Habit_Database");
  HabitDatabase db = HabitDatabase();
  final TextEditingController _newHabitController = TextEditingController();

  @override
  void initState() {
    // first time opening app if there is no database yet
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDatabase();

    super.initState();
  }

  void checkboxTapped(bool? value, int index) {
    setState(
      () {
        db.todaysHabitList[index][1] = value!;
      },
    );
    db.updateDatabase();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitController,
          onCancel: cancelHabitBox,
          onSave: saveNewHabit,
          hintText: "Enter Habit Name",
        );
      },
    );
  }

  void saveNewHabit() {
    setState(
      () {
        db.todaysHabitList.add([_newHabitController.text, false]);
      },
    );
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void cancelHabitBox() {
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void editHabitName(int index) {
    setState(
      () {
        db.todaysHabitList[index][0] = _newHabitController.text;
      },
    );
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void openHabitSetting(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitController,
          onCancel: cancelHabitBox,
          onSave: () => editHabitName(index),
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        backgroundColor: Colors.grey[800],
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          // monthly summary
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
          ),

          // habit list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkboxTapped(value, index),
                settingTapped: (context) => openHabitSetting(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
            itemCount: db.todaysHabitList.length,
          ),
          const SizedBox(
            height: 65,
          ),
        ],
      ),
    );
  }
}
