import 'package:flutter/material.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
  String name;
  String image;
  double preperationTime;
  double cookingTime;
  double totalTime;
  double servings;
  List<List<String>> ingredientsList;
  List<String> ingredientsGlossary = new List<String>();
  List<List<double>> amount = new List<List<double>>();
  List<List<String>> unit = new List<List<String>>();
  Vegetable vegetable;
  List<String> steps = new List<String>();
  String notes;
  // TODO: add categories

  Recipe(
      {this.id,
      this.name,
      this.image,
      this.preperationTime,
      this.cookingTime,
      this.totalTime,
      this.servings,
      this.ingredientsGlossary,
      this.ingredientsList,
      this.amount,
      this.unit,
      this.vegetable,
      this.steps,
      this.notes});

  factory Recipe.fromMap(Map<String, dynamic> json) => new Recipe(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        preperationTime: json["preperationTime"],
        cookingTime: json["cookingTime"],
        totalTime: json["totalTime"],
        servings: json["servings"],
        ingredientsGlossary: json["ingredientsGlossary"],
        ingredientsList: json["ingredientsList"],
        amount: json["amount"],
        unit: json["unit"],
        vegetable: json["vegetable"],
        steps: json["steps"],
        notes: json["notes"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "preperationTime": preperationTime,
        "cookingTime": cookingTime,
        "totalTime": totalTime,
        "servings": servings,
        "ingredientsGlossary": ingredientsGlossary,
        "ingredientsList": ingredientsList,
        "amount": amount,
        "unit": unit,
        "vegetable": vegetable,
        "steps": steps,
        "notes": notes
      };
}
