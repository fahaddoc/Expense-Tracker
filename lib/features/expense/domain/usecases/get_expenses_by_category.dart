import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesByCategory implements UseCase<List<Expense>, CategoryParams> {
  final ExpenseRepository repository;

  GetExpensesByCategory(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(CategoryParams params) async {
    return await repository.getExpensesByCategory(params.category);
  }
}

class CategoryParams {
  final ExpenseCategory category;

  CategoryParams({required this.category});
}
