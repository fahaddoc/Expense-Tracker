import 'package:floor/floor.dart';
import '../../models/expense_model.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM expenses ORDER BY date DESC')
  Future<List<ExpenseModel>> getAllExpenses();

  @Query('SELECT * FROM expenses WHERE id = :id')
  Future<ExpenseModel?> getExpenseById(int id);

  @insert
  Future<int> insertExpense(ExpenseModel expense);

  @update
  Future<void> updateExpense(ExpenseModel expense);

  @Query('DELETE FROM expenses WHERE id = :id')
  Future<void> deleteExpense(int id);

  @Query('SELECT * FROM expenses WHERE category = :category ORDER BY date DESC')
  Future<List<ExpenseModel>> getExpensesByCategory(String category);

  @Query('SELECT * FROM expenses WHERE date BETWEEN :startDate AND :endDate ORDER BY date DESC')
  Future<List<ExpenseModel>> getExpensesByDateRange(int startDate, int endDate);

  @Query('SELECT SUM(amount) FROM expenses')
  Future<double?> getTotalExpenses();
}
