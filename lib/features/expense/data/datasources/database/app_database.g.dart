// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expenses` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `amount` REAL NOT NULL, `category` TEXT NOT NULL, `date` INTEGER NOT NULL, `description` TEXT, `created_at` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expenseModelInsertionAdapter = InsertionAdapter(
            database,
            'expenses',
            (ExpenseModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'category': item.categoryString,
                  'date': item.dateTimestamp,
                  'description': item.description,
                  'created_at': item.createdAtTimestamp
                }),
        _expenseModelUpdateAdapter = UpdateAdapter(
            database,
            'expenses',
            ['id'],
            (ExpenseModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'category': item.categoryString,
                  'date': item.dateTimestamp,
                  'description': item.description,
                  'created_at': item.createdAtTimestamp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExpenseModel> _expenseModelInsertionAdapter;

  final UpdateAdapter<ExpenseModel> _expenseModelUpdateAdapter;

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    return _queryAdapter.queryList('SELECT * FROM expenses ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            categoryString: row['category'] as String,
            dateTimestamp: row['date'] as int,
            description: row['description'] as String?,
            createdAtTimestamp: row['created_at'] as int));
  }

  @override
  Future<ExpenseModel?> getExpenseById(int id) async {
    return _queryAdapter.query('SELECT * FROM expenses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ExpenseModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            categoryString: row['category'] as String,
            dateTimestamp: row['date'] as int,
            description: row['description'] as String?,
            createdAtTimestamp: row['created_at'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM expenses WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE category = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            categoryString: row['category'] as String,
            dateTimestamp: row['date'] as int,
            description: row['description'] as String?,
            createdAtTimestamp: row['created_at'] as int),
        arguments: [category]);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
    int startDate,
    int endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE date BETWEEN ?1 AND ?2 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as int?, title: row['title'] as String, amount: row['amount'] as double, categoryString: row['category'] as String, dateTimestamp: row['date'] as int, description: row['description'] as String?, createdAtTimestamp: row['created_at'] as int),
        arguments: [startDate, endDate]);
  }

  @override
  Future<double?> getTotalExpenses() async {
    return _queryAdapter.query('SELECT SUM(amount) FROM expenses',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<int> insertExpense(ExpenseModel expense) {
    return _expenseModelInsertionAdapter.insertAndReturnId(
        expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expenseModelUpdateAdapter.update(expense, OnConflictStrategy.abort);
  }
}
