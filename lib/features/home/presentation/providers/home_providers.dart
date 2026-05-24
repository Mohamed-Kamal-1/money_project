import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money/features/home/data/home_repository.dart';
import 'package:money/features/home/domain/models/category_model.dart';
import 'package:money/features/home/domain/models/monthly_report_model.dart';
import 'package:money/features/home/domain/models/transaction_model.dart';
import 'package:money/features/home/domain/models/user_settings_model.dart';

// ==================== BALANCE NOTIFIER ====================

class BalanceNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  double _balance = 0.0;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<double>? _balanceSubscription;

  BalanceNotifier(this._repository);

  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Start listening to balance changes in real-time
  void listenToBalance(String userId) {
    _balanceSubscription?.cancel();
    _balanceSubscription = _repository
        .getUserBalanceStream(userId)
        .listen(
          (balance) {
            _balance = balance;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            notifyListeners();
          },
        );
  }

  /// Update balance manually
  Future<void> updateBalance(String userId, double newBalance) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.updateUserBalance(userId, newBalance);
      _balance = newBalance;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Adjust balance when a transaction is added
  void adjustBalanceForTransaction(String userId, double amount, String type) {
    if (type == 'income') {
      _balance += amount;
    } else {
      _balance -= amount;
    }
    notifyListeners();
    // Persist async
    _repository.updateUserBalance(userId, _balance);
  }

  /// Adjust balance when a transaction is deleted
  void reverseBalanceForTransaction(String userId, double amount, String type) {
    if (type == 'income') {
      _balance -= amount;
    } else {
      _balance += amount;
    }
    notifyListeners();
    _repository.updateUserBalance(userId, _balance);
  }

  @override
  void dispose() {
    _balanceSubscription?.cancel();
    super.dispose();
  }
}

// ==================== TRANSACTION NOTIFIER ====================

class TransactionNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  final List<AppTransaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionNotifier(this._repository);

  List<AppTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  ) {
    return _repository.getMonthTransactionsStream(userId, month, year);
  }

  Stream<List<AppTransaction>> getUserTransactionsStream(String userId) {
    return _repository.getUserTransactionsStream(userId);
  }

  Future<String> addTransaction(AppTransaction transaction) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final id = await _repository.addTransaction(transaction);
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> addTransactionWithBalanceUpdate(AppTransaction transaction) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final id = await _repository.addTransactionWithBalanceUpdate(transaction);
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(AppTransaction transaction) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.updateTransaction(transaction);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteTransaction(transactionId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

// ==================== CATEGORY NOTIFIER ====================

class CategoryNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  CategoryNotifier(this._repository);

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Start listening to categories from Firestore in real-time
  void listenToCategories(String userId) {
    _isLoading = true;
    notifyListeners();

    _categoriesSubscription?.cancel();
    _categoriesSubscription = _repository
        .getUserCategoriesStream(userId)
        .listen(
          (categories) {
            _categories = categories;
            _isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  Stream<List<Category>> getUserCategoriesStream(String userId) {
    return _repository.getUserCategoriesStream(userId);
  }

  Future<String> addCategory(Category category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final id = await _repository.addCategory(category);
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.updateCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteCategory(categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}

// ==================== MONTHLY REPORT NOTIFIER ====================

class MonthlyReportNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  final List<MonthlyReport> _reports = [];
  MonthlyReport? _currentReport;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<MonthlyReport>>? _reportsSubscription;

  MonthlyReportNotifier(this._repository);

  List<MonthlyReport> get reports => _reports;
  MonthlyReport? get currentReport => _currentReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Listen to all reports for navigation in "Previous Reports" section
  void listenToReports(String userId) {
    _reportsSubscription?.cancel();
    _reportsSubscription = _repository
        .getUserMonthlyReportsStream(userId)
        .listen(
          (reports) {
            _reports.clear();
            _reports.addAll(reports);
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            notifyListeners();
          },
        );
  }

  Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId) {
    return _repository.getUserMonthlyReportsStream(userId);
  }

  Future<MonthlyReport?> getMonthlyReport(
    String userId,
    int month,
    int year,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentReport = await _repository.getMonthlyReport(userId, month, year);
      _isLoading = false;
      notifyListeners();
      return _currentReport;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> addMonthlyReport(MonthlyReport report) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final id = await _repository.addMonthlyReport(report);
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }
}

// ==================== ANALYTICS NOTIFIER ====================

class AnalyticsNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  double _monthTotal = 0;
  double _monthIncome = 0;
  double _dailyAverage = 0;
  double _percentageChange = 0;
  String _spendingBehavior = '';
  String _topCategory = '';
  Map<String, double> _categorySpending = {};
  int _transactionCount = 0;
  bool _isLoading = false;
  String? _error;

  AnalyticsNotifier(this._repository);

  double get monthTotal => _monthTotal;
  double get monthIncome => _monthIncome;
  double get dailyAverage => _dailyAverage;
  double get percentageChange => _percentageChange;
  String get spendingBehavior => _spendingBehavior;
  String get topCategory => _topCategory;
  Map<String, double> get categorySpending => _categorySpending;
  int get transactionCount => _transactionCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAnalytics(String userId, int month, int year) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _loadMonthTotal(userId, month, year),
        _loadMonthIncome(userId, month, year),
        _loadDailyAverage(userId, month, year),
        _loadPercentageChange(userId, month, year),
        _loadSpendingBehavior(userId, month, year),
        _loadTopCategory(userId, month, year),
        _loadCategorySpending(userId, month, year),
        _loadTransactionCount(userId, month, year),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadMonthTotal(String userId, int month, int year) async {
    _monthTotal = await _repository.calculateMonthTotal(userId, month, year);
  }

  Future<void> _loadMonthIncome(String userId, int month, int year) async {
    _monthIncome = await _repository.calculateMonthIncome(userId, month, year);
  }

  Future<void> _loadDailyAverage(String userId, int month, int year) async {
    _dailyAverage = await _repository.calculateDailyAverage(
      userId,
      month,
      year,
    );
  }

  Future<void> _loadPercentageChange(String userId, int month, int year) async {
    _percentageChange = await _repository.getPercentageChange(
      userId,
      month,
      year,
    );
  }

  Future<void> _loadSpendingBehavior(String userId, int month, int year) async {
    _spendingBehavior = await _repository.analyzSpendingBehavior(
      userId,
      month,
      year,
    );
  }

  Future<void> _loadTopCategory(String userId, int month, int year) async {
    _topCategory = await _repository.getTopSpendingCategory(
      userId,
      month,
      year,
    );
  }

  Future<void> _loadCategorySpending(String userId, int month, int year) async {
    _categorySpending = await _repository.getCategorySpending(
      userId,
      month,
      year,
    );
  }

  Future<void> _loadTransactionCount(String userId, int month, int year) async {
    _transactionCount = await _repository.getTransactionCount(
      userId,
      month,
      year,
    );
  }
}

// ==================== USER SETTINGS NOTIFIER ====================

class UserSettingsNotifier extends ChangeNotifier {
  final HomeRepository _repository;
  UserSettings? _settings;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<UserSettings?>? _settingsSubscription;

  UserSettingsNotifier(this._repository);

  UserSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Listen to settings changes in real-time
  void listenToSettings(String userId) {
    _settingsSubscription?.cancel();
    _settingsSubscription = _repository
        .getUserSettingsStream(userId)
        .listen(
          (settings) {
            _settings = settings;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            notifyListeners();
          },
        );
  }

  Stream<UserSettings?> getUserSettingsStream(String userId) {
    return _repository.getUserSettingsStream(userId);
  }

  Future<void> saveUserSettings(UserSettings settings) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.saveUserSettings(settings);
      _settings = settings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Toggle dark mode and save
  Future<void> toggleDarkMode(String userId, bool value) async {
    final updated = (_settings ?? UserSettings(userId: userId)).copyWith(
      darkMode: value,
    );
    await saveUserSettings(updated);
  }

  /// Toggle notifications and save
  Future<void> toggleNotifications(String userId, bool value) async {
    final updated = (_settings ?? UserSettings(userId: userId)).copyWith(
      notificationsEnabled: value,
    );
    await saveUserSettings(updated);
  }

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    super.dispose();
  }
}
