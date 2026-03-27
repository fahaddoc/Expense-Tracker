import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    try {
      final expenses = await localDataSource.getAllExpenses();
      return Right(expenses.map((model) => model.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(int id) async {
    try {
      final expense = await localDataSource.getExpenseById(id);
      if (expense == null) {
        return Left(NotFoundFailure());
      }
      return Right(expense.toEntity());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final id = await localDataSource.addExpense(model);
      return Right(id);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      await localDataSource.updateExpense(model);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(int id) async {
    try {
      await localDataSource.deleteExpense(id);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(ExpenseCategory category) async {
    try {
      final expenses = await localDataSource.getExpensesByCategory(category.name);
      return Right(expenses.map((model) => model.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(DateTime start, DateTime end) async {
    try {
      final expenses = await localDataSource.getExpensesByDateRange(start, end);
      return Right(expenses.map((model) => model.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpenses() async {
    try {
      final total = await localDataSource.getTotalExpenses();
      return Right(total);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Map<ExpenseCategory, double>>> getExpensesByCategories() async {
    try {
      final expenses = await localDataSource.getAllExpenses();
      final Map<ExpenseCategory, double> result = {};

      for (var expense in expenses) {
        final category = ExpenseCategory.values.firstWhere(
          (e) => e.name == expense.categoryString,
          orElse: () => ExpenseCategory.other,
        );
        result[category] = (result[category] ?? 0) + expense.amount;
      }

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
