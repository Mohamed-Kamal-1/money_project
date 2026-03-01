# API Reference - Expense Tracker Services

## FirestoreService

Core data access layer for all Firebase operations. Provides CRUD operations and analytics calculations.

### Transaction Operations

#### `Future<String> addTransaction(Transaction transaction)`
Creates a new transaction in Firestore.
- **Parameters**: `Transaction` model with all required fields
- **Returns**: Document ID of created transaction
- **Throws**: Exception if validation fails or Firestore write fails

#### `Future<void> updateTransaction(String transactionId, Transaction transaction)`
Updates an existing transaction.
- **Parameters**: 
  - `transactionId`: Firestore document ID
  - `transaction`: Updated Transaction model
- **Returns**: None
- **Throws**: Exception if update fails

#### `Future<void> deleteTransaction(String transactionId)`
Deletes a transaction from Firestore.
- **Parameters**: `transactionId`: Firestore document ID
- **Returns**: None

#### `Future<Transaction?> getTransaction(String transactionId)`
Retrieves a single transaction by ID.
- **Parameters**: `transactionId`: Firestore document ID
- **Returns**: Transaction object or null if not found

#### `Stream<List<Transaction>> getUserTransactionsStream(String userId)`
Real-time stream of all transactions for a user, sorted by date (newest first).
- **Parameters**: `userId`: User identifier
- **Returns**: Stream<List<Transaction>>
- **Usage**: Wrap with StreamBuilder for reactive UI

#### `Stream<List<Transaction>> getMonthTransactionsStream(String userId, int month, int year)`
Real-time stream of transactions for a specific month.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY format
- **Returns**: Stream<List<Transaction>>
- **Note**: Used for monthly analytics calculations

#### `Stream<List<Transaction>> getCategoryTransactionsStream(String userId, String categoryId)`
Real-time stream of transactions for a specific category.
- **Parameters**: 
  - `userId`: User identifier
  - `categoryId`: Category document ID
- **Returns**: Stream<List<Transaction>>

---

### Category Operations

#### `Future<String> addCategory(Category category)`
Creates a new category.
- **Parameters**: `Category` model
- **Returns**: Created category ID
- **Note**: Category includes colorValue (Color.value) and iconName (codePoint string)

#### `Future<void> updateCategory(String categoryId, Category category)`
Updates a category.
- **Parameters**: 
  - `categoryId`: Firestore document ID
  - `category`: Updated Category model

#### `Future<void> deleteCategory(String categoryId)`
Deletes a category.
- **Parameters**: `categoryId`: Firestore document ID
- **Note**: Consider handling orphaned transactions

#### `Stream<List<Category>> getUserCategoriesStream(String userId)`
Real-time stream of all categories for a user.
- **Parameters**: `userId`: User identifier
- **Returns**: Stream<List<Category>>

#### `Future<Category?> getCategory(String categoryId)`
Retrieves a single category by ID.
- **Parameters**: `categoryId`: Firestore document ID
- **Returns**: Category object or null

---

### User Settings Operations

#### `Future<void> saveUserSettings(UserSettings settings)`
Saves user preferences to Firestore.
- **Parameters**: `UserSettings` model (darkMode, notificationsEnabled, currency, monthlyBudget)
- **Returns**: None
- **Note**: Also updates local SharedPreferences

#### `Future<UserSettings?> getUserSettings(String userId)`
Retrieves user settings (one-time fetch).
- **Parameters**: `userId`: User identifier
- **Returns**: UserSettings object or null

#### `Stream<UserSettings?> getUserSettingsStream(String userId)`
Real-time stream of user settings.
- **Parameters**: `userId`: User identifier
- **Returns**: Stream<UserSettings?>
- **Usage**: Allows live UI updates when settings change

---

### Monthly Report Operations

#### `Future<String> addMonthlyReport(MonthlyReport report)`
Creates a monthly report record.
- **Parameters**: `MonthlyReport` model
- **Returns**: Report document ID

