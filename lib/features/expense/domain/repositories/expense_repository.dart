import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getAllExpenses();
  Future<Either<Failure, Expense>> getExpenseById(int id);
  Future<Either<Failure, int>> addExpense(Expense expense);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(int id);
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(ExpenseCategory category);
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<Either<Failure, double>> getTotalExpenses();
  Future<Either<Failure, Map<ExpenseCategory, double>>> getExpensesByCategories();
}
