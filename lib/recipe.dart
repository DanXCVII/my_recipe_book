import 'package:flutter/material.dart';
import "dart:io";

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
  String name;
  File image;
  double preperationTime;
  double cookingTime;
  double totalTime;
  double servings;
  List<String> categories;
  List<List<String>> ingredientsList;
  List<String> ingredientsGlossary = new List<String>();
  List<List<double>> amount = new List<List<double>>();
  List<List<String>> unit = new List<List<String>>();
  Vegetable vegetable;
  List<String> steps = new List<String>();
  List<List<File>> stepImages = new List<List<File>>();
  String notes;
  // TODO: add categories

  Recipe(
      {@required this.id,
      @required this.name,
      this.image,
      this.preperationTime,
      this.cookingTime,
      this.totalTime,
      @required this.servings,
      this.ingredientsGlossary,
      this.ingredientsList,
      @required this.amount,
      this.unit,
      @required this.vegetable,
      this.steps,
      this.stepImages,
      this.notes,
      this.categories});

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

class Categories {
  static List<String> _categories;

  Categories({List<String> categories});

  static void setCategories(List<String> categories) {
    _categories = categories;
  }

  static void removeCategory(String name) {
    _categories.remove(name);
  }

  static void addCategory(String name) {
    _categories == null? _categories = [name]: _categories.add(name);
  }

  static List<String> getCategories() {
    if (_categories == null)
      return new List<String>();
    else
      return _categories;
  }
}
