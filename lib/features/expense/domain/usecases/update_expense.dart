import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class UpdateExpense implements UseCase<void, UpdateExpenseParams> {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateExpenseParams params) async {
    return await repository.updateExpense(params.expense);
  }
}

class UpdateExpenseParams {
  final Expense expense;

  UpdateExpenseParams({required this.expense});
}
