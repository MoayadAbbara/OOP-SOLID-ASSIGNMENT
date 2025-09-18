# Smart Ahwa Manager 🏪☕

A professional Flutter application designed for Cairo ahwa owners to streamline operations, manage customer orders, track popular items, and generate daily sales reports. Built with robust OOP principles and SOLID design patterns to ensure maintainable, scalable, and efficient business management.

## Features ✨

- **Order Management**: Add orders with customer names, drink selections, and special instructions ("extra mint, ya rais")
- **Real-time Dashboard**: View pending orders with detailed information and quick completion actions
- **Sales Analytics**: Generate comprehensive reports showing top-selling drinks and revenue analytics
- **Smart Categorization**: Organized drink menu with Turkish coffee and tea varieties
- **Intuitive UI**: Clean, professional interface with Cairo ahwa-inspired theming

## Architecture & Design Principles 🏗️

### Core OOP Concepts Implemented

#### 1. **Inheritance** 🧬

The application demonstrates classical inheritance through the drink hierarchy:

```dart
// Base class
class Drink {
  final String name;
  final double price;
  final String description;
}

// Specialized drink types inheriting from base Drink class
class Tea extends Drink {
  Tea({required super.name, required super.price, required super.description});
}

class TurkishCoffee extends Drink {
  TurkishCoffee({required super.name, required super.price, required super.description});
}
```

**Implementation Benefits:**

- **Code Reusability**: Common drink properties (name, price, description) are defined once in the base class
- **Logical Hierarchy**: Clear taxonomical organization reflecting real-world drink categories
- **Extensibility**: New drink types can be easily added by extending the Drink base class

#### 2. **Polymorphism** 🎭

Polymorphic behavior is achieved through:

```dart
// List can hold different drink types, all treated uniformly as Drink objects
final List<Drink> _allDrinks = [
  TurkishCoffee(name: 'Classic Turkish Coffee', price: 15.0, description: '...'),
  Tea(name: 'Earl Grey Tea', price: 12.0, description: '...'),
  // Both types handled identically despite being different classes
];

// Runtime type checking for specialized behavior
static List<Drink> getTurkishCoffees() => _allDrinks.whereType<TurkishCoffee>().toList();
static List<Drink> getTeas() => _allDrinks.whereType<Tea>().toList();
```

**Real-world Application:**

- Order processing treats all drinks uniformly regardless of specific type
- Menu categorization leverages runtime type identification
- Price calculations work seamlessly across all drink varieties

#### 3. **Encapsulation** 🔒

Strong encapsulation principles throughout the codebase:

```dart
class DrinkDataProvider {
  // Private data - external classes cannot directly modify the drinks list
  static final List<Drink> _allDrinks = [...];

  // Controlled access through public methods with immutable returns
  static List<Drink> getAllDrinks() => List.unmodifiable(_allDrinks);
}

class OrderServiceImpl implements OrderService {
  // Private order storage - internal state hidden from external classes
  final List<Order> _orders = [];

  // Public interface provides controlled access to functionality
  @override
  bool addOrder(Order order) { /* controlled access */ }
}
```

**Security & Integrity Benefits:**

- Data integrity protection through private fields
- Controlled access via public methods
- Immutable data returns prevent external modification

#### 4. **Abstraction** 🎨

Multiple levels of abstraction create clean, maintainable interfaces:

```dart
// High-level service abstractions hide implementation complexity
abstract class OrderService {
  bool addOrder(Order order);
  List<Order> getOrders();
  bool removeOrder(String orderId);
  bool completeOrder(String orderId);
}

abstract class ReportService {
  Map<Drink, int> generateReport(List<Order> orders);
}
```

**Abstraction Benefits:**

- Interface segregation allows easy testing and mocking
- Implementation details hidden from consuming code
- Easy swapping of concrete implementations (database vs. memory storage)

### SOLID Principles Implementation 🛡️

#### 1. **Single Responsibility Principle (SRP)** ✅

Each class has a single, well-defined responsibility:

- **`Drink`**: Represents drink data and properties only
- **`Order`**: Manages order information and status
- **`OrderService`**: Handles order CRUD operations exclusively
- **`ReportService`**: Focuses solely on analytics and reporting
- **`DrinkDataProvider`**: Dedicated to drink data management
- **`OrderCubit`**: State management for order-related UI updates
- **`AppTheme`**: Centralizes all styling and theming concerns

#### 2. **Open/Closed Principle (OCP)** ✅

The system is open for extension but closed for modification:

```dart
// Easy to extend with new drink types without modifying existing code
class HerbalTea extends Drink {
  HerbalTea({required super.name, required super.price, required super.description});
}

// New service implementations can be added without changing interfaces
class DatabaseOrderService implements OrderService {
  // New implementation without modifying the interface
}
```

#### 3. **Liskov Substitution Principle (LSP)** ✅

Derived classes can replace base classes without breaking functionality:

```dart
// Any Drink subclass can substitute the base class seamlessly
List<Drink> drinks = [
  Tea(...),           // Can substitute Drink
  TurkishCoffee(...), // Can substitute Drink
];

// All implementations properly substitute their abstractions
OrderService orderService = OrderServiceImpl(); // Substitutes OrderService
ReportService reportService = ReportServiceImpl(); // Substitutes ReportService
```

#### 4. **Interface Segregation Principle (ISP)** ✅

Clients depend only on interfaces they actually use:

```dart
// OrderService provides only order-related operations
abstract class OrderService {
  bool addOrder(Order order);
  List<Order> getOrders();
  bool removeOrder(String orderId);
  bool completeOrder(String orderId);
}

// ReportService provides only reporting operations
abstract class ReportService {
  Map<Drink, int> generateReport(List<Order> orders);
}
```

#### 5. **Dependency Inversion Principle (DIP)** ✅

High-level modules depend on abstractions, not concretions:

```dart
class OrderCubit extends Cubit<OrderState> {
  // Depends on abstractions, not concrete implementations
  final OrderService orderService;      // Abstract interface
  final ReportService reportService;    // Abstract interface

  OrderCubit({required this.orderService, required this.reportService});
}

// Dependency injection in main.dart
BlocProvider(
  create: (context) => OrderCubit(
    orderService: OrderServiceImpl(),    // Concrete implementation injected
    reportService: ReportServiceImpl(),  // Concrete implementation injected
  ),
)
```
### Project Structure

```
lib/
├── constants/          # App theming and constants
├── cubits/            # State management (BLoC pattern)
├── data/              # Data providers and repositories
├── enums/             # Application enumerations
├── models/            # Data models and entities
├── screens/           # UI screens and pages
├── services/          # Business logic and services
└── widgets/           # Reusable UI components
```

