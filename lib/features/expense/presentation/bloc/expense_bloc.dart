import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_all_expenses.dart';
import '../../domain/usecases/get_expenses_by_category.dart';
import '../../domain/usecases/get_expenses_by_date_range.dart';
import '../../domain/usecases/update_expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetAllExpenses getAllExpenses;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;
  final GetExpensesByCategory getExpensesByCategory;
  final GetExpensesByDateRange getExpensesByDateRange;

  ExpenseBloc({
    required this.getAllExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpensesByCategory,
    required this.getExpensesByDateRange,
  }) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByDateRange>(_onFilterByDateRange);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    final result = await getAllExpenses(NoParams());

    result.fold(
      (failure) => emit(const ExpenseError('Failed to load expenses')),
      (expenses) {
        final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
        final categoryTotals = _calculateCategoryTotals(expenses);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalAmount: total,
          categoryTotals: categoryTotals,
        ));
      },
    );
  }

  Future<void> _onAddExpense(AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    final result = await addExpense(AddExpenseParams(expense: event.expense));

    result.fold(
      (failure) => emit(const ExpenseError('Failed to add expense')),
      (_) {
        emit(const ExpenseActionSuccess('Expense added successfully'));
        add(LoadExpenses());
      },
    );
  }

  Future<void> _onUpdateExpense(UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    final result = await updateExpense(UpdateExpenseParams(expense: event.expense));

    result.fold(
      (failure) => emit(const ExpenseError('Failed to update expense')),
      (_) {
        emit(const ExpenseActionSuccess('Expense updated successfully'));
        add(LoadExpenses());
      },
    );
  }

  Future<void> _onDeleteExpense(DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    final result = await deleteExpense(DeleteExpenseParams(id: event.id));

    result.fold(
      (failure) => emit(const ExpenseError('Failed to delete expense')),
      (_) {
        emit(const ExpenseActionSuccess('Expense deleted successfully'));
        add(LoadExpenses());
      },
    );
  }

  Future<void> _onFilterByCategory(FilterByCategory event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    if (event.category == null) {
      add(LoadExpenses());
      return;
    }

    final result = await getExpensesByCategory(
      CategoryParams(category: event.category!),
    );

    result.fold(
      (failure) => emit(const ExpenseError('Failed to filter expenses')),
      (expenses) {
        final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
        final categoryTotals = _calculateCategoryTotals(expenses);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalAmount: total,
          categoryTotals: categoryTotals,
          filterCategory: event.category,
        ));
      },
    );
  }

  Future<void> _onFilterByDateRange(FilterByDateRange event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    final result = await getExpensesByDateRange(
      DateRangeParams(startDate: event.startDate, endDate: event.endDate),
    );

    result.fold(
      (failure) => emit(const ExpenseError('Failed to filter expenses')),
      (expenses) {
        final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
        final categoryTotals = _calculateCategoryTotals(expenses);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalAmount: total,
          categoryTotals: categoryTotals,
          filterStartDate: event.startDate,
          filterEndDate: event.endDate,
        ));
      },
    );
  }

  Future<void> _onClearFilters(ClearFilters event, Emitter<ExpenseState> emit) async {
    add(LoadExpenses());
  }

  Map<ExpenseCategory, double> _calculateCategoryTotals(List<Expense> expenses) {
    final Map<ExpenseCategory, double> totals = {};
    for (var expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}
