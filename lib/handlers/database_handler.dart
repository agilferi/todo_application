import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_aplication/models/task_model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todo.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE db_task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,description INTEGER NOT NULL, date TEXT NOT NULL, isDone TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertTask(List<TaskModel> taskModel) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var task in taskModel) {
      result = await db.insert('db_task', task.toMap());
    }
    debugPrint('Success Insert');
    return result;
  }

  Future<List<TaskModel>> retrieveTasks() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('db_task');
    debugPrint('Success Get');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<List<TaskModel>> retrieveTasksByDate(String date) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('db_task', where: 'date=?', whereArgs: [date]);
    debugPrint('Success Get');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> updateTask(List<TaskModel> taskModel) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var task in taskModel) {
      result = await db.update(
        'db_task',
        task.toMap(),
        where: 'id=?',
        whereArgs: [task.id],
      );
    }
    debugPrint('Success Update');
    return result;
  }

  Future<void> deleteTask(int id) async {
    final db = await initializeDB();
    await db.delete(
      'db_task',
      where: "id = ?",
      whereArgs: [id],
    );
    debugPrint('Success Delete');
  }
}
