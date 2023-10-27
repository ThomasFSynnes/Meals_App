import 'package:flutter/material.dart';

import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/utils/persist_favorites.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

/**
 * The main page of the app
 * 
 * displays CategoriesScreen in the scaffold body by defoult
 * adds a bottom navigator bar to swap between all categories and the users favorites
 * 
 * also manages favorite meals 
 * 
 */
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;
  PersistFavorites persistFavorites = PersistFavorites();

  bool _loadPresistence = true;

  // inform user of add/remove favorit
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Add/remove meals frome favorites.
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      persistFavorites.removeFavorites(meal.id);
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      persistFavorites.addFavorites(meal.id);
      _showInfoMessage('Marked as a favorite!');
    }
  }

  // update the app when swaping tabs
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Navigate to FiltersScreen or close the drawer.
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // Get Map of filters on setting on pop
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        // sett to result if any, or use kInitialFilters
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Load meal with filters
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    //Load presistence favorites first time this build loads
    if (_loadPresistence) {
      _loadPresistence = false;

      loadFavorites(availableMeals);
      //.getFavorites() ?? [];
    }

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    // Bottom navigation bar
    Widget navigationBarBottom = BottomNavigationBar(
      onTap: _selectPage,
      currentIndex: _selectedPageIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.set_meal),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favorites',
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: navigationBarBottom,
    );
  }

  void loadFavorites(List<Meal> availableMeals) {
    persistFavorites.getFavorites().then((listOfFavoritMealId) {
      if (listOfFavoritMealId == null) return false;
      List<Meal> loadFavoriteMeals = availableMeals.where((meal) {
        return listOfFavoritMealId.contains(meal.id);
      }).toList();

      _favoriteMeals.addAll(loadFavoriteMeals);
      return null;
    });
  }
}
