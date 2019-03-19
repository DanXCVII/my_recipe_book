import 'package:flutter/material.dart';

enum Vegetable { non_vegetarian, vegetarian, vegan }

class Recipe {
  String name;
  Image image;
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
      {this.name,
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

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  void setPreperationTime(double preperationTime) {
    this.preperationTime = preperationTime;
  }

  double getPreperationTime() {
    return preperationTime;
  }

  void setCookingTime(double cookingTime) {
    this.cookingTime = cookingTime;
  }

  double getCookingTime() {
    return cookingTime;
  }

  void setTotalTime(double totalTime) {
    this.totalTime = totalTime;
  }

  double getTotalTime() {
    return totalTime;
  }

  void setServings(double servings) {
    this.servings = servings;
  }

  double getServings() {
    return servings;
  }

  void setIngredientsGlossary(List<String> ingredients) {
    this.ingredientsGlossary = ingredients;
  }

  List<String> getIngredientsGlossary() {
    return ingredientsGlossary;
  }

  void setIngredientsList(List<List<String>> ingredientsList) {
    this.ingredientsList = ingredientsList;
  }

  List<List<String>> getIngredientsList() {
    return ingredientsList;
  }

  setAmount(List<List<double>> amount) {
    this.amount = amount;
  }

  List<List<double>> getAmount() {
    return amount;
  }

  void setUnit(List<List<String>> unit) {
    this.unit = unit;
  }

  List<List<String>> getUnit() {
    return unit;
  }

  void setVegetable(Vegetable vegetable) {
    this.vegetable = vegetable;
  }

  Vegetable getVegetable() {
    return vegetable;
  }

  void setSteps(List<String> steps) {
    this.steps = steps;
  }

  List<String> getSteps() {
    return steps;
  }

  void setNotes(String notes) {
    this.notes = notes;
  }

  String getNotes() {
    return notes;
  }
}
