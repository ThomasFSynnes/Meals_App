import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/utils/persist_favorites.dart';

class RatingDropdown extends StatefulWidget {
  const RatingDropdown({
    super.key,
    required this.meal,
  });

  final Meal meal;


  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<RatingDropdown> {
  Rating _selectedRating = Rating.none;
  PersistFavorites persistFavorites = PersistFavorites();
  int rating = 0;
  
  
  @override
  Widget build(BuildContext context) {
    
    persistFavorites.getRating("m2").then((value) {
      rating = value;
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Rating:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<Rating>(
              value: _selectedRating, // none by default
              items: Rating.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
                onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedRating = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}