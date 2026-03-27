import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/expense_repository.dart';

class DeleteExpense implements UseCase<void, DeleteExpenseParams> {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteExpenseParams params) async {
    return await repository.deleteExpense(params.id);
  }
}

class DeleteExpenseParams {
  final int id;

  DeleteExpenseParams({required this.id});
}
