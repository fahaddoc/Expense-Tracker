import 'package:get_it/get_it.dart';
import 'features/expense/data/datasources/database/app_database.dart';
import 'features/expense/data/datasources/expense_local_datasource.dart';
import 'features/expense/data/repositories/expense_repository_impl.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/add_expense.dart';
import 'features/expense/domain/usecases/delete_expense.dart';
import 'features/expense/domain/usecases/get_all_expenses.dart';
import 'features/expense/domain/usecases/get_expenses_by_category.dart';
import 'features/expense/domain/usecases/get_expenses_by_date_range.dart';
import 'features/expense/domain/usecases/update_expense.dart';
import 'features/expense/presentation/bloc/expense_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => ExpenseBloc(
      getAllExpenses: sl(),
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
      getExpensesByCategory: sl(),
      getExpensesByDateRange: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllExpenses(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => GetExpensesByCategory(sl()));
  sl.registerLazySingleton(() => GetExpensesByDateRange(sl()));

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(database: sl()),
  );

  // Database
  final database = await AppDatabase.getInstance();
  sl.registerLazySingleton(() => database);
}