#### `Future<void> updateMonthlyReport(String reportId, MonthlyReport report)`
Updates an existing monthly report.
- **Parameters**: 
  - `reportId`: Firestore document ID
  - `report`: Updated MonthlyReport

#### `Future<MonthlyReport?> getMonthlyReport(String userId, int month, int year)`
Retrieves a specific monthly report.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: MonthlyReport or null

#### `Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId)`
Real-time stream of all monthly reports for a user.
- **Parameters**: `userId`: User identifier
- **Returns**: Stream<List<MonthlyReport>>

#### `Stream<List<MonthlyReport>> getYearMonthlyReportsStream(String userId, int year)`
Real-time stream of reports for a specific year.
- **Parameters**: 
  - `userId`: User identifier
  - `year`: YYYY
- **Returns**: Stream<List<MonthlyReport>>

---

### Analytics Operations

#### `Future<double> calculateMonthTotal(String userId, int month, int year)`
Sums all transaction amounts for a month.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: Total as double
- **Example**: 2847.50

#### `Future<double> calculateDailyAverage(String userId, int month, int year)`
Calculates average daily spending for a month.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: Daily average as double
- **Calculation**: monthTotal / daysInMonth
- **Example**: 94.92

#### `Future<double> getPercentageChange(String userId, int currentMonth, int currentYear, int previousMonth, int previousYear)`
Compares spending between two months.
- **Parameters**: 
  - `userId`: User identifier
  - Current and previous month/year (1-12, YYYY)
- **Returns**: Percentage change as double
- **Example**: -8.9 (8.9% decrease, negative indicates less spending)
- **Formula**: (current - previous) / previous * 100

#### `Future<Map<String, double>> getCategorySpending(String userId, int month, int year)`
Calculates total spending per category for a month.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: Map<categoryName, totalAmount>
- **Example**: 
  ```dart
  {
    'Food & Dining': 842.00,
    'Transport': 456.00,
    'Entertainment': 234.50
  }
  ```

#### `Future<String> analyzSpendingBehavior(String userId, int month, int year)`
Analyzes spending patterns (weekday vs weekend).
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: Human-readable insight string
- **Examples**: 
  - "Higher spending on weekends"
  - "Balanced spending throughout the week"
  - "More expenses on weekdays"

#### `Future<String> getTopSpendingCategory(String userId, int month, int year)`
Identifies category with highest spending.
- **Parameters**: 
  - `userId`: User identifier
  - `month`: 1-12
  - `year`: YYYY
- **Returns**: Category name (string)
- **Example**: "Food & Dining"

---

## State Management Notifiers

### TransactionNotifier

Extends `ChangeNotifier`. Manages transaction state and operations.

#### Properties
```dart
List<Transaction> get transactions => _transactions;
bool get isLoading => _isLoading;
String? get error => _error;
```

#### Methods

##### `Future<void> addTransaction(Transaction transaction)`
Adds transaction to Firestore and updates local state.
- **Parameters**: `Transaction` object
- **Triggers**: `notifyListeners()` after completion
- **Error Handling**: Sets `_error` field if operation fails

##### `Future<void> updateTransaction(String transactionId, Transaction transaction)`
Updates transaction and refreshes state.

##### `Future<void> deleteTransaction(String transactionId)`
Deletes transaction and updates state.

##### `Stream<List<Transaction>> getMonthTransactionsStream(String userId, int month, int year)`
Returns Firestore stream for reactive UI binding.

---

### CategoryNotifier

Extends `ChangeNotifier`. Manages category state and operations.

#### Properties
```dart
List<Category> get categories => _categories;
bool get isLoading => _isLoading;
String? get error => _error;
```

#### Methods

##### `Future<void> addCategory(Category category)`
Creates new category in Firestore.

##### `Future<void> updateCategory(String categoryId, Category category)`
Updates category properties.

