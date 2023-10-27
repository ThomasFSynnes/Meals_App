import 'package:flutter/material.dart';

import 'package:meals_app/models/meal.dart';

/**
 * Display a meal with titel, image, ingredients and meal steps
 */
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
  });

  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    // App bar with meal title and favorite button
    var mealTitle = AppBar(title: Text(meal.title), actions: [
      IconButton(
        onPressed: () {
          onToggleFavorite(meal);
        },
        icon: const Icon(Icons.star),
      )
    ]);

    // Meal Image
    var mealImage = Image.network(
      meal.imageUrl,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
    );

    // Meal ingredients title
    var mealIngredientsTitle = Text(
      'Ingredients',
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );

    // Meal Ingredients
    Text mealIngredient(String ingredient) {
      return Text(
        ingredient,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      );
    }

    // Meal steps tile
    var mealStepsTitle = Text(
      'Steps',
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );

    // Meal steps
    Padding mealSteps(String step) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          step,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return Scaffold(
        appBar: mealTitle,
        body: SingleChildScrollView(
          child: Column(
            children: [
              mealImage,
              const SizedBox(height: 14),
              mealIngredientsTitle,
              const SizedBox(height: 14),
              for (final ingredient in meal.ingredients)
                mealIngredient(ingredient),
              const SizedBox(height: 24),
              mealStepsTitle,
              const SizedBox(height: 14),
              for (final step in meal.steps) mealSteps(step),
            ],
          ),
        ));
  }
}
