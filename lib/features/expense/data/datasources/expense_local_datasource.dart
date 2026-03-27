import '../models/expense_model.dart';
import 'database/app_database.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getAllExpenses();
  Future<ExpenseModel?> getExpenseById(int id);
  Future<int> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(int id);
  Future<List<ExpenseModel>> getExpensesByCategory(String category);
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<double> getTotalExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final AppDatabase database;

  ExpenseLocalDataSourceImpl({required this.database});

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    return await database.expenseDao.getAllExpenses();
  }

  @override
  Future<ExpenseModel?> getExpenseById(int id) async {
    return await database.expenseDao.getExpenseById(id);
  }

  @override
  Future<int> addExpense(ExpenseModel expense) async {
    return await database.expenseDao.insertExpense(expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await database.expenseDao.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await database.expenseDao.deleteExpense(id);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    return await database.expenseDao.getExpensesByCategory(category);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end) async {
    return await database.expenseDao.getExpensesByDateRange(
      start.millisecondsSinceEpoch,
      end.millisecondsSinceEpoch,
    );
  }

  @override
  Future<double> getTotalExpenses() async {
    final total = await database.expenseDao.getTotalExpenses();
    return total ?? 0.0;
  }
}
