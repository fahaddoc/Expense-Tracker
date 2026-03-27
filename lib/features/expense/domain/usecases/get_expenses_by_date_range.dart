import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesByDateRange implements UseCase<List<Expense>, DateRangeParams> {
  final ExpenseRepository repository;

  GetExpensesByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(DateRangeParams params) async {
    return await repository.getExpensesByDateRange(params.startDate, params.endDate);
  }
}

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeParams({required this.startDate, required this.endDate});
}
