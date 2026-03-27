import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddExpense implements UseCase<int, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  @override
  Future<Either<Failure, int>> call(AddExpenseParams params) async {
    return await repository.addExpense(params.expense);
  }
}

class AddExpenseParams {
  final Expense expense;

  AddExpenseParams({required this.expense});
}
