import 'package:flutter/material.dart';

enum Vegetable { non_vegetarian, vegetarian, vegan }

class Recipe {
  String name;
  Image image;
  double preperationTime;
  double cookingTime;
  double totalTime;
  double portions;
  List<String> ingredients;
  Map<String, double> amount;
  Map<String, String> unit;
  Vegetable vegetable;
  List<String> steps;
  String notes;
  // TODO: add categories

  Recipe() {
    // if no image => placeholder image
  }

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

  void setPortions(double portions) {
    this.portions = portions;
  }

  double getPortions() {
    return portions;
  }

  void setIngredients(List<String> ingredients) {
    this.ingredients = ingredients;
  }

  List<String> getIngredients() {
    return ingredients;
  }

  setAmount(Map<String, double> amount) {
    this.amount = amount;
  }

  Map<String, double> getAmount() {
    return amount;
  }

  void setUnit(Map<String, String> unit) {
    this.unit = unit;
  }

  Map<String, String> getUnit() {
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
