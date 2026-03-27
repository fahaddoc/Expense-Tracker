import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const AddExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterByCategory extends ExpenseEvent {
  final ExpenseCategory? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByDateRange extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FilterByDateRange(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

class ClearFilters extends ExpenseEvent {}
