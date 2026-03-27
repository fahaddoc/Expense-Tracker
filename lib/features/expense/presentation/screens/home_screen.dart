import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/total_expense_card.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          // Theme Toggle Button
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                tooltip: 'Toggle Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ExpenseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseBloc>().add(LoadExpenses());
              },
              child: CustomScrollView(
                slivers: [
                  // Total Expense Card
                  SliverToBoxAdapter(
                    child: TotalExpenseCard(
                      totalAmount: state.totalAmount,
                      subtitle: state.filterCategory != null
                          ? 'Filtered by ${state.filterCategory!.displayName}'
                          : 'All expenses',
                    ),
                  ),

                  // Category Filter
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CategoryChipList(
                        selectedCategory: state.filterCategory,
                        onCategorySelected: (category) {
                          context.read<ExpenseBloc>().add(FilterByCategory(category));
                        },
                      ),
                    ),
                  ),

                  // Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${state.expenses.length} items',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expense List
                  if (state.expenses.isEmpty)
                    SliverFillRemaining(
                      child: EmptyState(
                        title: 'No expenses yet',
                        subtitle: 'Add your first expense to start tracking',
                        onActionPressed: () => _navigateToAddExpense(context),
                        actionLabel: 'Add Expense',
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final expense = state.expenses[index];
                          return ExpenseCard(
                            expense: expense,
                            onTap: () => _navigateToEditExpense(context, expense),
                            onDelete: () => _showDeleteDialog(context, expense.id!),
                          );
                        },
                        childCount: state.expenses.length,
                      ),
                    ),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddExpense(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );
  }

  void _navigateToEditExpense(BuildContext context, expense) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: expense)),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpenseEvent(id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