##### `Future<void> deleteCategory(String categoryId)`
Deletes category (handle orphaned transactions).

##### `Stream<List<Category>> getCategoriesStream(String userId)`
Real-time stream of user's categories.

---

### AnalyticsNotifier

Extends `ChangeNotifier`. Aggregates financial analytics data.

#### Properties
```dart
double get monthTotal => _monthTotal;
double get dailyAverage => _dailyAverage;
double get percentageChange => _percentageChange;
String? get topCategory => _topCategory;
String? get spendingBehavior => _spendingBehavior;
Map<String, double> get categorySpending => _categorySpending;
bool get isLoading => _isLoading;
String? get error => _error;
```

#### Methods

##### `Future<void> loadAnalytics(String userId, int month, int year)`
Aggregates all analytics data for a month.
- **Executes in parallel**:
  - `_loadMonthTotal()`
  - `_loadDailyAverage()`
  - `_loadPercentageChange()`
  - `_loadTopCategory()`
  - `_loadSpendingBehavior()`
  - `_loadCategorySpending()`
- **Triggers**: Single `notifyListeners()` after all futures complete
- **Error Handling**: Catches exceptions and stores in `_error`
- **Loading State**: Sets `_isLoading = true` during execution

##### `Future<void> _loadMonthTotal(String userId, int month, int year)`
Private method that updates `_monthTotal`.

##### `Future<void> _loadDailyAverage(String userId, int month, int year)`
Private method that updates `_dailyAverage`.

##### `Future<void> _loadPercentageChange(String userId, int month, int year)`
Private method that updates `_percentageChange` (compares with previous month).

##### `Future<void> _loadTopCategory(String userId, int month, int year)`
Private method that updates `_topCategory`.

##### `Future<void> _loadSpendingBehavior(String userId, int month, int year)`
Private method that updates `_spendingBehavior`.

##### `Future<void> _loadCategorySpending(String userId, int month, int year)`
Private method that updates `_categorySpending` Map.

#### Usage Example
```dart
final notifier = context.read<AnalyticsNotifier>();
await notifier.loadAnalytics('user_123', 1, 2026);

print('Total: \$${notifier.monthTotal}');  // Output: Total: $2847.50
print('Daily avg: \$${notifier.dailyAverage}');  // Daily avg: $94.92
print('Top: ${notifier.topCategory}');  // Top: Food & Dining

// In UI with Consumer
Consumer<AnalyticsNotifier>(builder: (context, analytics, _) {
  if (analytics.isLoading) return const CircularProgressIndicator();
  if (analytics.error != null) return Text('Error: ${analytics.error}');
  
  return Column(
    children: [
      Text('Month Total: \$${analytics.monthTotal}'),
      Text('Daily Average: \$${analytics.dailyAverage}'),
    ],
  );
})
```

---

### UserSettingsNotifier

Extends `ChangeNotifier`. Manages user preferences.

#### Properties
```dart
bool get darkMode => _darkMode;
bool get notificationsEnabled => _notificationsEnabled;
String? get currency => _currency;
double? get monthlyBudget => _monthlyBudget;
bool get isLoading => _isLoading;
String? get error => _error;
```

#### Methods

##### `Future<void> saveUserSettings(UserSettings settings)`
Persists settings to Firestore and SharedPreferences.

##### `Future<UserSettings?> getUserSettings(String userId)`
Single-fetch of user settings.

##### `Stream<UserSettings?> getUserSettingsStream(String userId)`
Real-time stream of user settings changes.

##### `Future<void> updateDarkMode(bool value)`
Updates dark mode preference.

##### `Future<void> updateNotifications(bool value)`
Updates notification preference.

---

### MonthlyReportNotifier

Extends `ChangeNotifier`. Manages monthly report data.

