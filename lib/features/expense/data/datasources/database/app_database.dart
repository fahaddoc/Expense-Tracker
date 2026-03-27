import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../models/expense_model.dart';
import 'expense_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ExpenseModel])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('expense_tracker.db').build();
  }
}
