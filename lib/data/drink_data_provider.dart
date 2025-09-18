import 'package:ahwa/models/drink.dart';
import 'package:ahwa/models/tea.dart';
import 'package:ahwa/models/turkish_coffe.dart';

class DrinkDataProvider {
  static final List<Drink> _allDrinks = [
    // Turkish Coffee varieties
    TurkishCoffee(name: 'Classic Turkish Coffee', price: 15.0, description: 'Traditional Turkish coffee brewed with finely ground beans'),
    TurkishCoffee(name: 'Strong Turkish Coffee', price: 18.0, description: 'Extra strong Turkish coffee for coffee enthusiasts'),
    TurkishCoffee(name: 'Sweet Turkish Coffee', price: 16.0, description: 'Traditional Turkish coffee with a touch of sweetness'),
    TurkishCoffee(name: 'Cardamom Turkish Coffee', price: 20.0, description: 'Turkish coffee infused with aromatic cardamom'),

    // Tea varieties
    Tea(name: 'Earl Grey Tea', price: 12.0, description: 'Classic black tea with bergamot oil and citrus notes'),
    Tea(name: 'Green Tea', price: 10.0, description: 'Fresh green tea rich in antioxidants'),
    Tea(name: 'Chamomile Tea', price: 11.0, description: 'Relaxing herbal tea with honey notes'),
    Tea(name: 'Mint Tea', price: 9.0, description: 'Refreshing mint tea, perfect for any time'),
    Tea(name: 'Black Tea', price: 8.0, description: 'Strong traditional black tea'),
    Tea(name: 'Jasmine Tea', price: 13.0, description: 'Delicate green tea with jasmine flowers'),
  ];

  static List<Drink> getAllDrinks() => List.unmodifiable(_allDrinks);

  static List<Drink> getTurkishCoffees() => _allDrinks.whereType<TurkishCoffee>().toList();

  static List<Drink> getTeas() => _allDrinks.whereType<Tea>().toList();

  static List<Drink> getFeaturedDrinks() => _allDrinks.take(6).toList();

  static List<Drink> searchDrinks(String query) {
    return _allDrinks.where((drink) => drink.name.toLowerCase().contains(query.toLowerCase()) || drink.description.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