#### Properties
```dart
MonthlyReport? get currentReport => _currentReport;
List<MonthlyReport> get reports => _reports;
bool get isLoading => _isLoading;
String? get error => _error;
```

#### Methods

##### `Future<void> loadReport(String userId, int month, int year)`
Fetches or generates a monthly report.

##### `Future<void> addReport(MonthlyReport report)`
Creates new monthly report.

---

## Data Models API

### Transaction Model

```dart
class Transaction {
  final String id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final double amount;
  final String description;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
}
```

**Methods**:
- `Map<String, dynamic> toJson()` - Serialize to Firestore
- `factory Transaction.fromJson(Map<String, dynamic> json)` - Deserialize
- `factory Transaction.fromFirestore(DocumentSnapshot doc)` - Direct Firestore parsing
- `Transaction copyWith({...})` - Create modified copy

---

### Category Model

```dart
class Category {
  final String id;
  final String userId;
  final String name;
  final int colorValue;  // Stored as Color.value
  final String iconName;  // Icon codepoint as string
  final double? budget;
  final DateTime createdAt;
  
  Color get color => Color(colorValue);  // Getter for Color object
}
```

**Methods**:
- `toJson()` / `fromJson()` - Firestore serialization
- `copyWith()` - Immutable updates

---

### UserSettings Model

```dart
class UserSettings {
  final String userId;
  final bool darkMode;
  final bool notificationsEnabled;
  final String currency;  // e.g., "USD", "EUR"
  final double monthlyBudget;
  final DateTime updatedAt;
}
```

---

### MonthlyReport Model

```dart
class MonthlyReport {
  final String id;
  final String userId;
  final int month;  // 1-12
  final int year;   // YYYY
  final double totalExpenses;
  final double dailyAverage;
  final double percentageChange;  // vs previous month
  final Map<String, double> categoryBreakdown;  // name -> amount
  final String spendingBehavior;  // Insight string
  final DateTime createdAt;
}
```

---

## Consumer Widget Usage

### Basic Consumer Pattern
```dart
Consumer<AnalyticsNotifier>(
  builder: (context, analytics, child) {
    if (analytics.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (analytics.error != null) {
      return Text('Error: ${analytics.error}');
    }
    
    return Text('Total: \$${analytics.monthTotal}');
  },
)
```

### Multiple Notifiers
```dart
Consumer2<CategoryNotifier, TransactionNotifier>(
  builder: (context, categories, transactions, child) {
    return Text('${categories.categories.length} categories, '
                '${transactions.transactions.length} transactions');
  },
)
```

---

## Error Handling Patterns

### Try-Catch in Notifiers
```dart
try {
  // Operation
  notifyListeners();
} catch (e) {
  _error = e.toString();
  notifyListeners();
}
```

### UI Error Display
```dart
if (notifier.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${notifier.error}'))
  );
}
```

---

## Stream vs Future Usage

### Use Streams For
- Real-time data updates (transaction list, categories)
- UI that needs to react to changes
- Long-running data subscriptions

### Use Futures For
- One-time calculations (analytics)
- Single data fetches
- Operations that complete once

---

## Performance Tips

1. **Avoid N+1 Queries**: Load related data in parallel with `Future.wait()`
2. **Index Firestore Queries**: Especially by userId and date
3. **Pagination**: Load transactions in batches for better performance
4. **Caching**: Consider caching monthly reports to reduce recalculations
5. **Lazy Loading**: Load analytics only when screen is viewed

---

## Firestore Indexes

Recommended composite indexes for optimal performance:

1. **transactions**: (userId, date DESC)
2. **categories**: (userId, createdAt DESC)
3. **settings**: (userId)
4. **reports**: (userId, month, year)

---

## Version History

- **v1.0.0** (Feb 26, 2026): Initial complete implementation
  - CRUD operations with Firestore
  - Analytics calculations
  - Real-time streams
  - 5 state notifiers
  - UI integration

---

**Last Updated**: February 26, 2026
