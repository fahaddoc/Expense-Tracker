import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double totalAmount;
  final Map<ExpenseCategory, double> categoryTotals;
  final ExpenseCategory? filterCategory;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const ExpenseLoaded({
    required this.expenses,
    required this.totalAmount,
    this.categoryTotals = const {},
    this.filterCategory,
    this.filterStartDate,
    this.filterEndDate,
  });

  @override
  List<Object?> get props => [
        expenses,
        totalAmount,
        categoryTotals,
        filterCategory,
        filterStartDate,
        filterEndDate,
      ];

  ExpenseLoaded copyWith({
    List<Expense>? expenses,
    double? totalAmount,
    Map<ExpenseCategory, double>? categoryTotals,
    ExpenseCategory? filterCategory,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool clearCategoryFilter = false,
    bool clearDateFilter = false,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      totalAmount: totalAmount ?? this.totalAmount,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      filterCategory: clearCategoryFilter ? null : (filterCategory ?? this.filterCategory),
      filterStartDate: clearDateFilter ? null : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearDateFilter ? null : (filterEndDate ?? this.filterEndDate),
    );
  }
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseActionSuccess extends ExpenseState {
  final String message;

  const ExpenseActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
